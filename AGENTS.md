# AGENTS.md

## Purpose
This repository is an AI operating scaffold for new, existing, and inherited software or software+IoT projects.
The founder is the only human decision maker.

## Repository Terminology And Git Boundary
- **Master Scaffold** is the canonical reusable source repository, before it is used to govern a project workspace. Its origin is `https://github.com/odonplay/odonplay-agent-scaffold`; it owns generic rules, tools, templates, and workflow guidance.
- **Master Framework** is a Master Scaffold that is already being used to govern one or more projects through its `development/` folder. It is an operating role, not a separate Git repository or commit target.
- **Working Project** is the Target Project currently selected for work at `development/[working-project-name]/`. It is an independent Git repository; project-specific commits and pushes happen only there.
- **Project Scaffold** is the technical local, non-Git workspace context of a Master Framework. Its root changes are never committed or pushed anywhere.
- During intake or new-project creation, convert a non-canonical workspace that contains or will contain a Working Project into a Project Scaffold with `scripts/initialize-project-scaffold.ps1`. Never convert or remove `.git` from the canonical Master Scaffold.
- Before every Git action, state either **Commit Master Scaffold** or **Commit Target Project**. Follow `guardrails/system/REPOSITORY_TERMINOLOGY_POLICY.md`.

This file is the single source of truth for Codex/GPT, Claude, Gemini CLI, and Google Antigravity runtime instructions.
`CLAUDE.md` remains available only as a Claude compatibility pointer.
`GEMINI.md` remains available only as a Gemini compatibility pointer.

## Compatibility Mode
- Codex/GPT, Claude, and Gemini must read and follow this file before doing any work.
- `CLAUDE.md` and `GEMINI.md` must stay as minimal pointer files that direct runtimes back to `AGENTS.md`.
- Runtime-specific root files must not duplicate operational rules, command menus, gate rules, QA policy, or artifact paths.
- Overview and navigation docs remain in `docs/`.
- Strict rules, policies, protocols, and standards live in `guardrails/`.
- Project outputs, state, context, logs, and evidence live in `artifacts/`.
- Persistent scaffold memory lives in `artifacts/memory/` and is governed by `guardrails/memory/`.
- User-facing command lists live in root `COMMANDS.md`.
- Skills live in `.codex/skills/`, `.claude/skills/`, and `.agents/skills/` as synchronized runtime mirrors.
- Prefer `.codex/skills/` for Codex, `.claude/skills/` for Claude, and `.agents/skills/` for Antigravity. Codex is the canonical mirror for synchronization.
- Antigravity workspace rules live in `.agents/rules/`; they are entrypoints to this file and `guardrails/system/ANTIGRAVITY_RUNTIME_POLICY.md`, not independent workflow sources.
- Agent docs may live in either `.codex/agents/` or `.claude/agents/`.
- Runtime skill parity and prefix normalization are governed by `guardrails/system/SKILL_CHECK_POLICY.md`.

## Runtime Roles
- Codex/GPT may act as interviewer, analyst, documenter, architect assistant, builder assistant, QA assistant, and release assistant according to the active gate.
- Claude may act as interviewer, analyst, documenter, architect assistant, builder assistant, QA assistant, and release assistant according to the active gate.
- Gemini CLI should act primarily as an independent reviewer, cross-checker, and repo-wide consistency scanner.
- Google Antigravity must follow this file and `guardrails/system/ANTIGRAVITY_RUNTIME_POLICY.md`. It may use Gemini Flash as a bounded worker and Gemini Pro for analysis/architecture when those models are available, while Gemini remains the default independent-review runtime.
- If a runtime lacks an equivalent local tool, report the limitation and preserve the same evidence shape, gate meaning, status labels, and artifact paths.
- All runtimes may propose options and recommendations, but founder-only decisions remain with the founder.

## Runtime Consistency Contract (Strict)
- When founder requests same process/output across runtimes, enforce `guardrails/system/RUNTIME_PARITY_CONTRACT.md`.
- Do not deviate from gate order, artifact paths, status labels, or output section ordering defined there.
- Runtime-specific differences are allowed only for CLI syntax and runtime connector internals.
- Task type classification parity is governed by `guardrails/system/TASK_TYPE_CLASSIFICATION.md` and `guardrails/system/TASK_TYPE_REGISTRY.md`.
- Cloned-repository guardrail interpretation parity is governed by `guardrails/system/GUARDRAIL_PRECEDENCE_POLICY.md`, `guardrails/system/CLONED_REPO_INTAKE_CHECKLIST.md`, and `guardrails/system/CONFLICT_RESOLUTION_RULE.md`.

