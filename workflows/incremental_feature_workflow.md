# Incremental Feature Workflow (No Full Restart)

Use this flow when adding a feature to an existing project.

## Step 1: Impact scan
- Identify impacted pages, endpoints, and modules.
- Record impacted artifacts list.

## Step 2: Delta requirements
- Update only impacted requirement docs under `dev-doc/[feature-name]/`.
- Add `Delta Update` section with date and reason.

## Step 3: Delta flows
- Update only affected user/system flows.
- Keep unchanged flow files as-is.

## Step 4: Delta design
- Update only impacted design folders in `dev-doc/[feature-name]/design/`.
- Add or replace images in `assets/` only for affected sections.
- Update `figma-link.txt` only where Figma nodes changed.

## Step 5: Frontend update first
- Implement UI change first.
- Run feature-level frontend QA.

## Step 6: API delta
- Update only impacted API specs in `artifacts/architecture/api-specs/`.
- Keep endpoint versioning notes in the API spec file.

## Step 7: Backend delta
- Implement backend changes against updated API specs.
- Run integration tests for impacted flows only.

## Step 8: Release delta
- Prepare release notes only for impacted features.
- Update learnings and decisions.

## Mandatory outputs
- Updated impacted docs
- Feature-level QA report
- Updated API spec (if contract changed)
- Decision and learning log entries

