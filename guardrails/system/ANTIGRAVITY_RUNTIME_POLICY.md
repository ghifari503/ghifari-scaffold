# Antigravity Runtime Policy

## Purpose

Run this scaffold consistently in Google Antigravity IDE or CLI while preserving `AGENTS.md` as the single workflow source of truth.

## Workspace Integration

- Antigravity workspace context must read `AGENTS.md`.
- `.agents/rules/00-scaffold-runtime.md` and `.agents/rules/10-model-routing.md` are the workspace rule entrypoints. Configure both as **Always On** in Antigravity IDE once per cloned workspace.
- `.agents/skills/` is the Antigravity skill mirror. It must remain byte-identical to `.codex/skills/` and is validated by `scripts/check-antigravity-skills.ps1` or `scripts/check-antigravity-skills.sh`.
- Do not place operational rules, secrets, product state, or developer-local settings in `.agents/`.

## Gemini Routing Standard

| Level | Preferred Gemini profile | Intended work |
|---|---|---|
| L0 | Gemini Flash low | isolated formatting, rename, Markdown, DTO, known-pattern boilerplate |
| L1 | Gemini Flash medium | local bugfix, simple CRUD, small API/component, unit test from an established pattern |
| L2 | Gemini Flash high | normal multi-file feature, integration, technical documentation, focused review |
| L3 | Gemini Pro low | planning, requirement analysis, architecture option, database design, trade-off |
| L4 | Gemini Pro high | security, multi-tenant, migration strategy, incident/RCA, complex architecture or performance |

This is a preference map, not a claim that every Antigravity account exposes every model or reasoning tier.

## Automatic Behavior And Limits

- The Antigravity agent must classify the task and select the least expensive available Gemini profile that meets the risk and accuracy floor. It must not ask the founder to choose a model.
- The selected Antigravity reasoning model is sticky for the active turn. Do not claim it switched in place.
- Use a native Antigravity asynchronous agent or subagent only when the installed runtime exposes model selection for that worker and the subtask is independent.
- If model selection or subagent launch is unavailable, remain on the active model, record `model_switch_unavailable` in the target `AI_ROUTING_LOG.md` when available, and continue only when the active model meets the required risk floor. Escalate to the founder if it does not.
- Do not call Codex routing scripts from Antigravity. Codex automatic delegation is Codex-only.
- Never auto-retry a failed task on another Gemini model and never silently fall back to Claude, Codex, or GPT-5.5.

## Role Boundaries

- Gemini Flash is the preferred fast worker when a task is clear and bounded.
- Gemini Pro is the preferred Gemini analyst/architect for L3/L4 work.
- Gemini remains the default independent reviewer and consistency scanner in the multi-agent route unless the founder assigns a different role.
- Claude and Codex assignments remain governed by their own runtime policies. All runtimes use the same gates, artifacts, handoff, and QA evidence.

## Evidence And Gates

- Record runtime, selected or active model, routing status, relative token/cost band, and concise non-sensitive reason in `artifacts/shared/AI_ROUTING_LOG.md` when routing is used.
- Do not record raw prompts, credentials, quotas, or unverified actual cost.
- Create a linked `AGENT_ACTIVITY_LOG.md` event only for task start, material route change, blocker, or meaningful completion; never for each tool call.
- Record the active model with `model_source: runtime_status` only when Antigravity exposes it. Otherwise use `active_model_unavailable` and `model_source: unavailable`; never infer Flash or Pro from the task level.
- Model routing never bypasses task classification, founder approval, skills, I1/I2, dev-doc discovery, pre-coding, QA, documentation sync, or release decisions.
