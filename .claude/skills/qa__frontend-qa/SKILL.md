---
name: frontend-qa
description: >
  Frontend end-to-end QA skill covering environment audit, installation, configuration,
  test writing, execution, and debugging with Playwright and/or Cypress. Use this when
  the user asks to set up frontend testing, write E2E tests, run suites, debug failed
  browser tests, configure Playwright MCP, or audit frontend quality in an existing or
  inherited project.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Frontend QA Skill

This skill handles the full frontend QA lifecycle:
- environment audit
- tool installation
- MCP setup when available
- test writing
- execution
- debugging

## Main Working Principles

- Always audit before installing or changing dependencies.
- Prefer the testing stack that already exists in the project when it is healthy.
- If neither Playwright nor Cypress exists, default to Playwright for existing projects that do not yet have a stable browser test stack.
- MCP is optional. Continue with CLI-based Playwright or Cypress when MCP is unavailable.
- Keep QA changes scoped to the affected frontend area.

## When To Use This Skill

Use this skill when the user asks for:
- frontend QA audit
- UI regression testing
- smoke testing
- E2E testing
- Playwright setup
- Cypress setup
- browser automation debugging
- frontend test readiness checks

## Audit Checklist

Before changing anything, inspect:
- `package.json`
- lock files such as `pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `bun.lockb`
- frontend roots and test folders
- `playwright.config.*` and `cypress.config.*`
- existing test scripts
- local server requirements
- current package manager

Read supporting references:
- `references/environment-check.md`
- `references/playwright-setup.md`
- `references/cypress-setup.md`
- `references/mcp-setup.md`
- `references/writing-tests.md`
- `references/debugging.md`
- `references/troubleshooting.md`

## Framework Choice Heuristics

- Existing project without a stable browser test stack -> Playwright default
- Existing project that already uses Cypress -> continue with Cypress
- Need strong cross-browser coverage, CI, and traces -> Playwright
- Repo already heavily Cypress -> follow Cypress
- No MCP available -> continue with CLI
- User asks for MCP but the use case is simple -> MCP can stay optional

## Execution Modes

Choose one mode after the audit:
- `full-setup`
- `playwright-only-setup`
- `cypress-only-setup`
- `write-tests`
- `debug-mode`
- `mcp-setup`

## Expected Outputs

- clear audit summary
- chosen QA mode
- minimal required config updates
- scoped browser tests or debugging notes
- no unnecessary changes outside frontend QA scope
