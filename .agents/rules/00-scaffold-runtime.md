# Odonplay Scaffold Runtime Rule

Configure this workspace rule as **Always On** in Antigravity IDE.

Read and follow @../../AGENTS.md before any work. It is the single source of truth for workflow gates, artifact paths, shared context, planning, QA, handoff, skills, and founder-only decisions.

This rule is an Antigravity entrypoint only. Do not duplicate or weaken the rules in `AGENTS.md`.

Keep `.agents/hooks.json` enabled. Its Stop hook invokes the shared documentation validator: for a medium/major task that has a closure status, return to the execution loop until the required operational and QA evidence is synchronized. Do not disable, bypass, or replace this hook with a rule-only reminder.
