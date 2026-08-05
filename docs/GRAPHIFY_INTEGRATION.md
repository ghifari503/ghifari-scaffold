# Graphify Integration

Graphify is an optional local knowledge-graph capability for one selected target project. The master scaffold owns the operating rules for Codex, Claude, and Gemini; Graphify accelerates investigation but never replaces committed `artifacts/shared/` context or current repository facts.

## Why Agents Use It

The graph maps code, documentation, configuration, and project artifacts. It lets an agent investigate architecture, trace dependencies and change impact, and resume prior work without repeatedly rediscovering the whole repository.

## Developer Experience

Whenever a target project becomes active--through `start`, `start dev`, attach, or a resumed session--the active agent checks its local graph status and gives an informed choice:

```text
Knowledge graph status: missing / stale.

It helps the agent understand architecture, trace dependencies and change impact,
and continue work from previous developers with less rediscovery.

Set up, build, or refresh the knowledge graph now? (Y/N)
```

Nothing is installed, built, refreshed, or updated without `Y`. Installing `uv` always needs a separate confirmation. Multiple projects are never scanned in bulk.

## Installation Scope

Install Graphify once per developer computer, not once per project. The helper still receives a selected target path so it can reject the master scaffold root and make the next graph action explicit, but it writes no Graphify runtime configuration into that target.

```powershell
.\scripts\setup-graphify-project.ps1 -ProjectPath .\development\my-project -Install
```

If `uv` is missing and its separate installation was approved:

```powershell
.\scripts\setup-graphify-project.ps1 -ProjectPath .\development\my-project -InstallPrerequisite -Install
```

The CLI lives in the developer's user-level `uv` tool environment. A developer who later works on another project using this scaffold is not asked to reinstall it; the agent only checks whether it is available and asks whether to build or refresh that project's graph.

## Target-Project Boundary

The selected target project may contain its local `graphify-out/` output. It is ignored by Git because it is generated, can be rebuilt, and may be large. Record only its status, output location, installed version, and next action in the target's committed `artifacts/shared/PROJECT_STATE.md` and `ACTIVE_CONTEXT.md`.

Do not run `graphify install --project`, `graphify codex install`, `graphify claude install`, `graphify gemini install`, or any always-on registration in a target repository. Those commands generate project-local runtime files that duplicate or conflict with this scaffold's master-owned instructions:

- `.codex/`
- `.claude/`
- `.gemini/`
- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`

Do not blanket-ignore those paths in target repositories: they may later contain intentional project configuration. If a prior Graphify installation generated such files, remove only the identified generated files in a separate, explicitly approved target-repository cleanup task.

## Status and Building

```powershell
.\scripts\graphify-status.ps1 -ProjectPath .\development\my-project
```

Statuses are `missing`, `stale`, `current`, or `present_unverified`. `stale` means the latest committed target change is newer than `graph.json`; uncommitted work is intentionally not treated as a durable freshness signal. After an explicit `Y`, run the installed Graphify CLI only within the selected target repository to build or refresh `graphify-out/`.

## Updates and Master Pulls

Pulling this master scaffold never changes a target project's source, dependencies, database, graph, or developer-local Graphify version. When an update is requested, first report the installed version and request approval. Then run:

```powershell
.\scripts\update-graphify-project.ps1 -ProjectPath .\development\my-project -Update
```

This upgrades the single user-level CLI and requires the selected target graph to be rebuilt plus its shared-context status to be synchronized. It does not register a runtime, rewrite target agent instructions, or migrate project files.

## Safety Boundary

- Never run Graphify against this master scaffold.
- Never commit `graphify-out/`, graph reports, generated runtime sidecars, or credentials.
- Shared context remains the official Git-carried handoff record; the graph is an optional local acceleration layer.
