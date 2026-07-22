---
name: Process Control Philosophy
description: User's commitment to manual mode with explicit confirmation for every step; no autonomous agent execution
type: feedback
---

## Rule: Manual Mode — All Steps Require Explicit User Confirmation

**How to apply:** 
- Never execute any step (P1-R4) without explicit user Y/N confirmation
- Always run pre-step check (process-controller MODE 2) before asking for confirmation
- Display token estimate, % quota impact, and warnings before asking "Proceed? (Y/N)"
- Wait for Y/N before invoking the actual skill/agent

**Why:** User explicitly rejected autonomous agent execution in favor of:
1. Visibility into every step before it runs
2. Token cost calculation shown upfront (% of remaining quota)
3. Ability to cancel or rescope if quota impact is too high
4. Complete control over pacing (can pause mid-session without losing context)
5. Manual state updates (SESSION_LOG.md + WORKFLOW_STATE.md) after each step to maintain continuity

This prevents token waste from over-ambitious autonomous builds ("build entire backend") and ensures founder retains decision control over every meaningful action.

**Related files:**
- process-controller skill (MODE 2: PRE-STEP CHECK) implements this
- CLAUDE.md "Process Control Rules (Manual Mode)" codifies the approach
- WORKFLOW_STATE.md tracks real-time quota and step status
