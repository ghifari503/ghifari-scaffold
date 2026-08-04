# Local Git Hooks

These hooks protect the scaffold root from accidentally committing or pushing target-project work.

- `pre-commit` blocks scaffold-root commits unless a maintainer explicitly sets `ALLOW_SCAFFOLD_COMMIT=1`.
- `pre-push` blocks scaffold-root pushes unless a maintainer explicitly sets `ALLOW_SCAFFOLD_PUSH=1`.

Enable them after cloning with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
```

Commit and push application work from `development/[project-folder]`, which must be its own Git repository. Use the overrides only for intentional master scaffold maintenance.
