# Local Git Hooks

These hooks keep master-scaffold work and target-project work in separate Git histories.

- `pre-commit` permits scaffold-root commits only when `origin` is the official master repository and rejects forced staging of files under `development/[project-folder]`; only `_project-template/` belongs to the master repository.
- `pre-push` permits scaffold-root pushes only to `https://github.com/odonplay/odonplay-agent-scaffold` or its equivalent SSH URL.

Enable them after cloning with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
```

Commit and push application work from `development/[project-folder]`, which must be its own Git repository. For a clean VS Code **Changes** list, open the active target folder itself, for example `code development/example-project`. Open the scaffold root only when maintaining the master scaffold.
