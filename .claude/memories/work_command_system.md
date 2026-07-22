---
name: Work Command System
description: User's preferred interaction pattern uses `work` for project selection and session status, `start dev` for local development readiness, and parity mode that defaults to OFF unless enabled.
type: feedback
---

## Rule: Use Work Commander For Session Startup

When the user types `start work`, `mulai bekerja`, `begin work`, or `work`, invoke the `work-commander` skill instead of jumping directly into status checks.

When the user types `start dev`, `dev`, or `mulai dev`, interpret it as local development readiness and local run preparation, not feature implementation.

The canonical command list is:

`COMMANDS.md`

## Expected Session Shape

1. Scan `development/` and present numbered project choices, unless the founder already supplied a direct project path.
2. Ask the founder to reply with the project number only.
3. Warm, brief greeting.
4. Show current parity mode status as `ON` or `OFF`.
5. Current status summary from `artifacts/operations/WORKFLOW_STATE.md`, `artifacts/operations/CURRENT_PHASE.md`, `artifacts/operations/CURRENT_TASK.md`, and `artifacts/operations/SESSION_LOG.md`.
6. Top 1-3 recommendations based on current gates and blockers.
7. Numbered command menu from `COMMANDS.md`.

## Local Dev And Parity Rule

- `start dev` = prepare or inspect whether the selected project is ready for local development and local run.
- `build` = scoped implementation work after the gate is open.
- `start dev` must not require `I2 Impact Scan` when the founder only wants to run or prepare the app locally.
- Stop and recommend `I2 Impact Scan` only when local readiness reveals required source/config/dependency/schema/test/behavior changes.
- Before scaffold/process improvements, ask whether parity should be `ON` or `OFF`.
- Default parity mode is `OFF` until the founder explicitly enables it.

## Consistency Rule

Do not maintain a separate menu copy in memory. If command behavior changes, update `COMMANDS.md` first and keep this file as a pointer.
