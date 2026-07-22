# Step Registry & Token Cost Estimator

Use this file before running a step to understand the token estimate and how much of the remaining quota it may consume.

For all official workflow steps `P1-P7`, `B1-B3`, and `R1-R4`, also verify the mapped skill or agent in `guardrails/system/SKILL_CATALOG.md` before execution. This is a hybrid rule: mandatory for official steps, optional for intake, audit, and small actions outside the main workflow.

---

## How to Read the Estimate

```text
[Step Name]
- Token Estimate : how many tokens the step may need
- % of Session   : percent of remaining 5-hour session quota
- % of Weekly    : percent of remaining 7-day weekly quota
```

Formula:

```text
% Used = (Step Tokens / Remaining Tokens) x 100
```

---

## Model Cost Multiplier

Each model has a different effective cost profile. Use this to reason about relative expense.

```text
Claude Models
- Haiku  : 1x  -> simple tasks
- Sonnet : 3x  -> balanced tasks
- Opus   : 10x -> complex reasoning

Codex / OpenAI Models
- GPT-4o mini : 1x  -> simple tasks
- GPT-4o      : 5x  -> balanced tasks
- o1 / o1-pro : 15x -> complex reasoning
```

---

## Existing-Project Intake Steps

### STEP I1 - Existing Project Intake
- Type: `manual + audit`
- Recommended Model: `Haiku / GPT-4o mini / GPT-4o`
- Token Estimate: `300-1,200`
- Context Needed: repo path, project summary, and current goal
- Output: current stack map, route summary, known constraints, and initial intake notes
- Notes: do this before proposing broad changes

### STEP I2 - Impact Scan
- Type: `manual + audit`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `500-1,500`
- Context Needed: intake notes + requested change scope
- Output: impacted pages, endpoints, modules, docs, and tests list
- Notes: this step should narrow the next official planning step

---

## AI Contributor Lifecycle Support Steps

Use these support steps with `workflows/ai_contributor_lifecycle.md` when a cloned, attached, inherited, or scaffold-managed project is being prepared for AI contributor work.

### STEP L0 - Task Type Classification
- Type: `classification + routing`
- Recommended Model: `Haiku / GPT-4o mini / GPT-4o`
- Token Estimate: `100-400`
- Context Needed: founder request + current operational state
- Output: `templates/task_classification_template.md` shape or compact classification summary
- Notes: required before significant work, official steps, planning, coding, QA, review, or handoff

### STEP L1 - Attach Repository
- Type: `read-only audit`
- Recommended Model: `Haiku / GPT-4o mini`
- Token Estimate: `200-600`
- Context Needed: repo path or URL
- Output: repo URL/path, branch, commit, remote, and working tree state
- Notes: do not install dependencies, run migrations, scaffold, or edit product code

### STEP L2 - Readiness Baseline
- Type: `local readiness evidence`
- Recommended Model: `Haiku / GPT-4o mini / GPT-4o`
- Token Estimate: `500-1,500`
- Context Needed: attached repo + setup docs + package scripts
- Output: `artifacts/improvement/[project]-readiness-baseline.md`
- Notes: capture dependency, env, database, migration, run, build, lint/typecheck, test, known issue, and blocker status before coding

### STEP L3 - Implementation Plan
- Type: `planning + gate preparation`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `700-1,800`
- Context Needed: completed intake + impact scan + scoped change
- Output: `artifacts/improvement/[feature]-implementation-plan.md`
- Notes: must record scope, non-scope, allowed write paths, blocked paths, QA plan, rollback notes, and founder approval reference

### STEP L4 - During-Development QA
- Type: `incremental QA evidence`
- Recommended Model: `Haiku / GPT-4o mini / GPT-4o`
- Token Estimate: `300-1,200`
- Context Needed: meaningful implementation changes and current test path
- Output: `artifacts/test/[feature]-during-dev-qa.md`
- Notes: record checks after meaningful changes, last passing point, confirmed issues, fixed issues, and deferred issues

### STEP L5 - Self Review
- Type: `review checklist`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `400-1,200`
- Context Needed: changed files + implementation plan + acceptance criteria
- Output: `artifacts/test/[feature]-self-review.md`
- Notes: run before formal code review; check scope, secrets, debug logs, validation, dependency, and breaking-change risk

### STEP L6 - Granular Final QA Evidence
- Type: `QA evidence`
- Recommended Model: `Haiku / GPT-4o mini / GPT-4o`
- Token Estimate: `600-2,000`
- Context Needed: implementation scope + final changed paths + available test stack
- Output: `artifacts/test/[feature]-qa-evidence.md`
- Notes: use `templates/granular_qa_evidence_template.md` and explicitly record unit, integration, E2E/browser, UI/visual, security, performance, and regression status as pass/fail/blocked/skipped

### STEP L7 - Final Impact Check
- Type: `impact review`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `500-1,500`
- Context Needed: implementation plan + changed files + QA evidence
- Output: `artifacts/improvement/[feature]-final-impact-check.md`
- Notes: must run before PR readiness for medium or major work

