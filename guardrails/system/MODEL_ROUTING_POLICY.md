# Model Routing Policy

## Purpose

Route a new Codex CLI session to the least expensive available profile that still meets the required accuracy and risk floor.

## Boundary

The router selects a model before a new Codex CLI session starts. It cannot change the model of an already active Codex chat or thread.

Use `scripts/codex-route.ps1` on Windows or `scripts/codex-route.sh` on Unix. Dry-run is the default; `--launch` starts Codex with the selected model and reasoning effort.

## Routing Inputs

Classify from verified scope and task wording using:

- security, access control, privacy, payment, production, and incident impact
- migration, schema, transaction, and destructive-data impact
- architecture, concurrency, backward compatibility, and cross-module scope
- component count, requirement ambiguity, test need, and delivery impact
- task length only as a supporting signal

## Profiles

The shared baseline is `.codex/model-routing.json`. A developer may override model identifiers in `CODEX_ROUTING_CONFIG` or `~/.codex/model-routing.local.json` when account availability differs.

| Level | Profile | Intended work | Accuracy floor |
|---|---|---|---|
| simple | fast | targeted read-only scan, typo, isolated documentation | targeted evidence |
| medium | standard | approved isolated bugfix, small feature, focused tests | targeted validation |
| complex | deep | refactor, multi-module change, performance, database, integration | implementation plus independent review |
| critical | deep | security, auth, migration, concurrency, production impact | independent review and founder-controlled gates |

## Token And Cost Monitor

- Router records a concise decision in `development/[project]/artifacts/shared/AI_ROUTING_LOG.md` when that shared context exists.
- Records include a task hash, selected profile/model/effort, relative token and cost bands, status, and routing reasons.
- Raw task text, secrets, credentials, raw logs, and unverified cost values are prohibited.
- `actual_usage` is `unavailable_from_codex_cli` unless a runtime supplies authoritative usage data.
- The log is capped to recent entries; it is continuity evidence, not an analytics warehouse.

## Escalation And Fallback

- Start at the lowest profile that meets the classification floor.
- Escalate only after a documented signal: security/data risk, scope expansion, low-confidence evidence, failed targeted validation, or independent review findings.
- Never rerun automatically with a different model after a generic Codex failure. Report the failure and use the configured local override or founder decision.
- If a configured model is unavailable, update the developer-local override and rerun dry-run before launching.

## Gate Preservation

Routing does not replace task classification, compact-plan approval, skill lookup, I1/I2, dev-doc discovery, pre-coding gate, QA, documentation sync, or founder decisions.