## Optional Graphify Knowledge-Graph Policy
- Graphify is an optional, local acceleration layer for one selected target project. It helps agents map code, documentation, configuration, and artifacts to investigate architecture, trace change impact, and resume prior work with less rediscovery.
- It complements, and never replaces, the target project's client-safe `artifacts/shared/` facts, Master Scaffold ODN traceability, workflow evidence, or current repository facts.
- Whenever one target project becomes active--including through `start`, `start dev`, attach, or a resumed session--inspect its Graphify status with `scripts/graphify-status.ps1`. For `missing` or `present_unverified`, explain the benefit and request installation/build approval. For an installed graph, Graphify refresh is mandatory after each meaningful target-project source, configuration, documentation, dependency, or shared-context change.
- Founder approval of the strict Graphify refresh policy on 2026-08-18 authorizes event-driven refreshes for installed Graphify on the active target only. Installing Graphify or its `uv` prerequisite still requires separate explicit developer approval; installing `uv` always requires a separate confirmation.
- Refresh only the changed graph using the Graphify update mode, once per meaningful delta. Use graph queries with the smallest adequate context budget instead of loading raw graph output or repeatedly rescanning unchanged targets.
- Install the Graphify CLI only once per developer computer through the user-level `uv` tool environment. This master scaffold owns the Codex, Claude, and Gemini instructions; never run `graphify install --project`, a platform install command, or an always-on registration in a target repository.
- Run graph builds only against the selected target repository, never this master scaffold or every project under `development/`. Keep only `graphify-out/` and generated graph data local and ignored by Git; do not generate target `.codex/`, `.claude/`, `.gemini/`, `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` through Graphify.
- A target session that changed relevant project material is not `resume_safe`, ready for handoff, ready for QA closure, or ready to PR until its installed Graphify graph is refreshed or an explicit blocker is recorded in Master Scaffold internal traceability.
- A master scaffold pull must never upgrade or rebuild a target project's Graphify installation. When an update is requested, report the installed version, request explicit approval, then require a graph rebuild and target shared-context status sync.
- A master scaffold pull must never copy, merge, or overwrite target source, active documentation, shared context, dependencies, environment, database, or Graphify output. Use `guardrails/system/SCAFFOLD_UPDATE_POLICY.md`; adoption is opt-in per target, dry-run first, and fails closed on a dirty target or any legacy copied scaffold core.
- Strict adoption trigger: after a Master Scaffold pull or whenever a Project Scaffold is selected or resumed, every runtime must run `scripts/reconcile-project-scaffold.ps1 -TargetPath development/[project-folder]` (or `.sh`) before continuing any user task. The helper safely synchronizes only unchanged generic files into Project Scaffold local context, then runs `update-scaffold-project.ps1` in dry-run mode. It never copies, alters, or writes Target Project source, docs, dependencies, environment, database, Graphify output, or Git metadata. The report must be shown to the founder; a non-ready result blocks implementation, QA closure, handoff, and `resume_safe` until its required migration or blocker is resolved. Never run `-Apply` or alter Target Project source without separate explicit founder approval.

## AI Contributor Lifecycle Overlay
- Use `workflows/ai_contributor_lifecycle.md` as the scaffold-level overlay for contributor work across Codex, Claude, and Gemini CLI.
- This overlay does not replace `I1/I2/P1-P7/B1-B3/R1-R4`; it adds explicit evidence for clone/attach, readiness baseline, implementation planning, during-development QA, self-review, final impact checking, handoff, and PR readiness.
- Use the matching templates in `templates/` when creating lifecycle evidence.
- For cloned or attached repositories, inventory local guardrail files and resolve scaffold-vs-repo conflicts using `guardrails/system/GUARDRAIL_PRECEDENCE_POLICY.md`, `guardrails/system/CLONED_REPO_INTAKE_CHECKLIST.md`, and `guardrails/system/CONFLICT_RESOLUTION_RULE.md` before coding.
- `ready to pr` means review readiness evidence, not creating a remote pull request.
- Gemini CLI should act as an independent reviewer and cross-checker while preserving the same artifact paths, status labels, and gate meanings.
- For behavior, source, API, database, UI, security, performance, or release-affecting changes, create granular final QA evidence with `templates/granular_qa_evidence_template.md` before final impact check.
- Recommended strict multi-agent route for medium/high-risk work: Claude plans and analyzes, Codex/GPT implements, Gemini independently reviews, then Claude or a human reviewer prepares final QA reasoning and PR/handoff summary.

## Process Control Rules (Manual Mode)
0. Before every action command or task, run `scripts/check-scaffold-freshness.ps1` or `scripts/check-scaffold-freshness.sh`. This local no-network check reports the current Git `HEAD` and fingerprints for the core rules, version file, and operational status snapshot. Re-read relevant rules only when the session fingerprint changes. Never fetch or pull automatically.
1. Never run major workflow steps autonomously without user confirmation.
2. Treat `start dev` / `dev` as the local development readiness command and do not require `I2 Impact Scan` unless a real project behavior/source/config/dependency/schema/test change is discovered.
3. Before significant work or any official step, classify the request using `guardrails/system/TASK_TYPE_CLASSIFICATION.md` and `guardrails/system/TASK_TYPE_REGISTRY.md`.
   - Use `templates/task_classification_template.md` for medium, major, ambiguous, or high-risk work.
   - Ask founder confirmation when classification confidence is not high or risk is medium/high/critical.
   - Do not proceed when task type, scope, required gates, or allowed write paths are unclear.
4. Medium/Major Plan-First Gate:
   - For every request classified as `medium` or `major`, stop before execution and present a compact plan first.
   - The compact plan must include objective, scope, intended files or artifact areas, execution steps, verification, documentation sync, and risks.
   - Continue only after explicit founder approval.
   - Before approval, do not edit files, run official workflow steps, code, build, refactor, install dependencies, run migrations, scaffold/generate code, close QA, prepare release, or create final handoff.
   - Small direct questions and lightweight read-only checks may proceed without a plan when they do not change files, gates, or workflow state.
5. Before each official step, run a pre-step check:
   - Read `artifacts/operations/WORKFLOW_STATE.md`
   - Read `guardrails/system/STEP_REGISTRY.md`
   - Read `guardrails/system/SKILL_CATALOG.md` and identify the mapped skill or agent for that step
   - Estimate step cost vs remaining quota
   - Warn if > 10% remaining quota, hard stop if > 20%
   - Ask user confirmation (Y/N)
6. After each official step:
   - Update `artifacts/operations/WORKFLOW_STATE.md`
   - Append session notes in `artifacts/operations/SESSION_LOG.md`
   - Write the matching step entry before the next official step or any handoff. If the step entry is missing, the step is not complete.
   - For official testing steps `R1-R4`, update or create the matching QA evidence artifact, `artifacts/operations/CURRENT_TASK.md`, `artifacts/operations/WORKFLOW_STATE.md`, and `artifacts/operations/SESSION_LOG.md` in the same documentation-sync batch.
   - If required QA evidence, operational status sync, or the latest step log is missing, the testing step is incomplete and may not be marked `SUCCESS`, `pass`, `verified`, `resume_safe`, or ready for handoff.
