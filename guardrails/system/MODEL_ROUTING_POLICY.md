# Model Routing Policy

## Purpose

Route a new Codex CLI session to the least expensive available profile that still meets the required accuracy and risk floor.

## Boundary

The router selects a model before a new Codex CLI session starts. It cannot change the model of an already active Codex chat or thread.

Use `scripts/codex-route.ps1` on Windows or `scripts/codex-route.sh` on Unix. Dry-run is the default; `--launch` starts Codex with the selected model and reasoning effort. `--auto-delegate --launch` is the agent-controlled route: Terra continues `standard` work itself and creates one ephemeral worker only for Luna or Sol profiles.

## Routing Inputs

Classify from verified scope and task wording using:

- security, access control, privacy, payment, production, and incident impact
- migration, schema, transaction, and destructive-data impact
- architecture, concurrency, backward compatibility, and cross-module scope
- component count, requirement ambiguity, test need, and delivery impact
- task length only as a supporting signal

## Profiles

The shared baseline is `.codex/model-routing.json`. A developer may override model identifiers in `CODEX_ROUTING_CONFIG` or `~/.codex/model-routing.local.json` when account availability differs.

| Level | Profile | Model / effort | Intended work | Accuracy floor |
|---|---|---|---|
| simple | fast | Luna / low | targeted read-only scan, typo, uniform transformation, isolated documentation, existing-pattern unit test | targeted evidence |
| medium | standard | Terra / medium | approved isolated bugfix, CRUD or focused feature, normal integration and focused tests | targeted validation |
| complex | deep | Sol / high | architecture, hard debugging, cross-module refactor, performance, database, or integration risk | implementation plus independent review |
| critical | critical | Sol / xhigh | security, auth, destructive or critical migration, concurrency, payment, privacy, production incident | independent review and founder-controlled gates |
| legacy | legacy | GPT-5.5 / configured effort | explicit legacy reproduction or benchmark only | legacy reproducibility or benchmark |

`gpt-5.6-terra` is the normal development default. Do not use the `gpt-5.6` alias as the default because its resolved target may not have Terra's cost profile. GPT-5.5 is never a generic fallback; use `--legacy-5-5` only for an explicit legacy/benchmark need.

## Token And Cost Monitor

- Router records a concise decision in `development/[project]/artifacts/shared/AI_ROUTING_LOG.md` when that shared context exists.
- Records include a task hash, selected profile/model/effort, relative token and cost bands, status, and routing reasons.
- Raw task text, secrets, credentials, raw logs, and unverified cost values are prohibited.
- `actual_usage` is `unavailable_from_codex_cli` unless a runtime supplies authoritative usage data.
- The log is capped to recent entries; it is continuity evidence, not an analytics warehouse.
- The bands are relative routing guidance. API list prices or subscription quota must not be recorded as actual Codex usage unless an authoritative runtime source supplies them.
- Create a linked `AGENT_ACTIVITY_LOG.md` event only when routing starts a task, changes delegation/profile, blocks work, or completes a meaningful routed activity. Do not duplicate every routing decision or tool call there.
- Every linked activity event must copy the exact router result into `model_or_profile`, use `model_source: codex_router`, and link the matching `AI_ROUTING_LOG.md` entry. Do not replace the router result with `not_recorded`.

## Escalation And Fallback

- Start at the lowest profile that meets the classification floor: Luna for clear low-risk work, Terra for normal development, Sol for hard or high-risk work.
- After one documented failed targeted attempt on `fast`, use `--escalate-from fast --escalation-evidence [artifact-path]` to select Terra.
- After one or two documented failed Terra attempts, or when architecture risk becomes evident, use `--escalate-from standard --escalation-evidence [artifact-path]` to select Sol.
- Use `critical` directly for security, production, destructive migration, payment, privacy, or concurrency risk. Use Sol parallel/subagent work only when the subproblems are independent and runtime support is available; this does not replace workflow gates.
- `ultra` is a runtime capability choice for an explicitly approved, independent multi-agent decomposition. The router does not enable it automatically and must report unavailable runtime support rather than silently changing the route.
- Never rerun automatically with a different model or fall back to GPT-5.5 after a generic Codex failure. Report the failure and use the configured local override or founder decision.
- If a configured model is unavailable, update the developer-local override and rerun dry-run before launching.

## Automatic Delegation

- The active Terra supervisor performs routing without asking the founder to choose a model.
- `standard` remains on the active Terra supervisor. `fast`, `deep`, and `critical` use `codex exec --ephemeral` with the selected profile.
- A local per-workspace lock permits one delegated worker only. A stale lock is cleared after the configured limit; an active lock blocks delegation and is reported.
- The child receives the scoped task and must read `AGENTS.md`; it may not delegate again. It returns evidence to the supervisor through command output and normal artifacts.
- Automatic routing changes only the execution worker. It does not approve work, bypass user approval gates, or replace the model of the visible editor session.

## Gate Preservation

Routing does not replace task classification, compact-plan approval, skill lookup, I1/I2, dev-doc discovery, pre-coding gate, QA, documentation sync, or founder decisions.
