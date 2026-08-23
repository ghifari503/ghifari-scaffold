# Repository Governance

## Purpose

Keep `main` under the control of `@odonplay` while allowing contributors to propose changes through pull requests.

## Required GitHub Ruleset

Apply this once in the GitHub repository: **Settings -> Rules -> Rulesets -> New branch ruleset**.

1. Name the ruleset `main-protection` and target the `main` branch.
2. Enable **Require a pull request before merging** and require at least one approval.
3. Enable **Require review from Code Owners**.
4. Enable **Require status checks to pass** and select `Validate Scaffold / validate`.
5. Enable **Block force pushes** and **Restrict deletions**.
6. Enable **Restrict updates** and allow only `@odonplay` to update `main`.
7. Add `@odonplay` as the only bypass actor when direct emergency maintenance is required. Do not add other users, teams, or apps to the bypass list.

With this configuration, contributors can create branches and pull requests, but only `@odonplay` can merge changes or push directly to `main`.

## Local Protection

After cloning the scaffold, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\enable-scaffold-git-protection.ps1
```

This enables local hooks with two repository boundaries:

- The scaffold root may commit and push only to `https://github.com/odonplay/odonplay-agent-scaffold` (or its equivalent SSH URL). It may never commit a target project under `development/[project-folder]`, even if a file is force-staged.
- Each target project is an independent Git repository. Commit and push project changes only from `development/[project-folder]` to that project's remote.

Local hooks are a safety layer, not an identity control. GitHub Ruleset enforcement is authoritative.

## Repository Boundary

`development/[project-folder]/` is a separate workspace and Git repository,
not a nested working tree for the scaffold. Run `git status`, `git add`,
`git commit`, and `git push` for product work from inside that target
repository. If the target folder is not a Git repository, stop before project
work begins. Do not force-add target files to the scaffold index.

Scaffold maintenance is performed from the root repository using the official
`https://github.com/odonplay/odonplay-agent-scaffold.git` `origin`. The hooks
permit this official root maintenance automatically and block any other root
push destination. For a clean Source Control list, open the active project
folder as its own VS Code workspace (`code development/[project-folder]`).
Opening the master-scaffold root intentionally shows master changes; Git ignore
rules cannot hide changes to tracked scaffold files.