7. Before build steps, remind the user to scope by feature/module.
8. Use `process-controller` skill for status checks, pre-step checks, and post-step updates when available.
9. Hybrid skill-check policy:
   - Before executing any non-read-only task, perform a relevant local skill or agent lookup and record the selected capability or the explicit `no_relevant_local_skill` result in the active plan, session log, or task evidence.
   - This applies to intake, planning, documentation generation, coding, refactor, test creation, QA, review, handoff, release preparation, and scaffold maintenance. Direct questions and lightweight read-only checks remain exempt when they do not change files, gates, or workflow state.
   - For official workflow steps `P1-P7`, `B1-B3`, `R1-R4`, always perform skill lookup first.
   - Before any coding, refactor, test creation, scaffold/code generation, dependency work, migration, or build step, always search for relevant skills or agents first, even when the request is informal and not explicitly named as `B1/B2/B3`.
   - Codex/GPT must prefer `.codex/skills/` and inspect `.codex/agents/` when an agent role is needed; use `.claude/` only as a reference fallback when no Codex equivalent exists.
   - Claude must prefer `.claude/skills/` and inspect `.claude/agents/` when an agent role is needed; use `.codex/` only as a reference fallback when no Claude equivalent exists.
   - Gemini CLI and Antigravity must follow this `AGENTS.md` policy, use `.agents/skills/` for Antigravity when available, and preserve the same gate, artifact path, and evidence shape.
   - If no relevant local skill or agent exists for an executing task, search skills.sh through `find-skills` before examining any external source. Validate source reputation, usage, license, files included, and requested capability, then follow `guardrails/system/SKILL_CHECK_POLICY.md` for acquisition.
   - Auto-acquire only an allowlisted external skill. Install its complete skill folder into `.codex/skills/`, `.claude/skills/`, and `.agents/skills/`, run `cek skill`, and verify all mirrors before use. For any source outside the allowlist, present the candidate and wait for founder approval before download.
   - If no suitable external skill exists, run the `skill-creator` flow first to create or propose the missing skill before the task execution proceeds.
   - Skill lookup or skill creation never opens the coding gate by itself; `I1`, `I2`, compact-plan approval for medium/major work, allowed write paths, and `PRE_CODING_GATE.md` must still allow the work.
   - For intake, audit, repo review, document edits, file reads, and lightweight clarifications outside official workflow steps, skill lookup is optional and only needed when clearly relevant.
10. Dev-Doc Discovery Gate:
   - Before feature development, bugfix work tied to a feature/module, backend/API change, frontend/UI change, system behavior change, integration, refactor, database change tied to a feature/module, or any related build/coding step, search the active target's `docs/` for related documentation first.
   - Search exact feature slugs, related module/domain names, reasonable synonyms from the request, and entries from `plan/feature-listing.md` when present.
   - If related target `docs/` material exists, read the relevant BRD, PRD, design, prototype, or notes before planning or building.
   - If related target `docs/` material is missing, record `project docs missing`; for new feature work, do not code until founder interview, requirement synthesis, or planning docs create the needed baseline.
   - Dev-doc discovery never opens the coding gate by itself; `I1`, `I2`, compact-plan approval for medium/major work, skill lookup, allowed write paths, and `PRE_CODING_GATE.md` must still allow the work.
11. Feature Task Slicing and Context-First Gate:
   - Before feature planning, implementation planning, coding, refactor, QA closure, release prep, or handoff for a feature/module change, enforce `guardrails/development/FEATURE_TASK_SLICING_POLICY.md`.
   - Work on exactly one feature per session unless the founder explicitly approves a wider session.
   - Break every feature request into small task slices and select only one slice for the current session.
   - Use `templates/feature_task_breakdown_template.md` for medium/major feature breakdowns.
   - Read active operational context, project context, memory index/ledger, feature registry, related target `docs/`, and the latest relevant session log before repository source scanning.
   - Do not scan or read the whole repository on every task. Use targeted scans based on context, memory, dev-doc, impact scan, route names, symbols, modules, and allowed write paths.
   - Full repo scans are allowed only for first `I1`, unknown route/stack, stale or contradicted baseline, high-risk/cross-module/security/migration/release work, documented targeted-scan failure, or explicit founder approval.
12. Shared Target Repository Context Gate:
   - For any target repository under `development/[project-folder]`, enforce `guardrails/development/SHARED_CONTEXT_POLICY.md`.
   - The Target Project must be a separate Git repository; do not commit or push its files from a Project Scaffold root.
   - Before Target Project setup or work, verify the target repository is initialized or cloned. When the workspace is a Project Scaffold, verify its `.project-scaffold.json` marker and inactive root `.git`; when working in the canonical Master Scaffold, verify root Git protection through `scripts/enable-scaffold-git-protection.ps1`.
   - Target `development/[project-folder]/artifacts/shared/` contains client-safe project facts only. Identity-free internal lifecycle, handoff, traceability, contributor/process, and development-state metadata belongs in Project Scaffold local `artifacts/traceability-local/[project]/`; routing is ephemeral.
   - Project requirements, product/design references, and feature documentation belong in the target repository at `development/[project-folder]/docs/[feature-name]/`; do not create `dev-doc/` inside `development/[project-folder]/`.
   - Before continuing target repo work, read client-safe `PROJECT_STATE.md`, Master Scaffold `BATCH_STATE.json`, at most three relevant ODN batches, and the relevant internal handoff.
   - If target client-safe facts or Master Scaffold traceability baseline is missing during first intake, create the applicable baseline before handoff or implementation.
   - After meaningful work, update target `PROJECT_STATE.md` only when client-safe project facts changed and synchronize internal batch/lifecycle/handoff state under Master Scaffold authority.
   - Target shared facts must be Git-safe and client-safe: no secrets, `.env` values, raw chat transcripts, private personal data, credential dumps, large raw logs, or internal process metadata.
