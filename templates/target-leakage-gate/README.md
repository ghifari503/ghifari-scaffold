# Target Leakage Gate Template (Opt-In)

Reusable, standalone template that a target repository can adopt so its own Git history stays free of explicit AI/runtime/process traces after the ODN first-adoption migration completes. The Master Scaffold never installs or modifies these files in a target automatically; adoption is a separate, explicit, founder-approved step performed from inside the target repository.

## Files

- `odn-leakage-scan.mjs`: standalone scanner (no dependency on the Master Scaffold path or `odn-traceability.mjs`). Scans the whole working tree by default, or only staged files with `--staged`, excluding `.git`, `node_modules`, `dist`, `build`, `coverage`, `.next`, and `graphify-out`.
- `pre-commit`: local Git hook that blocks a commit introducing a reserved internal filename/path or an explicit AI/runtime/process trace term.
- `odn-leakage-gate.yml`: GitHub Actions workflow running the same scan on pull requests and pushes to `main`.

## Adoption Steps

1. Copy `odn-leakage-scan.mjs` into the target repository, for example `scripts/odn-leakage-scan.mjs`.
2. Copy `pre-commit` to `.git/hooks/pre-commit` (or to `.githooks/pre-commit` and run `git config core.hooksPath .githooks`), then make it executable.
3. Copy `odn-leakage-gate.yml` to `.github/workflows/odn-leakage-gate.yml` if the target uses GitHub Actions.
4. Confirm `node scripts/odn-leakage-scan.mjs` reports `"status": "PASS"` against the current working tree before relying on the hook.

## Scope

This template only prevents *new* leakage going forward. It does not replace:

- the ODN first-adoption/migration guardrail in `guardrails/development/ODN_TRACEABILITY_POLICY.md`, which must classify and migrate existing internal state first;
- a Git history scan (`odn-traceability.mjs history-scan`) for traces already committed before adoption, which is reported as `HISTORY_PURGE_REQUIRED` and never rewritten without separate founder approval.
