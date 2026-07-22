---
name: release-prep
description: Prepare release notes, deployment checklist, rollback steps, smoke test checklist, and post-release verification plan.
allowed-tools: Read Grep Glob
---

# Release Prep

## Purpose
Prepare a release package only after scope and test status are known.

## Required Inputs
Read:
- `templates/release_template.md`
- `workflows/release_to_field_workflow.md`
- `artifacts/architecture/DECISION_LOG.md`
- relevant test summaries

## Output
Produce:
- release scope summary
- release note
- deployment checklist
- rollback checklist
- smoke checklist
- post-release verification plan

## Special Rule for Field/IoT Release
Include:
- activation verification
- sync verification
- device/site checklist
- rollback contact/owner note

