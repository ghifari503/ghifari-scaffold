# Antigravity Runtime Policy

## Purpose

Run this scaffold consistently in Google Antigravity IDE or CLI while preserving `AGENTS.md` as the single workflow source of truth.

## Workspace Integration

- Antigravity workspace context must read `AGENTS.md`.
- `.agents/rules/00-scaffold-runtime.md` and `.agents/rules/10-model-routing.md` are the workspace rule entrypoints. Configure both as **Always On** in Antigravity IDE once per cloned workspace.
- `.agents/skills/` is the Antigravity skill mirror. It must remain byte-identical to `.codex/skills/` and is validated by `scripts/check-antigravity-skills.ps1` or `scripts/check-antigravity-skills.sh`.
- `.agents/hooks.json` is a required workspace hook configuration. Keep its `documentation-closure-gate` enabled; its Stop hook must return `decision: continue` when `scripts/validate-documentation-sync.ps1` finds incomplete closure evidence.
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
- If model selection or subagent launch is unavailable, continue only when the active model meets the required risk floor. Otherwise stop and report a neutral execution-capability blocker to the founder; do not persist routing identity.
- Do not call Codex routing scripts from Antigravity. Codex automatic delegation is Codex-only.
- Never auto-retry a failed task on another Gemini model and never silently fall back to Claude, Codex, or GPT-5.5.

## Role Boundaries

- Gemini Flash is the preferred fast worker when a task is clear and bounded.
- Gemini Pro is the preferred Gemini analyst/architect for L3/L4 work.
- Gemini remains the default independent reviewer and consistency scanner in the multi-agent route unless the founder assigns a different role.
- Claude and Codex assignments remain governed by their own runtime policies. All runtimes use the same gates, artifacts, handoff, and QA evidence.

## Playwright Execution

- Before a Gemini/Antigravity agent begins any target-repository task, it must verify that Playwright and the required browser binaries are installed and usable. If they are missing, the task is blocked pending founder-approved installation in an open allowed-install scope.
- Gemini/Antigravity must run Playwright headlessly for every invocation. Set or preserve `headless: true`; never pass `--headed`, set `headless: false`, or launch a visible browser.
- This startup prerequisite applies even when the immediate task is backend-only, native Flutter, firmware, or otherwise does not need browser QA. Such scope may mark the later browser-QA layer inapplicable, but may not bypass the installation prerequisite.

## Evidence And Gates

- Routing is ephemeral and must not persist runtime, model, provider, profile, token/cost, or routing-source identity in Master Scaffold or target artifacts.
- Do not record raw prompts, credentials, quotas, or unverified actual cost.
- Create an identity-free `AGENT_ACTIVITY_LOG.md` event only for task start, blocker, or meaningful completion; never for each tool call.
- Model routing never bypasses task classification, founder approval, skills, I1/I2, dev-doc discovery, pre-coding, QA, documentation sync, or release decisions.
- A Gemini/Antigravity agent must not claim medium/major completion, QA closure, `resume_safe`, `verified`, `closed`, or ready-to-PR until the Stop hook accepts the current task. If hooks are unavailable or disabled, it must report that limitation and CI/intentional scaffold commit validation remains the fallback enforcement.
