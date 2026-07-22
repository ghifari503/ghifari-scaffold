#!/usr/bin/env bash
set -euo pipefail

TARGET_REPO=""
USE_ACTIVE_ROUTE="false"
INSTALL_DEPS="false"
FORCE="false"

for arg in "$@"; do
  case "$arg" in
    --target=*)
      TARGET_REPO="${arg#*=}"
      ;;
    --use-active-route)
      USE_ACTIVE_ROUTE="true"
      ;;
    --install-deps)
      INSTALL_DEPS="true"
      ;;
    --force)
      FORCE="true"
      ;;
  esac
done

FRAMEWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURRENT_PHASE_PATH="$FRAMEWORK_ROOT/docs/CURRENT_PHASE.md"

if [[ "$USE_ACTIVE_ROUTE" == "true" ]]; then
  ACTIVE_FRONTEND_ROOT="$(python - "$CURRENT_PHASE_PATH" <<'PY'
import re
import sys
from pathlib import Path
content = Path(sys.argv[1]).read_text()
match = re.search(r"^- active_frontend_root: `(.*)`$", content, re.MULTILINE)
print(match.group(1) if match else "")
PY
)"
  if [[ -z "$ACTIVE_FRONTEND_ROOT" || "$ACTIVE_FRONTEND_ROOT" == "not_selected" ]]; then
    echo "[error] Active frontend route not set. Run activate-development-route first." >&2
    exit 1
  fi
  REPO_PATH="$FRAMEWORK_ROOT/$ACTIVE_FRONTEND_ROOT"
elif [[ -n "$TARGET_REPO" ]]; then
  REPO_PATH="$(cd "$TARGET_REPO" && pwd)"
else
  echo "[error] Usage: bash scripts/scaffold-playwright.sh --target=/path/to/app [--use-active-route] [--install-deps] [--force]" >&2
  exit 1
fi

PACKAGE_JSON="$REPO_PATH/package.json"

detect_package_manager() {
  if [[ -f "$REPO_PATH/pnpm-lock.yaml" ]]; then
    echo "pnpm"
  elif [[ -f "$REPO_PATH/yarn.lock" ]]; then
    echo "yarn"
  elif [[ -f "$REPO_PATH/bun.lockb" ]]; then
    echo "bun"
  else
    echo "npm"
  fi
}

copy_template() {
  local src="$1"
  local dest="$2"

  if [[ -f "$dest" && "$FORCE" != "true" ]]; then
    echo "[info] Skip existing file: $dest"
    return
  fi

  cp "$src" "$dest"
  echo "[info] Created: $dest"
}

PKG_MANAGER="not_detected"
if [[ -f "$PACKAGE_JSON" ]]; then
  PKG_MANAGER="$(detect_package_manager)"
  echo "[info] Detected package manager: $PKG_MANAGER"
else
  echo "[info] package.json not found in target path, scaffolding files only."
fi

mkdir -p \
  "$REPO_PATH/playwright/e2e" \
  "$REPO_PATH/playwright/fixtures" \
  "$REPO_PATH/playwright/.auth" \
  "$REPO_PATH/artifacts/qa/playwright/report" \
  "$REPO_PATH/artifacts/qa/playwright/test-results" \
  "$REPO_PATH/artifacts/qa/playwright/.playwright-cli"

copy_template "$FRAMEWORK_ROOT/templates/qa/playwright.config.ts.example" "$REPO_PATH/playwright.config.ts"
copy_template "$FRAMEWORK_ROOT/templates/qa/auth-login.functional.spec.ts.example" "$REPO_PATH/playwright/e2e/auth-login.functional.spec.ts"

if [[ -f "$PACKAGE_JSON" ]]; then
node - "$PACKAGE_JSON" "$FORCE" <<'NODE'
const fs = require('fs');
const packageJsonPath = process.argv[2];
const force = process.argv[3] === 'true';
const pkg = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
pkg.scripts = pkg.scripts || {};
const scripts = {
  'test:e2e': 'playwright test',
  'test:e2e:ui': 'playwright test --ui',
  'test:e2e:debug': 'playwright test --debug',
  'test:e2e:headed': 'playwright test --headed',
  'test:e2e:report': 'playwright show-report artifacts/qa/playwright/report',
};
for (const [key, value] of Object.entries(scripts)) {
  if (!(key in pkg.scripts) || force) {
    pkg.scripts[key] = value;
  }
}
fs.writeFileSync(packageJsonPath, JSON.stringify(pkg, null, 2) + '\n');
NODE

echo "[info] Updated package.json scripts"
fi

if [[ "$INSTALL_DEPS" == "true" ]]; then
  if [[ ! -f "$PACKAGE_JSON" ]]; then
    echo "[error] Cannot install Playwright dependencies because package.json is missing at $REPO_PATH" >&2
    exit 1
  fi
  pushd "$REPO_PATH" >/dev/null
  case "$PKG_MANAGER" in
    pnpm)
      pnpm add -D @playwright/test
      pnpm exec playwright install
      ;;
    yarn)
      yarn add -D @playwright/test
      yarn playwright install
      ;;
    bun)
      bun add -d @playwright/test
      bunx playwright install
      ;;
    *)
      npm install -D @playwright/test
      npx playwright install
      ;;
  esac
  popd >/dev/null
fi

echo
echo "Playwright scaffold complete."
echo "Target repo       : $REPO_PATH"
echo "Package manager   : $PKG_MANAGER"
echo "Config            : playwright.config.ts"
echo "Playwright root   : playwright/"
echo "Artifact root     : artifacts/qa/playwright/"
echo "Example test      : playwright/e2e/auth-login.functional.spec.ts"
echo "Report output     : artifacts/qa/playwright/report/"
echo "Run output        : artifacts/qa/playwright/test-results/"
echo "CLI log output    : artifacts/qa/playwright/.playwright-cli/"
echo
echo "Next steps:"
echo "1. Update selectors to match your app (recommended: data-testid)."
echo "2. Start your app locally."
echo "3. Run: npm run test:e2e (or the equivalent package manager command)"
