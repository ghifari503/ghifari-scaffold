# Scripts

This folder contains maintained automation helpers for the scaffold. Run a script only when its workflow gate and founder approval allow it.

## Categories

- `*-route*`, `activate-*`, `create-development-unit*`: routing and approved development-structure helpers.
- `prepare-framework-scaffold*`, `execute-framework-scaffold*`, `apply-database-starter*`: framework/database scaffolding after the pre-coding gate is open.
- `check-*` and `sync-skills*`: runtime skill, routing, and parity validation.
- `enable-scaffold-git-protection*`: installs local hooks that protect the scaffold root from accidental project commits.
- `scaffold-playwright*`: prepares approved Playwright testing files in a target project.
- `graphify-*`, `setup-graphify-project.ps1`, `update-graphify-project.ps1`: optional, explicitly approved Graphify operations. The CLI is installed or updated once in the developer's user-level environment; graphs are built only for one selected target project.
- `update-scaffold-project.ps1`: default read-only, per-target scaffold adoption report. Its explicit apply mode only creates a new receipt after clean-repository and shared-context checks; it never overwrites target work.
- `reconcile-project-scaffold.ps1`: mandatory pre-response Project Scaffold reconciliation. It synchronizes only unchanged generic root files from the official clean Master Scaffold, excludes all Target Project and local-context paths, and runs target adoption in dry-run mode.

Prefer the PowerShell (`.ps1`) script on Windows and the shell (`.sh`) equivalent on Unix-like systems when both exist. Read `COMMANDS.md` and the script parameters before running anything. Never run scaffold-generation, dependency, migration, or target-project scripts merely because they exist.
