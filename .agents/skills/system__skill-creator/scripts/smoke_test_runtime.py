#!/usr/bin/env python3
"""Smoke test dual-runtime resolution for skill-creator tooling."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

CURRENT_DIR = Path(__file__).resolve().parent
PACKAGE_ROOT = CURRENT_DIR.parent
if str(PACKAGE_ROOT) not in sys.path:
    sys.path.insert(0, str(PACKAGE_ROOT))

from scripts.run_eval import find_project_root
from scripts.runtime_adapter import resolve_runtime, runtime_probe


def main() -> None:
    parser = argparse.ArgumentParser(description="Smoke test runtime resolution for skill tooling")
    parser.add_argument("--timeout", type=int, default=15, help="Timeout for runtime version probe")
    parser.add_argument("--json", action="store_true", help="Print machine-readable JSON only")
    args = parser.parse_args()

    project_root = find_project_root()
    try:
        config = resolve_runtime(project_root, __file__)
        probe = runtime_probe(config, timeout=args.timeout)
    except Exception as exc:
        probe = {
            "cli": None,
            "cli_found": False,
            "cli_path": None,
            "commands_dir": None,
            "commands_dir_exists": False,
            "env_guard_vars": [],
            "strict_variant": False,
            "version": None,
            "version_error": str(exc),
            "capabilities": {},
        }

    if args.json:
        print(json.dumps(probe, indent=2))
        return

    print("Runtime smoke test")
    print(f"- CLI: {probe['cli']}")
    print(f"- CLI found: {probe['cli_found']}")
    print(f"- CLI path: {probe['cli_path'] or 'not found'}")
    print(f"- Commands dir: {probe['commands_dir']}")
    print(f"- Commands dir exists: {probe['commands_dir_exists']}")
    print(f"- Guard env vars: {', '.join(probe['env_guard_vars']) or '(none)'}")
    print(f"- Strict variant: {probe['strict_variant']}")
    if probe.get("version"):
        print(f"- Version: {probe['version']}")
    if probe.get("version_error"):
        print(f"- Version probe: {probe['version_error']}")
    if probe.get("capabilities"):
        print("- Capability checks:")
        for name, details in probe["capabilities"].items():
            status = "OK" if details.get("ok") else "FAIL"
            detail = details.get("sample_output") or details.get("error") or ""
            print(f"  - {name}: {status} {detail}".rstrip())

    if not probe["cli_found"]:
        sys.exit(1)


if __name__ == "__main__":
    main()
