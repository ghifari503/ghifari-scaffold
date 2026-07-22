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

This enables local hooks that reject commit and push from the scaffold root. Project work must be committed from its own repository under `development/[project-folder]/`.

Local hooks are a safety layer, not an identity control. GitHub Ruleset enforcement is authoritative.
