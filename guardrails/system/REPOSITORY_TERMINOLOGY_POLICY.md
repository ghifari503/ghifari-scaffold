# Repository Terminology Policy

## Canonical Terms

| Term | Meaning | Commit and push authority |
| --- | --- | --- |
| **Master Scaffold** | The canonical reusable Git repository that owns generic rules, tools, templates, and workflow guidance. | Only generic scaffold changes, only to its official remote. |
| **Project Scaffold** | A local workspace created from the Master Scaffold for one project. It holds local project context and one or more Target Projects. Its root is not an active Git repository. | Never commit or push Project Scaffold-root changes. |
| **Target Project** | One real project in an independent Git repository under `development/[project-folder]/`. | Only that project's source, project documentation, and client-safe facts, only to its own remote. |

`main` is a branch name and is never a synonym for Master Scaffold.

## Git Boundary

1. The Master Scaffold remains a Git repository. Never delete, archive, or disable its `.git` directory.
2. A Project Scaffold must not have an active root `.git` directory. Its local context is intentionally outside both Master Scaffold and Target Project history.
3. A Target Project owns its own branch, index, commits, and remote. It is the only commit location for project-specific work.
4. Project-specific names, requirements, documentation, code, and local context never enter the Master Scaffold index.

## Intake And New-Project Conversion

When intake finds a Target Project in `development/[project-folder]/`, or the founder directs creation of a new Target Project, classify the containing non-canonical workspace as a **Project Scaffold**. Then:

1. Confirm the workspace path is different from the canonical Master Scaffold path.
2. Confirm that a nested Target Project exists, or that the founder explicitly requested its creation.
3. Archive the Project Scaffold root `.git` directory locally and create `.project-scaffold.json` as a local workspace marker.
4. Continue Git work only from the selected Target Project.

The conversion must fail closed when the path is the canonical Master Scaffold. Use `scripts/initialize-project-scaffold.ps1` for this operation; it archives rather than destroys Git metadata so recovery remains possible.

## Required Language

- Say **Commit Master Scaffold** only for generic changes in the Master Scaffold.
- Say **Commit Target Project** only for work in the selected Target Project.
- Say **Project Scaffold local context** for root-level changes that must not be committed anywhere.
- Do not use ambiguous bare `master` when naming a repository.
