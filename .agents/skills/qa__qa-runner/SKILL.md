---
name: qa-runner
description: >
  Run automated QA for validated features using Playwright as the default functional
  and E2E platform. Use this skill when the user asks to automate form testing,
  input validation checks, login flow testing, regression testing, integration QA,
  smoke testing, or wants to stop checking UI functionality manually. Trigger this
  skill for official QA step execution (`R2`) and whenever frontend/backend/integration
  behavior needs browser-based verification with repeatable evidence.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# QA Runner Skill

This skill handles automated functional QA with **Playwright as the default platform**.
Use it to replace manual repetitive checking such as:

- filling forms
- checking validation states
- verifying disabled/loading behavior
- checking success/error flows
- testing redirect/navigation after submit
- smoke testing core journeys

If a repo already uses Cypress, you may continue with Cypress. Otherwise, default to Playwright.

---

## Primary Goal

Turn validated requirements, flows, and UI specs into repeatable automated QA evidence.

This skill should:

1. Audit the project test environment
2. Confirm the target feature and acceptance criteria
3. Prefer Playwright for new automation
4. Write or update functional/E2E tests
5. Run the smallest meaningful suite first
6. Capture results into `artifacts/test/`
7. Distinguish confirmed failures from hypotheses

---

## Default Platform Policy

### Default
- Use **Playwright** for new automation work

### Continue Existing Tooling
- If the project already has active Cypress tests and config, continue with Cypress unless there is a strong reason to migrate

### Why Playwright Default
- strong functional form testing
- reliable auto-waiting and assertions
- first-class trace/report tooling
- good fit for frontend-first QA gates

---

## Required Inputs

Before running automation, read:

1. `artifacts/operations/WORKFLOW_STATE.md`
2. `artifacts/operations/CURRENT_TASK.md`
3. `artifacts/operations/CURRENT_PHASE.md`
4. `artifacts/architecture/framework-decision.md`
5. `guardrails/system/SKILL_CATALOG.md`
4. feature acceptance criteria from:
   - `artifacts/prd/`
   - `artifacts/flows/`
5. design references if UI-related:
   - `artifacts/design/[page]/[section]/[sub-section]/`
6. prior QA artifacts if they exist:
   - `artifacts/test/[feature]-frontend-qa.md`
   - `artifacts/test/[feature]-integration-qa.md`
   - `artifacts/test/[feature]-e2e-qa.md`

7. active route contract:
   - `architecture_style`
   - `development_route`
   - `active_frontend_root`
   - `active_backend_root`
8. active framework/database contract:
   - `frontend_framework`
   - `backend_framework`
   - `primary_database`
   - `testing_stack`

---

## Execution Flow

### Step 1: Environment Audit

Check:
- `package.json`
- lockfile
- `playwright.config.*`
- `cypress.config.*`
- test directories such as `playwright/`, `tests/`, `e2e/`, `cypress/`
- scripts like `test:e2e`, `test:qa`, `dev`, `start`
- app-under-test location derived from active route, not guessed manually

If no framework exists:
- recommend Playwright
- scaffold from template references in this skill or `templates/qa/`

If active route is missing or inconsistent across architecture/state docs:
- stop
- mark QA as blocked by routing ambiguity
- request route alignment before continuing

### Step 2: Select QA Scope

Choose the smallest scope that verifies the real behavior:

- `frontend-functional`
- `integration`
- `e2e-smoke`

Prefer feature-level scope such as:
- `auth-login`
- `checkout-submit-order`
- `profile-update`

Do not run the entire app test universe unless the founder explicitly asks for that.

### Step 3: Build Test Coverage

Functional QA should cover:

1. valid input path
2. invalid input path
3. required field validation
4. loading/disabled states
5. success result
6. error result
7. critical redirect/navigation behavior

If design specs define states, test them against the documented behavior.

### Step 4: Prefer Stable Selectors

Use:
- `data-testid`
- semantic roles
- labels

Avoid fragile selectors based on layout or styling.

### Step 5: Execute

Run the narrowest suite first:

```bash
npx playwright test playwright/e2e/auth-login.spec.ts
```

Then expand only if needed.

### Step 6: Record Evidence

Always update or create:

- `artifacts/test/[feature]-frontend-qa.md`
- `artifacts/test/[feature]-integration-qa.md`
- `artifacts/test/[feature]-e2e-qa.md`
- `artifacts/test/[feature]-bug-log.md`
- `artifacts/test/[feature]-bug-status.md`

Use the logging standard and timestamp fields.

---

## Pass / Fail Rules

### PASS
- required test cases pass
- no blocker bug remains open
- artifacts updated with evidence

### FAIL
- functional flow breaks
- validation behavior contradicts acceptance criteria
- required states are missing
- test environment is broken and no reliable result is available

If the environment is broken, say so clearly. Do not fake a QA pass.

---

## Recommended Output Structure

For substantial QA tasks, report:

1. Objective
2. Scope
3. Environment Status
4. Tests Run
5. Results
6. Bugs Found
7. Artifacts Updated
8. Exact Next Step

---

## Reference Files

Read these only when needed:

- `references/platform-decision.md`
- `references/playwright-functional-test.example.ts`
- `references/e2e-qa-report-template.md`
- `references/data-testid-guidelines.md`

If the repo already has a more specific frontend QA setup, coordinate with `qa__frontend-qa`.

