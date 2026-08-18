---
name: graphify-refresh
description: Enforce event-driven, token-efficient Graphify refresh for an active target project whenever its source, configuration, documentation, dependencies, or shared context changes. Use whenever Graphify status, build, refresh, target activation, handoff, QA closure, or project-resume freshness is involved.
---

# Graphify Refresh

Use Graphify only for one active target project. It reduces repeated repository discovery, but its output is local acceleration data; target source and committed shared context remain authoritative.

## Activation

1. Run `scripts/graphify-status.ps1 -ProjectPath [target]` when the target activates and after every meaningful delta.
2. If Graphify or its graph is missing, explain the benefit and request explicit approval for installation or the first build. Installing `uv` always needs separate approval.
3. If Graphify is installed and status is `stale`, refresh with `/graphify . --update` from the selected target's assistant context.
4. If update mode cannot recover, use a full `/graphify .` build only for that active target and record the reason.

## Meaningful Delta

Refresh after a completed change to target source, committed configuration, dependencies, feature documentation, or `artifacts/shared/`. Do not refresh after a read-only inspection, unchanged retry, unrelated scaffold edit, or every individual tool call.

Refresh at most once per meaningful delta. After a successful refresh, record concise status, trigger, time, and next action in target `PROJECT_STATE.md` and `ACTIVE_CONTEXT.md`.

## Token Efficiency

- Prefer `/graphify . --update` over full builds.
- Query only the affected route, module, symbol, or dependency path and use the smallest sufficient context budget.
- Do not paste `graph.json`, large reports, or raw graph output into chat or shared context.
- Never scan all projects under `development/`.

## Completion Boundary

If an installed graph remains stale, record the exact blocker and next action. Do not claim `resume_safe`, QA closure, handoff, or ready to PR until the graph is current or the explicit blocker is documented.

## Safety

Never run Graphify against the master scaffold. Do not run Graphify project/platform installation or always-on registration, and do not create target runtime sidecars. Keep only ignored `graphify-out/` local to the selected target.
