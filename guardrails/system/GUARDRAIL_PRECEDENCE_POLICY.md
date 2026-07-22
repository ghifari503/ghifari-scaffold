# Guardrail Precedence Policy

## Purpose
This policy defines how scaffold-level guardrails and cloned-repository guardrails must be interpreted together by Codex, Claude, Gemini, and compatible AI contributors.

Use this policy whenever work involves a cloned, attached, inherited, or externally generated repository.

## Core Principle
- The scaffold owns the process.
- The cloned repository owns local codebase conventions.
- The founder owns explicit business and change decisions.

These layers must be merged in a deterministic order instead of letting one source silently override the others.

## Precedence Order
Apply instructions from highest authority to lowest authority:

1. Platform and runtime safety rules
   - System, tool, sandbox, approval, and non-destructive behavior rules.
   - These rules cannot be overridden by any repository document.
2. Scaffold source-of-truth guardrails
   - Files under `guardrails/`
   - Official workflow definitions
   - Required artifact paths
   - Logging, QA, handoff, memory, and pre-coding gate rules
3. Active scaffold operational state and explicit founder decisions
   - `artifacts/operations/`
   - approved scope
   - allowed write paths
   - current gate status
   - current task decisions
4. Cloned repository guardrails and contribution rules
   - local `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `CONTRIBUTING.md`, `README.md`, and similar files
   - repository architecture, command, testing, and branch conventions
5. Repository-discovered implementation conventions
   - package manager choice
   - framework folder structure
   - test runner already used by the repo
   - naming and module patterns inferred from the codebase

## What The Scaffold Always Controls
The cloned repository may not override these scaffold responsibilities:
- official gate order
- artifact and evidence paths owned by the scaffold
- logging and handoff requirements
- pre-coding approval requirements
- documentation sync requirements
- QA evidence shape and status labels
- runtime parity expectations when parity is active
- safety boundaries and escalation rules

## What The Cloned Repository Controls
When a cloned repository provides explicit local rules, treat it as the authority for:
- build, run, lint, test, and dev commands
- framework-specific setup
- architecture and module boundaries
- repository coding conventions
- translation, validation, DTO, ORM, and component usage rules
- branch, PR, CLA, and contribution expectations
- existing test stack preferences
- environment assumptions specific to that codebase

## Merge Rule
Use additive merge by default:
- If the scaffold defines a process rule and the repository defines a technical execution rule, apply both.
- If the scaffold requires a QA gate and the repository defines the correct test command, keep the scaffold gate and use the repository command.
- If the scaffold defines logging requirements and the repository defines Laravel or React coding conventions, keep both.

Do not drop a scaffold rule only because the repository did not mention it.
Do not ignore a repository technical rule only because the scaffold is more general.

## Intake Requirement
Before coding, installation, migration, refactor, or code generation on a cloned repository:
- run the cloned-repo intake checklist
- inventory local guardrail files
- summarize the repository-specific rules that affect execution
- check for conflicts against scaffold guardrails
- document any unresolved conflict before proceeding

## Missing Local Guardrails
If the repository has no explicit local guardrail files:
- do not assume there are no conventions
- inspect `README`, manifests, scripts, folder structure, test setup, and contribution docs
- infer only low-risk technical conventions from the codebase
- mark inferred conventions as inferred, not explicit

## Founder Decision Override
The founder may approve a scoped exception when two valid rules conflict.

Even with founder approval:
- platform safety rules still cannot be overridden
- the exception must be documented in the active task, session log, and decision log when the effect is durable

## Runtime Parity Requirement
Codex, Claude, and Gemini must interpret cloned-repository guardrails using the same precedence order, the same conflict labels, and the same required evidence fields.

Runtime differences may change command syntax or tooling details, but they may not change:
- which layer wins
- whether a conflict must be escalated
- where the decision is recorded

## Minimum Evidence
For cloned-repository work, intake or readiness evidence must record:
- which local guardrail files were found
- which files were read
- which rules materially affect execution
- whether the rules are explicit or inferred
- whether conflicts were found
- how each conflict was resolved or escalated