12A. ODN Traceability And First-Adoption Migration Gate:
   - For every task and every runtime, enforce `guardrails/development/ODN_TRACEABILITY_POLICY.md` after normal task classification without changing existing workflow gate order.
   - Additionally classify work as `read_only`, `minor_change`, or `logical_change`. Only a logical engineering change creates or resumes an `odn-xxxx` batch; prompts, tool calls, runtimes, files, and commits are never batches.
   - Complete internal authority lives under `artifacts/traceability-local/[project]/`; target repositories may expose only selective `@batch odn-xxxx` markers and `Batch: odn-xxxx` Git trailers.
   - Resolve progressively by stable `component:scope` and load at most three batches initially. ODN must not duplicate Graphify structural data.
   - On first adoption, dry-run and classify every target `artifacts/shared/` file as `client_safe` or `internal_process_state`. Preserve all client-safe files. Copy and hash-verify internal files before removal; require all mandatory migration checks to pass; add prevention rules; keep the migration idempotent.
   - Report internal paths in prior Git commits as `HISTORY_PURGE_REQUIRED`. Never rewrite history without separate explicit founder approval.
   - Enforce `guardrails/development/INTERNAL_CONTINUITY_IDENTITY_POLICY.md` for every runtime. Persist only neutral work continuity; never store runtime, provider, model, agent, engineer, routing, token, cost, or generative-process identity in traceability, activity, handoff, lifecycle, migration, or process-state records.
   - Master schema authority is `artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json`. Each project must match that schema and have `migration_status: completed` before fast-path continuation. Missing, older, failed, or in-progress adoption requires a dry-run and one schema-specific migration/recovery guarded by an exclusive lock.
13. Code-Derived Baseline Gate:
   - During first `I1` intake, enforce `guardrails/development/CODE_DERIVED_BASELINE_POLICY.md` when no relevant project documentation exists or available documentation cannot establish the current project state.
   - After targeted documentation discovery finds no relevant material, ask the founder whether documentation, links, diagrams, access to another repository, or other context is available before deriving the baseline from source code.
   - If no usable material exists, create the evidence-backed target-repo `artifacts/shared/PROJECT_STATE.md` baseline, synchronize verified stable facts into scaffold memory and feature registry, and use it to avoid future full-repository rediscovery.
14. Before any coding, scaffold execution, dependency install, migration, code generation, or refactor, enforce `guardrails/development/PRE_CODING_POLICY.md` and `artifacts/operations/PRE_CODING_GATE.md`.
15. `I2 Impact Scan` is for scoped change work only. Do not force `I2` for local-readiness requests such as running the app locally, checking missing dependencies, inspecting env requirements, or preparing a dev server unless a real project change becomes necessary.
16. Before initiating any feature planning, the strict interview workflow defined in `guardrails/development/INTERVIEW_PLAN_WORKFLOW.md` MUST be executed. Plans must be written directly to the root `plan/` folder, must receive explicit founder approval after review, and must record a plan-approval checklist artifact before any build or coding step may begin.
17. Requirement Precedence And Conflict Gate:
   - Before planning or coding feature/module behavior, enforce `guardrails/development/REQUIREMENT_PRECEDENCE_POLICY.md`.
   - Read relevant requirement sources in precedence order and record the controlling source in the implementation plan.
   - Create `development/[project-folder]/docs/[feature-name]/requirement-conflicts/[conflict-id].md` when relevant sources conflict, important ambiguity exists, or current behavior conflicts with approved change.
   - Keep coding blocked while an active conflict affects scope, acceptance criteria, API/data behavior, security, user flow, or allowed write paths without a valid resolution.
18. Scaffold Core Governance Gate:
   - Before changing protected scaffold paths, enforce `guardrails/system/SCAFFOLD_CORE_CHANGE_POLICY.md`, including `.githooks/`.
   - Do not weaken, bypass, or silently replace core workflow gates through a team-specific change.
   - Require founder or CODEOWNERS approval before merging a protected core change.
   - Contributors other than `@odonplay` must use pull requests; server-side enforcement is defined in `docs/REPOSITORY_GOVERNANCE.md`.
19. Codex Model Routing And Token Governance Gate:
   - For a new Codex coding, refactor, test-creation, migration, dependency, or scaffold-generation task, the active Codex Terra supervisor must run `scripts/codex-route.ps1` or `scripts/codex-route.sh` automatically. The founder must not be asked to select a model.
   - When the route is `standard`, the Terra supervisor continues itself. When it is `fast`, `deep`, or `critical`, it must invoke `--auto-delegate --launch` to run one temporary Codex worker and wait for the result. This cannot change the editor model of the active supervisor.
   - Automatic delegation is limited to one active worker per workspace, uses an ephemeral child session, and never auto-retries or auto-falls back to GPT-5.5. The worker must preserve every normal scaffold gate.
   - Enforce `guardrails/system/MODEL_ROUTING_POLICY.md`; model selection must balance accuracy floor, risk, token efficiency, and cost band.
   - Use Luna/`fast` for clear low-risk work, Terra/`standard` as the normal development default, Sol/`deep` for complex work, and Sol/`critical` for critical risk. GPT-5.5 is allowed only through explicit legacy/benchmark routing and is never an automatic fallback.
   - Use dry-run first when model availability is unknown. Developer-local model overrides are allowed only in ignored local configuration and must not alter scaffold policy.
   - Router makes an ephemeral local selection only. It must not write routing metadata, runtime/model/provider identity, raw prompts, secrets, or actual-cost figures to Master Scaffold or target artifacts.
   - Router selection and subagent delegation never bypass task classification, plan approval, skill lookup, I1/I2, dev-doc discovery, pre-coding, QA, documentation sync, or founder approval.
20. Antigravity Runtime And Gemini Routing Gate:
   - For Antigravity coding, refactor, test-creation, migration, dependency, or scaffold-generation work, enforce `guardrails/system/ANTIGRAVITY_RUNTIME_POLICY.md` automatically. Do not ask the founder to select a Gemini model.
   - The model active in an Antigravity turn is sticky. Use a native worker/subagent only when the installed runtime exposes the required selection capability; otherwise report a neutral execution-capability blocker and never claim an in-place model switch.
   - Antigravity must not call Codex routing scripts or inherit Codex child-worker behavior. It preserves the same workflow gates without writing routing identity evidence.
