# Bug Listing

`bug-listing/` is the founder-editable input queue for bug fixing.

Use this folder for bug lists that the founder writes or updates manually before agents triage, plan, fix, verify, and close bugs.

## Purpose

- Keep bug-fix input easy to find at the repository root.
- Separate founder input from QA evidence.
- Avoid hiding active bug work inside `artifacts/`.

## Source Of Truth

Active bug-fix input belongs here:

```text
bug-listing/
  list-bug.md
  [bug-list-name].md
  bug-list-template.md
```

Bug-fix evidence belongs in `artifacts/test/`:

```text
artifacts/test/[module]-bug-log.md
artifacts/test/[module]-bug-status.md
artifacts/test/[module]-e2e-qa.md
```

## Rules

- Agents must read `bug-listing/list-bug.md` by default as the index/default bug list when the founder says `cek bug listing`, `kerjakan bug backlog`, `lanjutkan bug`, or does not name a specific bug list.
- Additional bug list files may use any clear kebab-case name: `bug-listing/[bug-list-name].md`.
- Name bug list files by the most useful working scope, for example module, page, role, flow, sprint, release, or regression batch.
- Valid examples: `bug-listing/pendidikan.md`, `bug-listing/ruang-belajar-ui.md`, `bug-listing/siswa-responsive.md`, `bug-listing/2026-06-regression.md`.
- Avoid vague names such as `bugs.md`, `fix.md`, `new.md`, or `misc.md` unless the file is temporary and clearly marked.
- Keep bug IDs stable after creation.
- Do not store passwords, API keys, tokens, or private credentials in bug listing files.
- If credentials are needed for reproduction, reference an approved environment or secret-management note instead of writing the secret value.
- When a bug is fixed, verified, or closed, update the owning bug list file and the matching evidence artifacts under `artifacts/test/`.
- For UI or browser-visible bugfixes, Playwright verification is required before moving to the next bug unless the founder explicitly approves continuing with the blocker recorded.
