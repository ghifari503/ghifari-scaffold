# Graphify Integration

Graphify is an optional local knowledge-graph capability for target projects managed by this scaffold. It supports Codex, Claude, and Gemini.

## Why Agents Use It

The graph maps code, documentation, configuration, and project artifacts. With it, an agent can investigate architecture and change impact through focused queries instead of repeatedly searching and rereading a repository. It complements, but never replaces, the committed shared context and workflow evidence.

## Developer Experience

Whenever one target project becomes active--through `start`, `start dev`, attach, or a resumed session--the active agent checks Graphify status and gives an informed choice:

```text
Knowledge graph status: missing / stale.

It helps the agent understand architecture, trace dependencies and change impact,
and continue work from previous developers with less rediscovery.

Build or refresh the knowledge graph now? (Y/N)
```

No graph is installed, built, or refreshed without `Y`. Multiple projects are never scanned in bulk.

## Setup and Output

Run setup only from the master scaffold while targeting one nested Git repository:

```powershell
.\scripts\setup-graphify-project.ps1 -ProjectPath .\development\my-project -Install
```

If `uv` is not installed, the active agent must explain that it is a local prerequisite and request explicit approval. After `Y`, it may use the Windows package manager through:

```powershell
.\scripts\setup-graphify-project.ps1 -ProjectPath .\development\my-project -InstallPrerequisite -Install
```

The helper uses `winget` for this one prerequisite. If `winget` is unavailable, it stops and reports the manual prerequisite instead of choosing another installer silently.

The helper registers Graphify for `codex`, `claude`, and `gemini`. It refuses the master scaffold root. The selected project can then build its graph with the Graphify command appropriate to the active runtime.

After `graphify-out/graph.json` exists, enable the always-on guidance shown in the official Graphify documentation:

```powershell
.\scripts\setup-graphify-project.ps1 -ProjectPath .\development\my-project -EnableAlwaysOn
```

This runs the equivalent of `graphify codex install`, `graphify claude install`, and `graphify gemini install` inside the selected target project. It is deliberately blocked until a graph has been built.

`graphify-out/` remains local and is ignored by Git. Record only graph status, output location, and the recommended next action in the target project's `artifacts/shared/PROJECT_STATE.md` and `ACTIVE_CONTEXT.md`.

## Status Helper

```powershell
.\scripts\graphify-status.ps1 -ProjectPath .\development\my-project
```

Statuses are `missing`, `stale`, `current`, or `present_unverified`. `stale` means the latest committed change is newer than `graph.json`; uncommitted work is intentionally not treated as a durable freshness signal.

## Updates and Master Pulls

Pulling this master scaffold never changes a target project's source, dependencies, database, or Graphify installation. The next agent sees the updated master guidance and reads the target project's committed shared context first.

When a user asks to update Graphify, first report the installed version and request approval. Only then run:

```powershell
.\scripts\update-graphify-project.ps1 -ProjectPath .\development\my-project -Update
```

The helper upgrades `graphifyy`, refreshes project-scoped runtime registration, and reports that a graph rebuild plus shared-context version update is required. It never updates Graphify, rewrites a graph, or migrates a target project merely because the master was pulled.

## Safety Boundary

- Do not run Graphify against this master scaffold.
- Do not commit graph files, report data, or credentials.
- Shared context remains the official, Git-carried handoff record. The graph is an optional local acceleration layer.
