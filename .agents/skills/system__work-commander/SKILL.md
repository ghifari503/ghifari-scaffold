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
- `version`

## Canonical Command Source

The complete command list and numbered menu live in:

`COMMANDS.md`

Do not maintain a separate command menu in this skill. When commands change, update `COMMANDS.md` first.

## Behavior

1. Give a brief warm greeting.
2. Read `COMMANDS.md` first to stay aligned with the canonical command behavior.
2a. Before executing any action command or task, run `scripts/check-scaffold-freshness.ps1` on Windows or `scripts/check-scaffold-freshness.sh` on Bash. Read the reported core rules and operational snapshot on the first action; on later actions, reload only sources whose fingerprint changed. This check is local and read-only: never run `git fetch` or `git pull` automatically.
3. If the user typed only `start work` / `mulai bekerja` / `begin work` / `work`, scan `development/` and list detected project folders as numbered choices.
4. Ask the founder to continue by replying with the project number only.
5. If the user already supplied a project path with `work [path]`, skip the picker and use that target directly.
5a. Immediately after a target is selected or resumed, run `scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]` (or `.sh`) in read-only mode whenever the local scaffold fingerprint/version changed after a pull, and also on a target's first activation in that session. Report the result before continuing target work. The script performs the required ODN migration classification when adoption is incomplete. A non-ready result blocks implementation, QA closure, handoff, and `resume_safe`; never run `-Apply`, copy scaffold files, or change target source without separate founder approval.
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
17. Whenever one target project becomes active--through selection, attach, or a resumed session--check its Graphify status with `scripts/graphify-status.ps1`. For a missing CLI or graph, explain the benefit and request setup/build approval; ask a separate confirmation before installing `uv`. Once Graphify is installed, refresh only the active target with `/graphify . --update` after each meaningful source, configuration, documentation, dependency, or shared-context delta. Never run Graphify project installation, platform installation, or always-on registration: master scaffold instructions apply to Codex, Claude, and Gemini.
18. Refresh once per meaningful delta, never after an unchanged retry or read-only check. Use targeted queries with the smallest adequate context budget, and block `resume_safe`, QA closure, handoff, and PR readiness when an installed graph remains stale without a recorded blocker. Never scan every project under `development/` automatically.
19. Report an installed Graphify version when available. Never upgrade because the master scaffold was pulled; offer `update-graphify-project.ps1 -Update` only after the developer explicitly approves the user-level update, then require a graph rebuild and shared-context version sync. Keep only `graphify-out/` local to the selected target; never generate Graphify runtime sidecars or root agent files there.
20. Before any target-repository task begins, verify that Playwright and required browser binaries are installed and usable, including for backend-only, native Flutter, firmware, and other non-browser targets. A missing prerequisite blocks task start: report the exact target-specific dependency/browser install command and obtain founder approval before installing. Gemini CLI and Gemini/Antigravity must always run Playwright headlessly (`headless: true`) and never use `--headed`.
21. If the user typed `version`, read `SCAFFOLD_VERSION.md` and report its current version, release date, status, and semantic-versioning policy. Do not start a workflow or modify files.
22. For every task, apply `guardrails/development/ODN_TRACEABILITY_POLICY.md` after normal task classification. Target `artifacts/shared/` is client-safe only; internal lifecycle, handoff, routing, traceability, contributor/process, and development-state metadata resolves from `artifacts/traceability/[project]/`.
23. On a target's first scaffold-update adoption, run the ODN shared-artifact migration in dry-run mode. Preserve `client_safe` artifacts. Do not remove `internal_process_state` until an explicitly approved apply has copied and hash-verified it, passed every required check, installed prevention rules, and reported Git-history leakage without rewriting history.

## Explicit Command Mapping

| User Command | Action |
|---|---|
| `start work` / `mulai bekerja` / `begin work` / `work` | Start the guided work session by opening the `development/` project picker first, unless a direct project path was supplied. |
| `start dev` / `dev` / `mulai dev` | Check or prepare the selected project's local development readiness. This is a local-run readiness command, not a feature implementation command. |
| `improve` | Transition to `system__improve-commander`; ask whether parity should be `ON` or `OFF`, then propose a plan before editing. |
| `improve skill` | Transition to `system__improve-skill`; propose a plan before editing skills. |
| `cek skill` / `check skill` | Run the skill check policy, normalize new runtime skill prefixes, mirror missing skill folders, and refresh `guardrails/system/SKILL_CATALOG.md`. |
| `version` | Report the master scaffold version from `SCAFFOLD_VERSION.md` without starting a workflow. |

## Notes

- This skill is a gateway command interface, not a step executor.
- The `work` command should feel short for the founder but still controlled through the numbered project picker.
- The `start dev` command should feel like a local-readiness launcher, not like production build or feature build.
- `I2 Impact Scan` is only for scoped project changes, not for ordinary local run readiness.
- Improvement prompts must show parity mode and ask for `ON` or `OFF` before scaffold/process edits.
- Parity mode covers scaffold/process edits only, never project-specific implementation.
- Recommendations must come from current workflow state, not assumptions.
- The command menu must match `COMMANDS.md`.
