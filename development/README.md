# Development Workspace

This folder holds local target projects under `development/[project-folder]/`.

Each target project must be a separate Git repository. Clone its repository here, or initialize and connect a project-specific remote here. The scaffold repository ignores the entire target project folder, including `artifacts/shared/`; commit and push all project source and shared context from inside the target project repository.

After cloning this scaffold, activate root scaffold protection once:

```powershell
.\scripts\enable-scaffold-git-protection.ps1
```

The protection blocks accidental commit or push from the scaffold root. It does not affect commits from a nested target project repository.

For a new project, copy the shared-context baseline from `_project-template/artifacts/shared/` into the target project before implementation. The `start` command ignores this README and `_project-template` when deciding whether a real target project exists.
