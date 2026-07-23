# Antigravity Setup

## Purpose

Use the Odonplay scaffold from Antigravity IDE or Antigravity CLI without changing workflow gates, shared context, or artifact paths.

## First Workspace Setup

1. Open the cloned scaffold as the Antigravity workspace.
2. In the Agent panel, open **Customizations > Rules**.
3. Confirm `.agents/rules/00-scaffold-runtime.md` and `.agents/rules/10-model-routing.md` are available as workspace rules.
4. Set both rules to **Always On** once for that workspace.
5. Keep the project root `AGENTS.md` available. Antigravity CLI also reads workspace `AGENTS.md` and `GEMINI.md` context files.
6. Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-antigravity-skills.ps1` after cloning or updating the scaffold.

## Runtime Behavior

- The agent selects a Gemini profile automatically according to `guardrails/system/ANTIGRAVITY_RUNTIME_POLICY.md`; the developer does not choose models per task.
- The visible model is sticky during a user turn. An agent may only use another model through a native worker/subagent capability that is actually available.
- When that capability is unavailable, the agent records `model_switch_unavailable` rather than claiming an in-place switch.
- Use `artifacts/shared/AI_ROUTING_LOG.md` for Git-safe routing continuity in target projects.

## Skills

`.agents/skills/` is the Antigravity mirror of `.codex/skills/`. Do not edit only one runtime mirror. Add or acquire skills according to `guardrails/system/SKILL_CHECK_POLICY.md`, then verify all runtime mirrors.

## Safety

Antigravity autonomy settings do not override founder approval gates. Keep workspace access scoped to the cloned project, do not grant access to secrets, and retain the scaffold's one-feature, planning, QA, and handoff controls.