21. Claude Code VS Code Model Routing Gate:
   - For Claude Code VS Code coding, refactor, test-creation, migration, dependency, or scaffold-generation work, enforce `guardrails/system/CLAUDE_VSCODE_MODEL_ROUTING_POLICY.md` automatically. The founder must not be asked to select a Claude model.
   - Use `.claude/model-routing.json` and the native Claude agents `claude-routing-supervisor`, `claude-fast-worker`, and `claude-deep-reviewer` for bounded automatic delegation when runtime support is available.
   - The visible VS Code main-session model is sticky. Do not claim an in-place model switch; `Auto` permission mode is not a model selector.
   - L0 may use Haiku, L1-L2 use Sonnet, L3 may use Opus for bounded analysis/review, and L4 uses Fable only after its actual supported local model ID or alias is verified. When L4 selection is unavailable, report a neutral capability blocker and continue only if the active model meets the risk floor.
   - Do not retry automatically, downgrade during implementation, hard-code account-specific model IDs, or bypass any workflow gate. Routing decisions are ephemeral and must not be written to Master Scaffold or target continuity artifacts.
22. Scaffold Agent Activity Log Gate:
   - For every meaningful scaffold or target-project activity, enforce `guardrails/development/AGENT_ACTIVITY_LOG_POLICY.md` and append the required event to `artifacts/operations/AGENT_ACTIVITY_LOG.md`.
   - Before source scanning or continuing work, read only its `Current Activity Snapshot`, the active task entries, and at most three relevant recent entries. Do not read the full log by default.
   - Never log per tool call, raw prompts, raw command output, secrets, identity-bearing routing data, or unverified token/cost data. Link only neutral QA, contributor-role, or handoff evidence.
   - Every activity entry uses the neutral `contributor_role` field. Runtime, provider, model, agent, engineer, routing-source, token, and cost identity are prohibited by `guardrails/development/INTERNAL_CONTINUITY_IDENTITY_POLICY.md`.
   - When a Target Project is active, link the current activity event from Project Scaffold local traceability. It is not part of either the Target Project or Master Scaffold Git history.

## Global Rules
1. Read these files before significant work:
   - `artifacts/operations/WORKFLOW_STATE.md`
   - `COMMANDS.md`
   - `guardrails/development/LOGGING_STANDARD.md`
   - `artifacts/operations/CURRENT_PHASE.md`
   - `artifacts/operations/CURRENT_TASK.md`
   - `artifacts/operations/AGENT_ACTIVITY_LOG.md` (snapshot and relevant recent entries only)
   - `artifacts/access/README.md`
   - `guardrails/development/HANDOFF_PROTOCOL.md`
   - `guardrails/development/ARTIFACT_STORAGE_POLICY.md`
   - `guardrails/development/FEATURE_TASK_SLICING_POLICY.md`
   - `guardrails/development/SHARED_CONTEXT_POLICY.md`
   - `guardrails/system/SKILL_CATALOG.md`
   - `guardrails/system/TASK_TYPE_CLASSIFICATION.md`
   - `guardrails/system/TASK_TYPE_REGISTRY.md`
   - `artifacts/context/PROJECT_CONTEXT.md`
   - `artifacts/context/BUSINESS_CONTEXT.md`
   - `artifacts/context/PRODUCT_SCOPE.md`
   - `guardrails/architecture/ARCHITECTURE_RULES.md`
   - `guardrails/development/DOCUMENT_STANDARDS.md`
   - `artifacts/architecture/DECISION_LOG.md`
   - `artifacts/improvement/LEARNINGS.md`
   - `guardrails/memory/MEMORY_POLICY.md`
   - `artifacts/memory/MEMORY_INDEX.md`
2. For existing or inherited codebases, start with repo intake and architecture/stack audit before proposing major changes.
3. If requirements are unclear, run founder interview workflow before writing requirements or code.
4. Do not start implementation until the minimal change baseline exists:
   - current behavior summary
   - scoped problem statement
   - impacted actor list
   - impacted feature list
   - acceptance criteria
   - user or system flow
5. Existing-project work may include feature delivery, redesign, UI revamp, flow changes, refactor, migration, or architecture cleanup.
6. Large changes are allowed, but they must be explicitly scoped, impact-scanned, and approved before implementation starts.
7. Preserve existing conventions, routes, naming, framework choices, and infrastructure unless the founder approves a change.
8. Do not overwrite decisions marked final in `artifacts/architecture/DECISION_LOG.md`.
9. Record meaningful wins, failures, migration notes, and inherited-system constraints in `artifacts/improvement/LEARNINGS.md`.
10. Keep local/dev/demo access details in `artifacts/access/README.md`, including running URLs and non-production access accounts when the founder approves storing them in the repo.
11. Never store production credentials, personal passwords, API keys, or secrets that should live in a secret manager inside `artifacts/access/README.md`.
12. For substantial tasks, always report:
   - objective
   - assumptions
   - files modified
   - what worked
   - what failed
   - risks/open questions
   - recommended next step
13. Keep exactly one active task in `artifacts/operations/CURRENT_TASK.md`; all other items must remain backlog/next tasks, not parallel active tasks.
   - For feature work, keep exactly one feature active per session unless the founder explicitly approves a wider session.
   - For every feature request, create or update a task breakdown and choose one selected slice for the current session before implementation.
   - Use context and memory to narrow repository scanning; do not repeat full repo understanding work for every task.
