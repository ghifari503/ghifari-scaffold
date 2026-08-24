# Development Workspace

## Purpose

`development/` is the local attachment point for target projects. Keep it free of generic scaffold documents so project tooling cannot overwrite scaffold-owned files.

## Repository Levels

- **Master Scaffold** is the canonical reusable source repository before it is used as a project framework.
- **Master Framework** is that scaffold once it governs project work through `development/`.
- **Master Framework root** is the local non-Git technical workspace context inside a Master Framework.
- **Working Project** is the Target Project currently selected at `development/[working-project-name]/`.
- **Target Project** is any nested Git repository at `development/[project-folder]/`.

When intake finds a Target Project or the founder requests a new one, treat the workspace as a Master Framework and convert its local technical context to a Master Framework root with `scripts/initialize-project-scaffold.ps1`. The script archives only the workspace-root `.git` and refuses the canonical Master Scaffold. Master Framework root changes are intentionally not commit candidates and may never update the Master Scaffold origin.

## Layout

```text
development/
  _project-template/
  [project-folder]/
```

Each `[project-folder]` is a separate Git repository. Clone an existing project there, or initialize and connect a project-specific remote there for a greenfield project.

The target repository owns its status, index, branches, commits, and remote.
Do not perform project work from the scaffold root. If a target folder is not a
Git repository, initialize or clone it before continuing.

The Master Scaffold ignores every Target Project folder, including its `artifacts/shared/`. Commit target source and client-safe shared facts from the Target Project; keep internal ODN/lifecycle state in Project Scaffold local storage and do not commit it anywhere.

Keep project requirements, design references, and feature documentation in the target repository at `docs/[feature-name]/`. Do not create `dev-doc/` inside a target project folder under `development/`; the root `dev-doc/` is reserved for master-scaffold documentation and reusable examples.

## Startup Detection

`start` inspects `development/` and excludes only `_project-template/`.

- No target-project folders: use the greenfield route.
- One or more target-project folders: select an existing/inherited target project and begin intake.

Do not place a scaffold `README.md` or other generic marker file directly under `development/`.

## Root Protection

After cloning the scaffold, activate root protection once:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
```

The protection permits root commits and pushes only for the official master-scaffold remote, and blocks target paths from entering the root index. It does not affect commits from a nested target project repository.

## Shared Context Baseline

For a new target project, copy `_project-template/artifacts/shared/` into the target project before implementation. Follow `guardrails/development/SHARED_CONTEXT_POLICY.md` for the required target files.
