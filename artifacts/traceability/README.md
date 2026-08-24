# Internal ODN Traceability Authority

`MASTER_SCAFFOLD_SCHEMA.json` in this directory is the shared, Git-carried schema authority. Its positive integer `schema_version` is the only thing this directory stores; it never contains per-project state.

Every per-project record — ODN batch state, records, mappings, project adoption, migration state/evidence, migration receipts, and internal handoff — lives at `artifacts/traceability-local/[project]/`. That directory is Git-ignored by `.gitignore` (`/artifacts/traceability-local/`) and must never be committed to the Master Scaffold repository or copied into a target repository.

Migration is once per project per schema version. A matching completed adoption uses the fast path; missing, older, failed, or in-progress adoption uses dry-run then the guarded schema migration/recovery path. Routing decisions are ephemeral and never stored here.

Use `guardrails/development/ODN_TRACEABILITY_POLICY.md` and `scripts/odn-traceability.mjs`. Do not load every project or batch by default.
