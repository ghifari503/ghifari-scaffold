# Local Git Hooks

These hooks keep canonical Master Scaffold work and Working Project work in separate Git histories.

- `pre-commit` permits commits only from `E:/www/project-scaffold`, the canonical Master Scaffold local path, when `origin` is the official repository; it rejects forced staging of files under `development/[project-folder]`.
- `pre-push` permits canonical Master Scaffold pushes only from `E:/www/project-scaffold` and only to `https://github.com/odonplay/odonplay-agent-scaffold` or its equivalent SSH URL.

Enable them after cloning with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
```

Commit and push application work from the Working Project at `development/[project-folder]`, which must be its own Git repository. A Master Framework root must never update the Master Scaffold origin. For a clean VS Code **Changes** list, open the active target folder itself, for example `code development/example-project`. Open `E:/www/project-scaffold` only for generic Master Scaffold maintenance.
