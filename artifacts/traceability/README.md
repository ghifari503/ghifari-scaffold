# Internal ODN Traceability Authority

`MASTER_SCAFFOLD_SCHEMA.json` is the shared schema authority. Each target project uses `artifacts/traceability/[project]/` for identity-free ODN batch state, records, mappings, project adoption, migration state/evidence, migration receipts, and internal handoff. This directory belongs to the Master Scaffold and must never be copied into a target repository.

Migration is once per project per schema version. A matching completed adoption uses the fast path; missing, older, failed, or in-progress adoption uses dry-run then the guarded schema migration/recovery path. Routing decisions are ephemeral and never stored here.

Use `guardrails/development/ODN_TRACEABILITY_POLICY.md` and `scripts/odn-traceability.ps1` or `.sh`. Do not load every project or batch by default.