### STEP L8 - Handoff Preparation
- Type: `handoff`
- Recommended Model: `Haiku / GPT-4o mini / GPT-4o`
- Token Estimate: `300-900`
- Context Needed: current task + session log + changed artifacts + remaining work
- Output: `artifacts/operations/[task-id]-handoff.md` when a standalone handoff file is useful
- Notes: must include Do Not Repeat when failed approaches, risky retries, or forbidden paths are known

### STEP L9 - Ready To PR
- Type: `review readiness`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `400-1,200`
- Context Needed: requirement evidence + self review + QA evidence + final impact check + documentation sync
- Output: `artifacts/release/[feature]-pr-readiness.md`
- Notes: means PR readiness evidence only; it does not create a remote pull request

---

## Step Registry

### PLANNING PHASE

#### STEP P1 - Founder Interview
- Skill: `founder-interviewer`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `800-1,500`
- Context Needed: current change request or unclear business intent
- Output: `dev-doc/[feature-name]/interview-notes.md`
- Notes: use when the intended change is still unclear after intake

#### STEP P2 - Requirement Synthesis
- Skill: `requirement-synthesizer`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `1,500-3,000`
- Context Needed: intake notes + impact scan + founder clarification
- Output: requirement delta artifacts in `dev-doc/[feature-name]/brd.md` or `dev-doc/[feature-name]/prd.md`
- Tip: keep the scope limited to the current change

#### STEP P3 - User Flow Design
- Skill: `flow-designer`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `800-2,000`
- Context Needed: requirement delta baseline
- Output: updated or new flow artifacts in `artifacts/flows/`
- Tip: update only affected flows

#### STEP P4 - Design Mapping
- Skill: `design-mapper`
- Recommended Model: `Haiku / GPT-4o mini`
- Token Estimate: `400-800`
- Context Needed: validated impacted flows
- Output: `dev-doc/[feature-name]/design/` folder structure for impacted UI
- Notes: lightweight task, cheap model is usually enough

#### STEP P5 - Design Completion
- Skill: `design-completer`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `1,000-2,500`
- Context Needed: design images, Figma links, or current design refs for impacted UI
- Output: completed design specs such as `design.md`, `layout.md`, `components.md`, `interactions.md`
- Tip: complete one page or section at a time

#### STEP P6 - Solution Architecture
- Skill: `solution-architect`
- Recommended Model: `Opus / o1 / GPT-4o`
- Token Estimate: `2,000-5,000`
- Context Needed: delta requirements + impacted flows + current architecture context
- Output: `artifacts/architecture/`
- Warning: heavy context step, keep it scoped to the impacted system slice

#### STEP P7 - Sprint Planning
- Skill: `sprint-orchestrator`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `600-1,500`
- Context Needed: approved architecture + scoped requirement delta
- Output: sprint plan broken down into implementable work
- Tip: plan one module or feature slice at a time

### BUILD PHASE

#### STEP B1 - Backend Build
- Agent: `backend-builder`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `2,000-6,000 per feature/module`
- Context Needed: architecture + sprint plan + final API delta
- Output: backend implementation files
- Warning: always scope per feature or module, never "build the whole backend"

#### STEP B2 - Frontend Build
- Agent: `frontend-builder`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `2,000-6,000 per page`
- Context Needed: design specs + API contracts + current frontend conventions
- Output: frontend implementation files
- Tip: build one page or screen at a time

#### STEP B3 - IoT Build
- Agent: `iot-builder`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `2,000-5,000 per module`
- Context Needed: IoT architecture + device specs + existing deployment constraints
- Output: device or firmware implementation

### REVIEW & RELEASE PHASE

#### STEP R1 - Code Review
- Agent: `code-reviewer`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `500-2,000 per file/module`
- Tip: review one module at a time and focus on regression risk

#### STEP R2 - QA Testing
- Agent: `qa-runner`
- Recommended Model: `Haiku / GPT-4o mini`
- Token Estimate: `500-1,500 per suite`
- Notes: prefer the existing test stack if healthy; otherwise Playwright is the default browser QA platform

#### STEP R3 - Release Prep
- Skill: `release-prep`
- Recommended Model: `Haiku / GPT-4o mini`
- Token Estimate: `400-1,000`
- Output: release checklist, rollback plan, smoke checklist, and impact notes

#### STEP R4 - Release Check
- Agent: `release-checker`
- Recommended Model: `Sonnet / GPT-4o`
- Token Estimate: `300-800`
- Output: release readiness report

---

## Quick Token Saving Rules

Do:
- Scope work to one feature, page, fix, or module at a time.
- Use cheaper models for structural or low-reasoning tasks.
- Provide concise context instead of repeating full history.
- Stop when the output is good enough for the current gate.
- Reference existing files instead of restating them.
- Ask for shorter outputs when detail is not needed.

Avoid:
- "Rewrite the whole project"
- "Review all code"
- using the heaviest model for formatting or light structural work
- repeating the entire context in every message
- asking the model to reread files already in context without need
- requesting overly comprehensive documentation by default