14. For every `medium` or `major` change, documentation sync is mandatory before the activity may be reported as done, paused, handed off, or ready for the next bug/feature.
   - Minimum operational updates: `artifacts/operations/WORKFLOW_STATE.md`, `artifacts/operations/CURRENT_TASK.md`, and `artifacts/operations/SESSION_LOG.md`.
   - Also update every relevant source-of-truth artifact touched by the scope, such as bug backlog/log/status, design docs, API specs, release notes, decision log, learnings, memory, or feature registry.
   - If no scope-specific artifact beyond the operational trio needed a change, record that explicitly in `SESSION_LOG.md`.
   - A `medium` or `major` activity is not `resume_safe`, `SUCCESS`, `fixed`, `verified`, `closed`, or `ready to pr` while documentation sync is still pending.
   - For any change request that adds, changes, refactors, or creates a feature/module, the required documentation set also includes an approved plan in `plan/` plus a matching artifact checklist in `artifacts/operations/plan-approval-checklists/` before implementation may start.
   - Technical closure enforcement: record `task_size`, `qa_evidence_required`, and (when needed) `qa_evidence_path` in `CURRENT_TASK.md`; `scripts/validate-documentation-sync.ps1` is the canonical validator. Claude Code must keep its Stop hook configured, and Antigravity must keep `.agents/hooks.json` enabled. A failed validator blocks technical closure; intentional scaffold commits and CI run the same validation.
15. Do not hand off or continue a `medium` or `major` task unless the latest official step has a matching `SESSION_LOG.md` step entry and the required documentation sync fields are recorded.
16. If the latest official step is missing from `SESSION_LOG.md`, set `resume_safe=no`, repair the log first, and do not start the next official step.
17. A `medium` or `major` activity is invalid if execution started before the compact plan and explicit founder approval were recorded in chat or the relevant operational artifact.
18. Before creating or updating any artifact, evidence, log, QA output, release note, memory entry, planning document, or generated documentation, enforce `guardrails/development/ARTIFACT_STORAGE_POLICY.md`.
19. For target repository work under `development/[project-folder]`, client-safe fact and Master Scaffold traceability updates are mandatory before `resume_safe`, `SUCCESS`, `ready to pr`, or handoff may be claimed.
   - Read shared target context before source scanning or continuing work; also read the root activity-log snapshot and relevant entries under the separate activity-log gate.
   - Write client-safe target facts and internal ODN state after meaningful work; append the required activity event to root `artifacts/operations/AGENT_ACTIVITY_LOG.md`.
   - Use target `artifacts/shared/` only for client-safe contract facts. Use `artifacts/traceability-local/[project]/` for internal developer continuation.
   - Commit client-safe facts only from the Target Project Git repository. Keep Project Scaffold internal traceability local and uncommitted; the Master Scaffold `.gitignore` must continue to ignore Target Project files.
20. When first intake has no usable project documentation, do not claim a source-derived baseline is complete until `CODE_DERIVED_BASELINE_POLICY.md` requirements, target `PROJECT_STATE.md`, shared-context updates, and relevant verified memory synchronization are complete.
21. For existing-project implementation, do not open the pre-coding gate until a completed readiness baseline records dependency, environment, database, migration/seed, local run, build, lint/typecheck, test, CI/formatter discovery, and known pre-existing failures or their scoped-development status.

## Bug Listing Rules
- Use root `bug-listing/` as the founder-editable bug-fix input queue.
- Read `bug-listing/list-bug.md` by default when the founder says `cek bug listing`, `kerjakan bug backlog`, `lanjutkan bug`, or does not name a specific bug list.
- Use dynamic bug list names in `bug-listing/[bug-list-name].md`.
- Name bug list files by the most useful working scope: module, page, role, flow, sprint, release, or regression batch.
- Do not use `artifacts/test/bug-list/` as the active founder input queue for new bug lists.
- Keep `artifacts/test/` for bug-fix evidence, bug logs, bug status summaries, QA reports, and verification artifacts.
- For bug-fix modules in `plan/feature-listing.md`, reference the relevant `bug-listing/[bug-list-name].md` or `bug-listing/list-bug.md` whenever one exists.
- When a bug is fixed, verified, or closed, keep these artifacts synchronized:
  - `bug-listing/[bug-list-name].md` or `bug-listing/list-bug.md`
  - `artifacts/test/[module]-bug-log.md`
  - `artifacts/test/[module]-bug-status.md`
- Do not mark a bug complete in only one artifact; the root bug list, bug log, and bug status summary must agree.
- Keep bug IDs stable after creation and preserve fix/verification references for agent-readable history.
- Every bug-fix investigation must perform an adjacent-error check before closure: examine the root cause, direct callers/callees, equivalent validation or state paths, error handling, and the nearest affected integration boundary.
- Record each related finding as `confirmed related bug`, `risk/hypothesis`, or `not reproduced`. A confirmed additional bug receives its own stable bug ID and synchronized listing/log/status entries; do not silently expand the active bug-fix scope.
- Bug-fix QA is incomplete until the original behavior, the adjacent integration boundary, and the related-error findings are recorded. Broad scans or suites still require an allowed reason.
- Do not store passwords, API keys, tokens, or private credentials in bug listing files.

## Memory Rules
- Persistent memory is advisory context, not source of truth.
- Current repository evidence and active artifacts override memory.
- Read `artifacts/memory/MEMORY_INDEX.md` only after reading active operational state.
- Before feature/source scanning, read only relevant memory and feature registry entries after active operational state, then use that context to target repository searches.
- Do not reread or rescan the whole repository when current context, memory, dev-doc, feature registry, or impact evidence already identifies the relevant module paths.
- Capture memory only from real artifacts, logs, decisions, intake outputs, impact scans, QA evidence, or explicit founder instruction.
- If memory conflicts with current evidence, follow the current evidence and mark memory for review in `artifacts/memory/MEMORY_CHANGELOG.md`.
- Use `.codex/agents/memory-curator.md` for memory capture, recall, pruning, and synchronization whenever memory maintenance is requested or a meaningful workflow event completes.
- Treat `artifacts/memory/MEMORY_LEDGER.toml` as the machine-readable memory registry and `artifacts/memory/MEMORY_INDEX.md` as the human-readable summary.
- Automatic memory maintenance must stay within memory and operational-log files; it may not write product code or change workflow gates.
- Target `artifacts/shared/` is a client-safe fact layer; internal developer continuity and handoff resolve from Master Scaffold `artifacts/traceability-local/[project]/`. Scaffold memory remains advisory.
- For a project with no usable documentation, capture memory only from the completed code-derived baseline and its source-linked intake evidence; memory must preserve concise verified facts and targeted discovery paths, not a raw source dump.

