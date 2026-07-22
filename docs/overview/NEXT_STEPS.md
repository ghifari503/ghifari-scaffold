# NEXT_STEPS

This document is the short list of next actions for onboarding an existing or inherited project with this scaffold.

## Current Status
- The repository should be treated as an existing-project operating scaffold, not a greenfield starter.
- The active workflow gate should begin with intake and impact scan.
- The current project stack, routes, constraints, and QA maturity may still be unknown.
- The scaffold is ready to use, but it must first be aligned to the real project you want to manage.

## Immediate Next Steps
1. Use the canonical command list in root `COMMANDS.md`.
2. Fill the base project context:
   - `artifacts/context/PROJECT_CONTEXT.md`
   - `artifacts/context/BUSINESS_CONTEXT.md`
   - `artifacts/context/PRODUCT_SCOPE.md`
   - `artifacts/context/STARTUP_MODE.md`
3. Define one active task in `artifacts/operations/CURRENT_TASK.md`.
4. Update `artifacts/operations/CURRENT_PHASE.md` and `artifacts/operations/WORKFLOW_STATE.md` so they reflect existing-project onboarding.
5. Run `I1 Existing Project Intake`:
   - summarize repo purpose
   - identify frontend/backend/test stack
   - identify active routes and major modules
   - record inherited constraints
6. Run `I2 Impact Scan`:
   - define the exact feature, bugfix, migration, redesign, revamp, refactor, or module scope
   - list impacted pages, endpoints, docs, and tests
7. If business intent is still unclear, continue with `P1 Founder Interview`.
8. Continue with `P2 Requirements` and `P3 User Flows` only for the scoped change.
9. If UI is impacted, run `P4 Design Mapping` and `P5 Design Complete` only for affected pages/sections.
10. Run `P6 Architecture` only if the change affects architecture, contracts, data shape, or system boundaries.
11. Run `P7 Sprint Plan` and then build in scoped order:
   - `B2 Frontend Build` first when UI is involved
   - finalize API delta
   - `B1 Backend Build`
   - `B3 IoT Build` if relevant

## Recommended First Working Session
1. State what the current project already does.
2. Identify what change you want to make first.
   - this can be a feature, redesign, flow change, refactor, migration, or cleanup slice
3. Record the existing framework, package manager, database, and test stack.
4. Mark the active frontend/backend roots.
5. Write the impact scan before changing code.

## Build Readiness Checklist
- [ ] Project context is filled
- [ ] Current task is clearly defined
- [ ] Existing project intake is documented
- [ ] Impact scan exists
- [ ] Requirement delta exists
- [ ] Core affected flow exists
- [ ] Design source exists or can be generated for affected UI
- [ ] Architecture decision is approved or explicitly unchanged
- [ ] Framework decision is approved or explicitly unchanged
- [ ] Active development route is confirmed
- [ ] Sprint scope is narrowed to a clear feature or module

## Important Notes
- Do not replace the existing framework stack unless the founder explicitly approves it.
- `development/` should remain empty until the real existing-project route or import target is confirmed.
- Do not start backend work before the main frontend behavior and states are validated when UI changes are involved.
- Use one feature, fix, migration, or module per iteration so risk and scope remain controlled.
- For redesign or refactor work, break the rollout into safe slices unless a wider cutover is explicitly approved.
- Update `artifacts/operations/SESSION_LOG.md` and `artifacts/operations/WORKFLOW_STATE.md` after each official step.

## Suggested Next Command
`Start the existing-project onboarding flow and map the current stack before planning changes.`

