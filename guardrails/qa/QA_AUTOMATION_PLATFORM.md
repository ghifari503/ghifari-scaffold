# QA Automation Platform

## Default Recommendation

Use **Playwright** as the default platform for automated functional testing in this system.

It is the recommended way to automate repetitive manual checks such as:
- input validation
- login flow
- form submission
- disabled/loading states
- error/success messages
- redirect/navigation checks

## Platform Policy

### Default for New Projects
- Playwright

### Continue Existing Projects With
- Cypress, if the project is already stable and committed to Cypress

## Why Playwright

- reliable actionability and auto-wait behavior
- strong reports, screenshots, traces
- good browser coverage
- strong fit for frontend-first QA gates

## Integration Points

### Project-Level Test Files
- `playwright.config.ts`
- `playwright/e2e/[feature].spec.ts`
- `playwright/fixtures/`
- `artifacts/qa/playwright/report/`
- `artifacts/qa/playwright/test-results/`
- `artifacts/qa/playwright/.playwright-cli/`

### Prepared Artifact Folder Rule
- Prepare `artifacts/qa/playwright/` before the first Playwright run.
- Do not wait for the runner to create the folder implicitly after execution starts.
- Keep Playwright test source in `playwright/` and keep runtime artifacts in `artifacts/qa/playwright/`.

### Route-Aware Target Resolution
- Resolve the app-under-test from the active route contract in:
  - `artifacts/operations/CURRENT_PHASE.md`
  - `artifacts/operations/WORKFLOW_STATE.md`
- Do not assume a fixed app location when the architecture route has already chosen one.

### Fast Scaffold Helpers
- Windows PowerShell:
  - `scripts/scaffold-playwright.ps1 -TargetRepo D:\path\to\app -InstallDeps`
  - `scripts/scaffold-playwright.ps1 -UseActiveRoute`
- Bash:
  - `bash scripts/scaffold-playwright.sh --target=/path/to/app --install-deps`
  - `bash scripts/scaffold-playwright.sh --use-active-route`

### Documentation-Level Evidence
- `artifacts/test/[feature]-frontend-qa.md`
- `artifacts/test/[feature]-integration-qa.md`
- `artifacts/test/[feature]-e2e-qa.md`
- `artifacts/test/[feature]-bug-log.md`
- `artifacts/test/[feature]-bug-status.md`

## Minimum Functional Coverage

For any important feature, automated QA should cover:

1. required fields
2. invalid input
3. valid submission
4. loading state
5. error state
6. success state
7. post-submit navigation outcome

## Selector Rule

Prefer:
- semantic roles
- labels
- `data-testid`

Avoid style-based selectors.

## Workflow Placement

The default QA automation path in this system is:

1. frontend implemented
2. frontend QA
3. API contract finalized
4. backend built
5. integration QA
6. automated E2E QA with Playwright
7. release prep only after evidence is written

## Important Limitation

This repository is a workflow framework, not a runnable application.
So this document defines the default platform and integration pattern.
The actual Playwright package installation and test execution happen in the product repo generated or managed with this framework.

## Framework Gate Dependency

Do not run app-specific Playwright bootstrap until the framework decision is approved.

Required before real scaffold:
- active route selected
- frontend framework selected
- package manager selected

See:
- `guardrails/architecture/FRAMEWORK_SELECTION_RULES.md`
- `templates/framework_decision_template.md`

