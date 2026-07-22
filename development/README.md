# Development Workspace

This folder holds local target projects under `development/[project-folder]/`.

The scaffold ignores target project source by default, but does not ignore `development/[project-folder]/artifacts/shared/`. Each target project must maintain its own Git repository and commit shared context with that project.

For a new project, copy the shared-context baseline from `_project-template/artifacts/shared/` into the target project before implementation. The `start` command ignores this README and `_project-template` when deciding whether a real target project exists.
