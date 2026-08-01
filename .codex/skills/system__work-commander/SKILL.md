# Work Commander Skill

## Trigger

Use this skill when the user types:
- `start work`
- `mulai bekerja`
- `begin work`
- `work`
- `start dev`
- `dev`
- `mulai dev`
- `improve`
- `improve skill`
- `cek skill`
- `check skill`

## Canonical Command Source

The complete command list and numbered menu live in:

`COMMANDS.md`

Do not maintain a separate command menu in this skill. When commands change, update `COMMANDS.md` first.

## Behavior

1. Give a brief warm greeting.
2. Read `COMMANDS.md` first to stay aligned with the canonical command behavior.
3. If the user typed only `start work` / `mulai bekerja` / `begin work` / `work`, scan `development/` and list detected project folders as numbered choices.
4. Ask the founder to continue by replying with the project number only.
5. If the user already supplied a project path with `work [path]`, skip the picker and use that target directly.
6. After project selection, read `artifacts/operations/WORKFLOW_STATE.md`, `artifacts/operations/CURRENT_PHASE.md`, `artifacts/operations/CURRENT_TASK.md`, and `artifacts/operations/SESSION_LOG.md`.
7. Show the current parity mode status as `ON` or `OFF`.
8. Show the selected project, current workflow position, active gate, top 1-3 realistic recommendations, and the numbered work menu from `COMMANDS.md`.
9. Do not execute official steps directly from the menu.
10. For menu choices mapped to official steps, transition to the normal pre-step check.
11. For build-related choices, enforce `artifacts/operations/PRE_CODING_GATE.md` before any implementation.
12. If the user typed `start dev` / `dev`, interpret it as local development readiness for the selected or supplied project, not as feature implementation.
13. For `start dev`, report what is already ready, what is missing, what is not yet approved, and the safest next action to get the project runnable locally.
14. If the user typed `improve`, ask whether parity should be `ON` or `OFF` before editing files.
15. Treat parity mode as scaffold-only. Do not interpret parity as permission or obligation to mirror project-level implementation changes across repositories.
16. Never require `I2 Impact Scan` for `start dev` unless local readiness reveals a required source/config/dependency/schema/test/behavior change.
17. Whenever one target project becomes active--through selection, attach, or a resumed session--check its Graphify status with `scripts/graphify-status.ps1`. For `missing`, `stale`, or `present_unverified`, explain that a knowledge graph maps code, documentation, configuration, and project artifacts so an agent can trace architecture, assess change impact, and continue prior work without rereading the repository. For `missing`, state whether Graphify and its `uv` prerequisite are installed, then offer their local setup if required. Ask `Set up, build, or refresh the knowledge graph now? (Y/N)`. Do not install, build, refresh, or scan until the developer answers `Y`; ask a separate confirmation before installing `uv`.
18. For `current`, state that the agent will use the existing local graph with Git-safe shared context, then ask whether to refresh it. Never scan every project under `development/` automatically.
19. Report an installed Graphify version when available. Never upgrade because the master scaffold was pulled; offer `update-graphify-project.ps1 -Update` only after the developer explicitly approves the local update, then require a graph rebuild and shared-context version sync.

## Explicit Command Mapping

| User Command | Action |
|---|---|
| `start work` / `mulai bekerja` / `begin work` / `work` | Start the guided work session by opening the `development/` project picker first, unless a direct project path was supplied. |
| `start dev` / `dev` / `mulai dev` | Check or prepare the selected project's local development readiness. This is a local-run readiness command, not a feature implementation command. |
| `improve` | Transition to `system__improve-commander`; ask whether parity should be `ON` or `OFF`, then propose a plan before editing. |
| `improve skill` | Transition to `system__improve-skill`; propose a plan before editing skills. |
| `cek skill` / `check skill` | Run the skill check policy, normalize new runtime skill prefixes, mirror missing skill folders, and refresh `guardrails/system/SKILL_CATALOG.md`. |

## Notes

- This skill is a gateway command interface, not a step executor.
- The `work` command should feel short for the founder but still controlled through the numbered project picker.
- The `start dev` command should feel like a local-readiness launcher, not like production build or feature build.
- `I2 Impact Scan` is only for scoped project changes, not for ordinary local run readiness.
- Improvement prompts must show parity mode and ask for `ON` or `OFF` before scaffold/process edits.
- Parity mode covers scaffold/process edits only, never project-specific implementation.
- Recommendations must come from current workflow state, not assumptions.
- The command menu must match `COMMANDS.md`.
