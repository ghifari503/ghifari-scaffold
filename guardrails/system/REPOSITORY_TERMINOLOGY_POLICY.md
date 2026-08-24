# Repository Terminology Policy

## Canonical Terms

| Term | Meaning | Commit and push authority |
| --- | --- | --- |
| **Master Scaffold** | The canonical reusable source repository before it is used as a project framework. Its official origin is `https://github.com/odonplay/odonplay-agent-scaffold`; it owns generic rules, tools, templates, and workflow guidance. | Only generic scaffold changes, only to its official remote. |
| **Master Framework** | A Master Scaffold already used to govern one or more project workspaces through `development/`. This describes the framework's operating role, not a distinct repository, branch, or commit destination. | No direct commit authority. Apply the Master Scaffold or Target Project boundary that matches the changed file. |
| **Project Scaffold** | The technical local workspace context inside a Master Framework. It holds local project context and one or more Target Projects. Its root is not an active Git repository. | Never commit or push Project Scaffold-root changes. |
| **Target Project** | One real project in an independent Git repository under `development/[project-folder]/`. | Only that project's source, project documentation, and client-safe facts, only to its own remote. |
| **Working Project** | The Target Project currently selected for work, written as `development/[working-project-name]/`. A Working Project is always a Target Project, but another Target Project may be inactive. | Use **Commit Target Project** only from that project's repository. |

`main` is a branch name and is never a synonym for Master Scaffold.

## Git Boundary

1. The canonical Master Scaffold remains a Git repository. Never delete, archive, or disable its `.git` directory.
2. A Master Framework may contain Project Scaffold local context, but that local context must not have an active root `.git` directory. It is intentionally outside both Master Scaffold and Target Project history.
3. A Target Project owns its own branch, index, commits, and remote. A Working Project is the selected Target Project and is the only commit location for its project-specific work.
4. Project-specific names, requirements, documentation, code, and local context never enter the Master Scaffold index.

## Intake And New-Project Conversion

When intake finds a Target Project in `development/[project-folder]/`, or the founder directs creation of a new Target Project, classify the containing non-canonical workspace as a **Master Framework** and its local technical context as a **Project Scaffold**. Then:

1. Confirm the workspace path is different from the canonical Master Scaffold path.
2. Confirm that a nested Target Project exists, or that the founder explicitly requested its creation.
3. Archive the Project Scaffold root `.git` directory locally and create `.project-scaffold.json` as a local workspace marker.
4. Continue Git work only from the selected Target Project.

The conversion must fail closed when the path is the canonical Master Scaffold. Use `scripts/initialize-project-scaffold.ps1` for this operation; it archives rather than destroys Git metadata so recovery remains possible.

## Required Language

- Say **Commit Master Scaffold** only for generic changes in the Master Scaffold.
- Say **Commit Target Project** only for work in the selected Target Project.
- Say **Master Framework** when referring to a scaffold already used with `development/` project folders.
- Say **Working Project** when referring to the currently selected project at `development/[working-project-name]/`.
- Say **Project Scaffold local context** for the non-committable technical root context of a Master Framework.
- Do not use ambiguous bare `master` when naming a repository.
- Do not use **Master Framework** as a Git commit destination; it is a workspace role, not a repository boundary.
