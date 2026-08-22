# Internal Continuity Identity Policy

## Strict Rule

Master Scaffold internal continuity is opaque. Traceability, activity, handoff, lifecycle, adoption, migration, routing evidence, and process-state artifacts must not persist a runtime, provider, model, agent, engineer, or generative-process identity.

This rule applies to field names, values, filenames, identifiers, templates, examples, and generated records. It does not prevent a runtime from making an ephemeral local execution decision; that decision must not be written to a Git-carried or Master Scaffold continuity artifact.

## Allowed Neutral Fields

Use work-oriented fields only: `contributor_role`, `work_state`, `task_id`, `batch_id`, `component`, `scope`, `status`, `completed`, `remaining`, `blockers`, `validation`, `evidence`, and `next_context` or `next_exact_step`.

`contributor_role` describes the work function, for example `implementation`, `review`, `qa`, `planning`, or `manual`. It must never encode a runtime, person, vendor, model, profile, or agent name.

## Routing Boundary

Routing policies may define local selection behavior, but their decision is ephemeral. Do not create `AI_ROUTING_LOG.md`, routing identity records, model/profile fields, model-source fields, token/cost fields, or identity-bearing activity events. A blocked local selection is reported to the founder in the current conversation and recorded only as a neutral work blocker when continuity is required.

## Legacy Data

Before new records are written, redact identity-bearing fields from active Master Scaffold continuity artifacts. Scan current Git history and report affected commits and paths as `HISTORY_PURGE_REQUIRED`; history is never rewritten without separate explicit founder approval.

## Enforcement

`ODN_TRACEABILITY_POLICY.md`, `HANDOFF_PROTOCOL.md`, `AGENT_ACTIVITY_LOG_POLICY.md`, routing policies, templates, and focused validation must enforce this policy. A prohibited identity finding blocks migration completion, handoff closure, and `resume_safe` status until the active working-tree artifact is repaired.