## Pre-Coding Gate Rules
- No runtime or agent may write product code unless `guardrails/development/PRE_CODING_POLICY.md` is satisfied and `artifacts/operations/PRE_CODING_GATE.md` shows the gate is open for the current mode.
- If the target repository is not attached, the only allowed modes are read-only audit and documentation updates.
- Implementation requires completed `I1 Existing Project Intake`, completed `I2 Impact Scan`, one approved scoped task, and explicit allowed write paths.
- Implementation also requires an approved plan stored in `plan/` and a completed artifact checklist stored in `artifacts/operations/plan-approval-checklists/` for the same scoped task.
- Feature implementation requires a selected task slice for the current session, relevant context/memory recall, targeted scan paths, and documented allowed write paths.
- Feature implementation in a target repo also requires shared target context to be read before work and updated after meaningful work according to `guardrails/development/SHARED_CONTEXT_POLICY.md`.
- Local development readiness through `start dev` is not implementation and must not require `I2` when no project behavior change is requested.
- If `start dev` reveals that source code, committed config, dependency definitions, migrations, tests, or feature behavior must change, pause local-readiness execution and run `I2` for the discovered scoped change.
- If allowed write paths are missing, stop before coding and repair the task or impact-scan artifact first.
- For existing-project work, clone or attach the target repository into `development/[project-folder]` and use that folder as the active workspace after intake confirms the real route.

## Founder Decision Boundary
Founder-only decisions:
- product vision
- pricing
- roadmap priority
- architecture tradeoffs
- security exceptions
- release approval
- vendor/infrastructure spend
- production incident final action
- framework replacement
- major refactor approval

## Standard Delivery Sequence For Existing Projects
Use `workflows/ai_contributor_lifecycle.md` as the detailed evidence overlay for this sequence.

1. Intake and clarify the current project state
2. Audit architecture, stack, routes, and current constraints
3. Scope one feature, bugfix, migration, or module change
4. For redesign, revamp, flow change, or refactor work, define the exact before/after boundary
5. Synthesize delta requirements
6. Update user/system flow only where impacted
7. Update design only where impacted
8. Validate frontend behavior first when UI is involved
9. Finalize API delta from validated behavior
10. Implement backend against the updated contract
11. Review and integration test
12. Prepare release
13. Verify release readiness
14. Record learnings and next iteration

## Frontend-First Policy
- Frontend must be validated before backend implementation starts when the change affects UI behavior.
- API contract is finalized after frontend behavior and states are approved.
- API specs are stored in `artifacts/architecture/api-specs/`.
- Existing feature requests should use incremental updates, not a full workflow reset.
- Redesign, revamp, and refactor work should still use incremental slices unless the founder explicitly approves a wider rollout plan.

## Requirement Rules
- Use `founder-interviewer` for unclear business intent, conflicting expectations, or missing historical context.
- Use `requirement-synthesizer` after interview notes or intake notes exist.
- Use `flow-designer` after scope and acceptance criteria stabilize.
- Use `solution-architect` before implementing non-trivial features, migrations, refactors, or cross-module changes.
- For any official step invocation, verify the mapped skill/agent from `guardrails/system/SKILL_CATALOG.md` before execution.

## Design Rules
- Store active feature-specific design specs in `dev-doc/[feature-name]/design/`.
- Treat an available approved visual reference as the controlling UI source: this includes Figma, Stitch, mockups, screenshots, and approved HTML prototypes.
- UI implementation must match a complete visual reference as faithfully as the target platform permits, including hierarchy, layout, spacing, typography, colour, assets, responsive behaviour, and represented states. Accessibility and necessary platform adaptations remain mandatory.
- When the visual reference is incomplete or absent, extend the closest established base style or approved design system seamlessly. Record the source, assumptions, and unresolved visual gaps in the affected design specification; do not introduce a new visual direction without founder approval.
- Verify visual fidelity in the required scoped visual QA evidence; a UI visual result cannot be marked `pass` merely because the functional checks pass.
- Before feature/backend/frontend/API/system behavior/refactor/integration/database-related implementation, discover and read related `dev-doc/` material for the feature or module when it exists.
- If no related `dev-doc/` material exists for a new feature, record `dev-doc missing` and create the planning baseline before coding.
- Follow structure: `[page-name]/[section]/[sub-section]/`.
- Document visual/layout/component/interaction specs only for impacted areas.
- Include accessibility and responsive behavior.
- Keep specs synced when requirements change.
- Store feature-specific HTML UI shells or prototypes in `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/prototype/index.html`.
- Treat HTML prototypes as reference artifacts only; do not place them in frontend/backend source code unless an approved development scope explicitly promotes them to production implementation.
- Store reusable shared HTML UI prototype baselines in `templates/design/master-ui-templates/[template-name]/prototype/index.html`.
- Do not create or use `artifacts/design/`; active feature design belongs in `dev-doc/[feature-name]/design/`.

## Build Rules
- Follow `guardrails/architecture/ARCHITECTURE_RULES.md`.
- Prefer the existing framework and folder route unless an approved decision says otherwise.
- Avoid major dependencies without explicit justification.
- Keep Docker-specific artifacts such as compose validation notes, Docker runbooks, env mapping notes, and Docker smoke evidence under `artifacts/docker/`.
- Do not keep Docker scratch files or Docker log outputs in the repo root when `artifacts/docker/` is available.
- Every endpoint needs validation + error handling.
- Sync flows must define retry, idempotency, dedup, and reconciliation.
- For local-client/IoT flows cover offline mode, delayed sync, clock drift, duplicates, partial failure, activation, identity.
- For inherited systems, document every intentional deviation from the current pattern in `artifacts/architecture/DECISION_LOG.md`.

