# Development Workspace

## Purpose

`development/` is the local attachment point for target projects. Keep it free of generic scaffold documents so project tooling cannot overwrite scaffold-owned files.

## Layout

```text
development/
  _project-template/
  [project-folder]/
```

Each `[project-folder]` is a separate Git repository. Clone an existing project there, or initialize and connect a project-specific remote there for a greenfield project.

The scaffold repository ignores every target project folder, including its `artifacts/shared/`. Commit target source and client-safe shared facts from the target repository; commit internal ODN/lifecycle state from the Master Scaffold repository.

Keep project requirements, design references, and feature documentation in root `dev-doc/[feature-name]/`. Do not create `dev-doc/` inside a target project folder under `development/`.

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

The protection blocks accidental commit or push from the scaffold root. It does not affect commits from a nested target project repository.

## Shared Context Baseline

For a new target project, copy `_project-template/artifacts/shared/` into the target project before implementation. Follow `guardrails/development/SHARED_CONTEXT_POLICY.md` for the required target files.
