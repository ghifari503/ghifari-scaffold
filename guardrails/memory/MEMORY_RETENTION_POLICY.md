# MEMORY_RETENTION_POLICY

## Purpose
Prevent memory rot by reviewing, pruning, and superseding old entries.

## Review Cadence
- Review memory after `I1 Existing Project Intake`.
- Review memory after `I2 Impact Scan`.
- Review memory after every approved architecture or framework decision.
- Review memory after failed QA, release rollback, or production incident.
- Review old entries when `review_after` has passed.

## Retention Rules
- Keep verified project facts while they remain true.
- Supersede decisions instead of deleting them.
- Mark stale constraints as `obsolete` after the source no longer applies.
- Keep task nodes only while they are active, blocked, or recently completed.
- Keep feature registry entries while the feature/module exists in the target project or remains relevant for migration/history.
- Move low-value repeated notes to `obsolete` rather than expanding the memory surface.
- Update `artifacts/memory/MEMORY_LEDGER.toml`, `MEMORY_INDEX.md`, and the relevant category file together.
- Update `artifacts/memory/FEATURE_REGISTRY.toml` and `FEATURE_REGISTRY.md` together for feature/module state.

## Prune Conditions
Mark memory as `obsolete` when:
- The target repo scan proves it wrong.
- A later decision supersedes it.
- It describes a completed task with no reusable value.
- It duplicates a stronger current source artifact.
- The feature/module no longer exists and has no release, migration, or historical value.
