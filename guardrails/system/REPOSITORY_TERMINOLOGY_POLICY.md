# Repository Terminology Policy

## Canonical Terms

| Term | Meaning | Commit and push authority |
| --- | --- | --- |
| **Master Scaffold** | The canonical reusable source repository before it is used as a project framework. Its local maintenance root is `E:\www\project-scaffold` and its official origin is `https://github.com/odonplay/odonplay-agent-scaffold`; it owns generic rules, tools, templates, and workflow guidance. | Only generic scaffold changes from `E:\www\project-scaffold`, only to its official remote. |
| **Master Framework** | A Master Scaffold already used to govern one or more project workspaces through `development/`. Its local root is the **Master Framework root**. This describes the framework's operating role, not a distinct repository, branch, or commit destination. | No direct commit authority. It must never commit or push to the Master Scaffold origin. |
| **Project Scaffold** | Deprecated compatibility term for Master Framework root, retained only in legacy marker and migration names such as `.project-scaffold.json`. | No direct commit or push authority. |
| **Target Project** | One real project in an independent Git repository under `development/[project-folder]/`. | Only that project's source, project documentation, and client-safe facts, only to its own remote. |
| **Working Project** | The Target Project currently selected for work, written as `development/[working-project-name]/`. A Working Project is always a Target Project, but another Target Project may be inactive. | Use **Commit Target Project** only from that project's repository. |

`main` is a branch name and is never a synonym for Master Scaffold.

## Git Boundary

1. The canonical Master Scaffold remains a Git repository at `E:\www\project-scaffold`. Never delete, archive, or disable its `.git` directory. Only this local root may commit or push generic changes to the Master Scaffold origin.
2. A Master Framework root must not have an active root `.git` directory. It is intentionally outside both Master Scaffold and Target Project history, and it must never update the Master Scaffold origin.
3. A Target Project owns its own branch, index, commits, and remote. A Working Project is the selected Target Project and is the only commit location for its project-specific work.
4. Project-specific names, requirements, documentation, code, and local context never enter the Master Scaffold index.

## Intake And New-Project Conversion

When intake finds a Target Project in `development/[project-folder]/`, or the founder directs creation of a new Target Project, classify the containing non-canonical workspace as a **Master Framework** and its local technical context as a **Master Framework root**. Then:

1. Confirm the workspace path is different from the canonical Master Scaffold path.
2. Confirm that a nested Target Project exists, or that the founder explicitly requested its creation.
3. Archive the Master Framework root `.git` directory locally and create `.project-scaffold.json` as a legacy-compatible local workspace marker.
4. Continue Git work only from the selected Target Project.

The conversion must fail closed when the path is the canonical Master Scaffold. Use `scripts/initialize-project-scaffold.ps1` for this operation; it archives rather than destroys Git metadata so recovery remains possible.

## Canonical Local-Path Enforcement

Generic scaffold maintenance must run from the canonical Master Scaffold local path, identified by its own active Git repository and official origin. A Master Framework root is local context and is never a substitute commit root. The core repository assertion and hooks fail closed when the legacy `.project-scaffold.json` marker identifies the current Git root as Master Framework local context.

## Required Language

- Say **Commit Master Scaffold** only for generic changes in the Master Scaffold.
- Say **Commit Target Project** only for work in the selected Target Project.
- Say **Master Framework** when referring to a scaffold already used with `development/` project folders.
- Say **Working Project** when referring to the currently selected project at `development/[working-project-name]/`.
- Say **Master Framework root** for the non-committable technical root context of a Master Framework.
- Do not use ambiguous bare `master` when naming a repository.
- Do not use **Master Framework** as a Git commit destination; it is a workspace role, not a repository boundary.
- Do not update the Master Scaffold origin from a Master Framework or Working Project. Only `E:\www\project-scaffold` may make that update.
- Say **canonical Master Scaffold local path** when referring to the local checkout used for generic scaffold updates.
