# QA Platform Decision

## Default Rule

Use **Playwright** as the default automation platform for:
- form testing
- functional input validation testing
- login/auth flows
- smoke/E2E journeys
- browser-based regression checks

## Continue Cypress Only When

- the project already has stable Cypress coverage
- the team already uses Cypress in CI
- migration would slow delivery without meaningful benefit

## Why Playwright Wins by Default

- reliable built-in auto-waiting
- strong tracing and debugging support
- good browser coverage
- good fit for frontend-first validation

## Minimum Automation Coverage

For each important feature:

1. happy path
2. invalid input path
3. required field errors
4. loading/disabled behavior
5. success state
6. failure state
7. navigation or redirect outcome
