# Master Framework Update Contract

## Purpose

Update an active Master Framework without pulling into its root, changing a Working Project, or silently overwriting local framework state.

## Two-Stage Model

1. **Obtain:** clone once or pull the official Master Scaffold in the isolated, Git-ignored repository `development/_framework-updater/`.
2. **Adopt:** run `development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot .` from the Master Framework root. Dry-run is mandatory; apply requires the exact current report id.

Receiving updater commits never applies them to the Master Framework. The first freshness check after a newer updater is present reports `update_available` and the runtime must offer `update framework`. It must not fetch, pull, or apply automatically.

## Repository Authority

- `development/_framework-updater/` may only fetch or pull from `https://github.com/odonplay/odonplay-agent-scaffold`.
- The updater's origin/branch/clean/remote-tracking checks establish local consistency, not cryptographic release provenance. Bootstrap trust comes from cloning through authenticated GitHub HTTPS or a pre-verified official SSH host key and using only `pull --ff-only`; never rewrite `refs/remotes/origin/main`, execute a copied updater, or accept updater files through chat/archive transfer.
- It is infrastructure, not a Working Project. Never select it for intake, ODN, Graphify, implementation, QA, handoff, commit, or push.
- A Master Framework root must never run `git pull` against the Master Scaffold origin.
- The canonical Master Scaffold at `E:\www\project-scaffold` must never be an updater target.

## Protected Local State

An update must not copy into, delete, stage, commit, or otherwise modify:

- every `artifacts/` path containing framework/project state, including logs, memory, traceability, access records, and operational state;
- `plan/`;
- `dev-doc/`;
- any path under `development/`, including Working Projects and the updater itself;
- `.project-scaffold.json` except for updater-owned installation status after a successful apply;
- runtime-local configuration such as `.codex/model-routing.local.json` and non-example `.env` files;
- any nested Git metadata or index.

Generic runtime rules and skills in `.codex/`, `.claude/`, and `.agents/` are updateable scaffold material. Only their explicitly local configuration is protected.

The sole `artifacts/` exception is updater-owned local transaction data under `artifacts/framework-update/`: its lock, `STATE.json`, manifests, and recoverable snapshots. The updater may modify only this exception and it remains ignored by Git.

## Legacy And Baseline Detection

- Missing or invalid `SCAFFOLD_VERSION.md` means `legacy_unversioned`; it is not treated as version 1.0.0.
- A legacy active root Git repository supplies the comparison baseline only. Its commit must be an ancestor available in the official updater history.
- After first adoption, `artifacts/framework-update/STATE.json` is the baseline authority and root Git remains inactive.
- Missing, invalid, or divergent baselines fail closed and require manual review.

## Conflict And Transaction Rules

- Compare only generic paths changed between the installed baseline and updater source.
- If a changed generic path also differs locally from its installed baseline, stop before mutation and report the exact conflict paths.
- Never auto-merge, create conflict markers, discard local changes, or infer which version should win.
- Snapshot every changed destination and prior updater-owned local metadata before writing.
- Write through a temporary file, validate installed hashes, and archive root Git only after generic-file validation succeeds.
- On an apply failure, restore the snapshot and reactivate root Git only when it was archived by that failed transaction.
- A deliberate later rollback may restore generic files and prior update state, but must not reactivate root Git.

## Completion

A successful apply must install and hash-validate generic scaffold changes, write versioned local state, fully unstage and archive a legacy root Git directory, update the local marker, and confirm `target_project_mutation: none`. Standard scaffold validation is a release-publication responsibility in the canonical Master Scaffold; it is not rerun inside an active team's Master Framework. A published release must not reach `origin/main` unless those standard validations passed.

User instructions are in `docs/HOW_TO_UPDATE_MASTER_FRAMEWORK.md`.
