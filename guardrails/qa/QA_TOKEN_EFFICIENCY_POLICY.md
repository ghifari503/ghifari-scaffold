# QA Token Efficiency Policy

## Purpose

Keep QA evidence reliable while limiting command execution, repository reading, and chat context to the approved change scope.

This policy applies to every runtime and to during-development QA, final QA, regression checks, self-review evidence, QA handoff, and release-readiness QA.

## Hard Rules

1. Use impact evidence and the approved task slice to define QA scope before choosing commands.
2. Run the smallest relevant QA command first. Prefer a focused unit, integration, browser, lint, typecheck, or smoke command for the changed path or behavior.
3. Do not run a full repository test suite, broad browser suite, full build, or broad regression suite by default.
4. A broad or full-suite run is allowed only when one of these reasons is recorded in QA evidence:
   - the approved task is cross-module, high-risk, security-sensitive, migration-heavy, release-affecting, or has a documented broad regression risk;
   - the existing test runner cannot target the impacted scope;
   - targeted QA failed and broader diagnosis is needed;
   - an existing project rule, CI contract, or release gate requires the full suite; or
   - the founder explicitly requests it.
5. Before repeating a command, compare the current change with `last_passing_point`. Re-run only checks affected by the delta, unless a recorded broad-suite reason applies.
6. Preserve the result and evidence path, not raw command output. Summarize command output with command, target, result, key counts, relevant failure, and artifact/log location.
7. Do not paste long raw logs, screenshots, traces, coverage dumps, or generated reports into operational logs, shared context, or chat. Store durable evidence in the approved artifact location and link or summarize it.
8. A skipped QA layer is valid only when it has a reason, risk note, and any required founder approval. `skipped` is never equivalent to `pass`.
9. If an environment, dependency, credential, device, browser, or manual visual review blocks QA, record `blocked` with the next action. Do not spend tokens repeatedly retrying the same blocked check without a changed prerequisite.
10. Token efficiency must not weaken required QA coverage, security checks, release gates, or the manual visual QA rule.

## Required QA Evidence

Every during-development QA log and final QA evidence must record, when applicable:

- QA scope source: impact scan, approved task slice, current implementation plan, or documented existing-project requirement.
- Targeted paths, behavior, route, endpoint, or command selector covered.
- Delta since the last passing point.
- Commands or methods run and concise result summaries.
- Whether a broad/full suite ran; if yes, its recorded reason.
- Skipped or blocked checks, reasons, risk, and required next action.
- Durable evidence paths when output is too large for the QA artifact.

## Execution Order

1. Recall current task, impact scan, related QA evidence, and `last_passing_point`.
2. Identify the smallest checks that cover the changed behavior and adjacent integration boundary.
3. Run focused checks after meaningful changes; update the during-development QA log.
4. Escalate to broader checks only when a recorded allowed reason exists.
5. Produce granular final QA evidence with concise summaries before final impact check.

## Stop Conditions

Stop and record the QA state instead of claiming completion when:

- QA scope cannot be tied to approved impact evidence or the selected task slice.
- A broad/full suite is proposed without a recorded allowed reason.
- The same blocked command would be retried without a changed prerequisite.
- Raw log output would replace a concise summary and durable evidence reference.
- Required QA coverage is missing, even if token budget is limited.

## Evidence Locations

- During-development QA: `artifacts/test/[feature]-during-dev-qa.md`
- Final QA evidence: `artifacts/test/[feature]-qa-evidence.md`
- Large runtime outputs: `artifacts/qa/` using the relevant tool subfolder, such as `artifacts/qa/playwright/`
- Human-authored summaries, decisions, bug logs, and status: `artifacts/test/`

