# Requirement Precedence And Conflict Resolution Policy

## Purpose

Ensure every product-code change follows a traceable, current requirement source rather than an unrecorded agent assumption.

This policy governs business and product requirement conflicts. It does not replace `guardrails/system/CONFLICT_RESOLUTION_RULE.md`, which governs conflicts between scaffold and repository guardrails.

## Requirement Source Order

Apply sources in this order when they address the same product decision:

1. Platform safety rules and scaffold gates. These control whether work may proceed; they do not define product behavior.
2. Explicit current founder decision recorded in approved task, approved plan, founder interview, or decision log.
3. Approved feature PRD and explicit acceptance criteria.
4. Approved feature BRD, use case, and business rules.
5. Approved user/system flow and approved API contract or database constraint.
6. Approved UI/UX or design specification.
7. Security, compliance, and QA requirements that add non-negotiable constraints.
8. Current repository behavior and code-derived baseline. These establish existing behavior, not permission to invent a new requirement.
9. Unapproved notes, historical documents, inferred conventions, and model assumptions.

Repository-local instructions remain authoritative for technical execution such as commands, framework conventions, and test runners under `guardrails/system/GUARDRAIL_PRECEDENCE_POLICY.md`; they do not override founder-approved product scope.

## Mandatory Requirement Review

Before planning or coding a feature, bugfix, API, database, UI, integration, refactor, or behavior change:

1. Discover and read relevant sources in the order above.
2. Record the controlling requirement source in the implementation plan and task artifact.
3. Compare requested behavior with current behavior, selected acceptance criteria, and relevant API/database/UI constraints.
4. Create a requirement conflict decision when two relevant sources disagree, an important source is ambiguous, or current behavior conflicts with the approved change.

## Requirement Conflict Decision

Create `dev-doc/[feature-name]/requirement-conflicts/[conflict-id].md` from `templates/requirement_conflict_decision_template.md`.

Every conflict decision must record:

- conflicting sources and exact claims
- impacted feature, actor, flow, API, database, UI, security, and QA areas
- source precedence assessment
- options and risk of each option
- chosen resolution and founder approval reference when required
- documents, plans, API specs, design specs, tests, memory, or decision logs that must be synchronized

## Blocking Rules

Do not begin coding when an active requirement conflict affects scope, acceptance criteria, API behavior, data behavior, security, authorization, pricing, user-visible flow, or allowed write paths.

The conflict may proceed without a new founder decision only when the higher-precedence source resolves it unambiguously and the resolution does not alter founder-approved scope. Record that resolution in the conflict artifact.

Escalate to the founder when:

- two founder-approved or equally authoritative sources conflict;
- the conflict changes product behavior, scope, acceptance criteria, architecture tradeoff, security exception, or release risk;
- no source is sufficiently authoritative; or
- resolving the conflict would require assumption or destructive data behavior.

## Synchronization Rules

After a conflict is resolved:

- update the controlling BRD, PRD, flow, API spec, schema note, design spec, or test plan as applicable;
- update `artifacts/architecture/DECISION_LOG.md` when the resolution creates a durable architectural or technical decision;
- update active task, session log, shared target context, and relevant memory when the decision affects continuation;
- mark the conflict artifact resolved only after all listed synchronization actions are complete.

## Stop Conditions

Stop and keep the task in planning-only mode if the controlling source, acceptance criteria, conflict decision, or founder approval is missing.

