# Scaffold Freshness Policy

## Purpose

Ensure every action command or task starts from the newest locally available scaffold rules and operational status without repeatedly scanning the full scaffold or using the network.

## Mandatory Lightweight Check

Before executing any action command, official step, task, source scan, install, test, build, or scaffold change, every runtime must run the local freshness helper:

- Windows: `scripts/check-scaffold-freshness.ps1`
- Bash: `scripts/check-scaffold-freshness.sh`

The helper reports a fingerprint for the local Git HEAD, core runtime rules, and the small operational-status snapshot. It performs no network activity, does not run `git fetch` or `git pull`, and does not modify the scaffold or a target repository.

## Efficient Read Rule

- At the first action in a session, read `AGENTS.md`, `COMMANDS.md`, `SCAFFOLD_VERSION.md`, and the reported operational snapshot.
- On later actions, compare the current helper fingerprint to the session's last accepted fingerprint. If it is unchanged, reuse the already loaded context and do not rescan or reread the full rule set.
- If the fingerprint changed, reload the changed core source and its relevant status artifact before execution. After task classification, load only the task-specific guardrails, skills, and policies required by that task.
- A fresh local fingerprint means locally available scaffold content only. Checking whether an upstream remote has new commits requires an explicit founder-approved network action and is never automatic.

## Required Sources

The helper fingerprints:

- `AGENTS.md`
- `COMMANDS.md`
- `SCAFFOLD_VERSION.md`
- `artifacts/operations/WORKFLOW_STATE.md`
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/CURRENT_TASK.md`
- `artifacts/operations/SESSION_LOG.md`
- the metadata and current snapshot of `artifacts/operations/AGENT_ACTIVITY_LOG.md`

## Stop Condition

Do not execute the requested action when the helper cannot read a required source or a changed required source has not been reloaded. Report the exact missing source or read failure.
