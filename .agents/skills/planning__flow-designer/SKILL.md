---
name: flow-designer
description: Create user flow, process flow, happy path, edge cases, failure paths, and state transitions for a feature or module.
---

# Flow Designer

## Purpose
Create a precise flow that downstream builder and QA agents can implement and verify.

## Required Inputs
Read:
- `artifacts/context/PRODUCT_SCOPE.md`
- `artifacts/architecture/DECISION_LOG.md`
- `templates/user_flow_template.md`

## Process
1. identify actors
2. define entry conditions
3. map happy path
4. map alternate path
5. map failure path
6. identify edge cases
7. identify system states and transitions

## Output
Produce:
- user flow
- admin/operator flow if relevant
- system flow if relevant
- happy path
- alternate paths
- failure paths
- edge case list
- state transitions

## Special Rule for Sync/IoT
If local/cloud sync or devices are involved, include:
- activation state flow
- offline-to-online transition
- duplicate event scenario
- retry failure scenario
- reconciliation scenario

