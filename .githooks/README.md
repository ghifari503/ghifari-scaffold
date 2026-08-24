# Local Git Hooks

These hooks keep canonical Master Scaffold work and Working Project work in separate Git histories.

- `pre-commit` permits commits only from `E:/www/project-scaffold`, the canonical Master Scaffold local path, when `origin` is the official repository. If `.project-scaffold.json` identifies a Master Framework root, it automatically unstages every root-index path and blocks the commit. It also automatically unstages Target Project paths force-added to the canonical Master Scaffold index.
- `pre-push` runs the same full-root Master Framework unstage guard, then permits canonical Master Scaffold pushes only from `E:/www/project-scaffold` and only to `https://github.com/odonplay/odonplay-agent-scaffold` or its equivalent SSH URL.

Enable them after cloning with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
```

Commit and push application work from the Working Project at `development/[project-folder]`, which must be its own Git repository. The guard never changes that nested repository's index or working files. A Master Framework root must never create a root commit or update any origin. For a clean VS Code **Changes** list, open the active target folder itself, for example `code development/example-project`. Open `E:/www/project-scaffold` only for generic Master Scaffold maintenance.