## QA Rules
- Do not mark release-ready if test status is unknown.
- Separate confirmed issues vs hypotheses.
- Enforce `guardrails/qa/QA_TOKEN_EFFICIENCY_POLICY.md` for every QA activity. Default to impact-scoped, targeted checks and use the smallest relevant command first.
- Do not run a full test suite, broad browser suite, full build, or broad regression suite unless the QA evidence records an allowed reason from `QA_TOKEN_EFFICIENCY_POLICY.md`.
- Before repeating QA, compare the current delta with `last_passing_point`; rerun only impacted checks unless a recorded broad-suite reason applies.
- Store concise command summaries and durable evidence paths, not long raw logs, traces, screenshots, coverage dumps, or generated reports in chat, operational logs, or shared context.
- Prefer updating the existing test stack if one already exists and is healthy.
- Before any task against a target repository begins, verify that Playwright and the required browser binaries are already installed and usable for that target. This requirement applies to every target task, including backend-only, native Flutter, firmware, and other non-browser scopes; do not start the task when the prerequisite is missing.
- When Playwright is missing, record the task as blocked and request the founder's explicit approval for the exact target-specific dependency and browser-install command. Installation remains inside an approved allowed-install scope; a requested task does not itself authorize installation.
- Gemini CLI and Gemini/Antigravity agents must run every Playwright command headlessly. They must set or preserve `headless: true` and must not pass `--headed` or otherwise launch a visible browser.
- Once provisioned, Playwright is mandatory whenever the task enters a QA/test list with browser-visible UI, user-flow, responsive, or visual scope. Record a scoped Playwright result; use `skipped` or `blocked` with a reason only when browser QA is genuinely inapplicable or unavailable.
- If the current stack is weak or missing, Playwright remains the default for browser-based QA.
- Keep Playwright runtime artifacts under `artifacts/qa/playwright/` and prepare that folder structure before the first run.
- Keep human-authored QA summaries, bug logs, status summaries, and verification writeups under `artifacts/test/`.
- Every official testing step `R1-R4` must update or create the matching QA evidence artifact, `artifacts/operations/SESSION_LOG.md`, `artifacts/operations/CURRENT_TASK.md`, and `artifacts/operations/WORKFLOW_STATE.md` in the same documentation-sync batch.
- A testing run is not complete and may not be marked `SUCCESS`, `pass`, `verified`, `resume_safe`, or ready for handoff while any required QA evidence, session-log step entry, or operational status sync is still missing.
- Final QA evidence must explicitly record unit, integration, E2E/browser, UI/visual, security, performance, and regression status as `pass`, `fail`, `blocked`, or `skipped`.
- A skipped QA layer must include a reason and must not be treated as passed.
- If manual/browser verification is pending or blocked, record that blocker explicitly in the QA artifact, `CURRENT_TASK.md` remaining work, and `WORKFLOW_STATE.md` next-step status instead of closing the testing phase.
- If a change affects UI, layout, responsive behavior, visual states, animation, charts, canvas, generated images, PDFs/rendered documents, or browser-visible flows that cannot be fully verified automatically, notify the founder explicitly that manual visual QA is required.
- Manual visual QA notification must include the reason, impacted page/route/state, local URL or screenshot evidence when available, checklist to approve, and whether implementation is blocked or can continue with documented risk.
- Do not mark `ui_visual` as `pass`, `verified`, or release-ready until automated visual evidence is sufficient or the founder has approved the required manual visual QA.
- Do not run final impact check or claim `ready to pr` for medium/major work until required granular QA evidence exists or the blocker is documented.

## Release Rules
Release prep must include:
- scope summary
- test summary
- rollback path
- smoke checklist
- configuration checklist
- impact notes for existing users or existing data

For software+IoT releases add site/device validation.

## Documentation Rules
Store formal outputs in:
- `artifacts/access/README.md`
- `dev-doc/[feature-name]/brd.md`
- `dev-doc/[feature-name]/prd.md`
- `dev-doc/[feature-name]/design/`
- `artifacts/flows/`
- `artifacts/architecture/`
- `artifacts/docker/`
- `artifacts/qa/`
- `artifacts/test/`
- `artifacts/release/`
- `artifacts/improvement/`

Use templates from `templates/` when possible.

Removed legacy roots:
- Do not create `artifacts/brd/`, `artifacts/prd/`, or `artifacts/design/`.
- Active BRD and PRD belong in `dev-doc/[feature-name]/`.
- Active feature design belongs in `dev-doc/[feature-name]/design/`.
- Shared design templates belong in `templates/design/master-ui-templates/`.

## Startup Modes
See `artifacts/context/STARTUP_MODE.md` for the current selection and `guardrails/system/STARTUP_MODE_GUIDE.md` for mode definitions:
- `greenfield_project`
- `software_saas`
- `software_iot_sync`
- `internal_ops_system`
- `ai_marketing_engine`

## Greenfield Project Rules
- When the founder sends `start` or `start work`, inspect `development/` with hidden entries included but exclude only scaffold-owned `_project-template/`. Zero target-project folders means `greenfield_project`; one or more target-project folders means existing/inherited-project routing.
- For `greenfield_project`, enforce `guardrails/development/GREENFIELD_PROJECT_POLICY.md` and `workflows/greenfield_project_workflow.md`.
- Greenfield work must not fabricate `I1 Existing Project Intake` or `I2 Impact Scan`. Use `G0-G5` evidence until an actual project baseline exists.
- `start` only selects the route. It does not authorize framework bootstrap, dependency installation, database creation, code generation, or product code.
- Before G5, require founder discovery, first-feature requirement baseline, approved architecture and bootstrap plan, selected task slice, skill lookup or skill-creator fallback, client-safe target facts plus Master Scaffold ODN state, explicit allowed write paths, and exact founder approval.
- After the target repository exists, use the same shared-context, memory, feature slicing, QA, documentation sync, and handoff rules as existing-project work.

## Preferred Existing-Project Style
- Ask focused questions
- Resolve ambiguity quickly
- Respect the current system before changing it
- Produce review-ready delta docs
- Maintain continuity across sessions
- Keep a strong chain from intake -> requirements -> architecture -> build -> QA -> release
