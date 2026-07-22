---
name: sprint-orchestrator
description: Break a validated feature or module into implementable work packages, dependencies, and execution order for builder agents.
---

# Sprint Orchestrator

## Purpose
Convert approved requirements and architecture into an execution plan.

## Required Inputs
Read:
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/architecture/DECISION_LOG.md`
- `artifacts/improvement/LEARNINGS.md`

## Process
1. split by module
2. identify dependency chain
3. separate backend, frontend, sync/device, QA, release tasks
4. identify blocking assumptions
5. recommend execution order

## Output
Produce:
- work package list
- dependency map
- execution order
- definition of done per package
- recommended subagent for each package

