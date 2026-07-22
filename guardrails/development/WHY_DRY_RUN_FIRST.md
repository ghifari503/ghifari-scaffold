# Why Dry-Run First

Dry-run is mandatory because this system is founder-driven and route-aware.

## Purpose

Dry-run ensures the system:

1. selects the correct scaffold command
2. targets the correct active folder
3. does not create a real app too early
4. provides a preview the founder can inspect
5. prepares a safe handoff for Codex/GPT, Claude, and Gemini

## What Dry-Run Does

Dry-run:

- reads the active route
- reads the active framework decision
- resolves the frontend and backend commands
- writes the result to `artifacts/architecture/scaffold-execution-plan.md`
- marks whether the preview for the active stack has already been run

Dry-run does not:

- execute real app bootstrap
- install dependencies
- write large final framework output

## Why It Must Happen Before Execute

Without dry-run, the system risks:

- scaffolding into the wrong folder
- running an unapproved framework
- creating a backend/service in the wrong route
- damaging an in-progress project structure

## Rule

Before real execution:

1. the framework decision must be approved
2. dry-run for the active stack must already have been executed
3. the founder must see the command preview
4. the founder must approve execution

