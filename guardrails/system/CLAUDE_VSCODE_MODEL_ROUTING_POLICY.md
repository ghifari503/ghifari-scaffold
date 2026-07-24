# Claude Code VS Code Model Routing Policy

## Purpose

Route Claude Code work to the least expensive available model that meets the required accuracy and risk floor, while remaining truthful about VS Code extension capabilities.

## Runtime Boundary

The Claude Code VS Code extension shares Claude Code settings, project agents, and model configuration. Its active main-session model is sticky for the current conversation. A project rule cannot silently replace that model in place.

`Auto` in the VS Code mode selector is a permission mode, not a model router. Do not present it as automatic model selection.

Native Claude subagents may declare `haiku`, `sonnet`, `opus`, or a full supported model identifier. This scaffold uses native subagents for bounded automatic delegation. The current main session remains the supervisor unless the runtime itself starts a new session with another configured model.

## Profiles

The machine-readable baseline is `.claude/model-routing.json`.

| Level | Model | Role | Use when | Do not use when |
|---|---|---|---|---|
| L0 | Haiku | Fast worker | Clear mechanical edit, inventory, narrow documentation, existing-pattern test | ambiguity, cross-module, security, migration |
| L1 | Sonnet | Default engineer | Scoped routine development, isolated bugfix, CRUD, focused API/UI work | deep unknown root cause or critical risk |
| L2 | Sonnet | Feature engineer | Controlled multi-file feature, integration, normal review/test work | multi-module or high-risk analysis |
| L3 | Opus | Senior engineer/reviewer | Deep debugging, cross-module refactor, auth, migration compatibility, performance, deep review | task can be resolved safely at L0-L2 |
| L4 | Configured Fable only | Principal architect | Critical architecture, cross-system, security architecture, long-running investigation | full model ID/alias is not verified as available |

`Fable` is a founder-supplied routing label, not a built-in Claude Code alias assumed by this scaffold. It may be selected only through a verified full model ID or supported local alias. The shared repository must never hard-code private provider or gateway credentials.

## Automatic Routing

1. The active Claude session classifies the task before coding using the normal scaffold rules.
2. For L0, it may delegate one isolated subtask to `.claude/agents/claude-fast-worker.md`.
3. For L1-L2, Sonnet is the default supervisor and continues in the active session.
4. For L3, it may delegate bounded analysis or independent review to `.claude/agents/claude-deep-reviewer.md`.
5. For L4, verify availability of the configured Fable model. If unavailable, write `model_switch_unavailable` to target `artifacts/shared/AI_ROUTING_LOG.md` when available. Continue only when the active model objectively meets the documented risk floor; otherwise stop for the required founder decision or safe decomposition.

The founder is never asked to choose a model. Routing must not create a second unbounded worker, alter the active VS Code session model, or substitute a generic fallback after a failure.

## Escalation

- One documented failed targeted Haiku attempt escalates to Sonnet.
- One or two documented failed Sonnet attempts, or verified cross-module complexity, escalates to Opus.
- Verified architecture, critical security, cross-system, or long-running risk may escalate Opus to configured Fable only when available.
- Do not downgrade a model in the middle of implementation without a clear handoff.
- Do not retry a failed task automatically with another model. Capture the failure and preserve normal founder, plan, and QA gates.

## Token And Cost Evidence

- Record a concise, Git-safe decision in `development/[project-folder]/artifacts/shared/AI_ROUTING_LOG.md` when target shared context exists.
- Include task hash, level, selected model or `model_switch_unavailable`, relative token/cost bands, reason, and evidence path.
- Never record raw prompts, secrets, credentials, private provider details, or invented actual usage/cost values.
- Treat estimates as relative guidance unless the runtime supplies authoritative usage data.
- Add an `AGENT_ACTIVITY_LOG.md` event only for task start, material delegation/escalation, blocker, or meaningful completion. Link `AI_ROUTING_LOG.md` rather than copying routing data.
- For a model-aware Claude subagent, record its explicit model and `model_source: agent_frontmatter`. For a main session, record a model only when runtime status or managed configuration proves it; otherwise use `active_model_unavailable` with its reason.

## Gate Preservation

Routing does not replace task classification, compact-plan approval, skill lookup, I1/I2, dev-doc discovery, requirement precedence, pre-coding permission, QA, documentation sync, handoff, or founder-only decisions.
