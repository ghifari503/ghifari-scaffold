# Token Optimization & Engineering Efficiency Policy

## Purpose

Enforce strict token efficiency, direct communication, targeted code modifications, compact debugging output, and structured architectural analysis across all AI runtimes (Antigravity, Codex, Claude, Gemini CLI) for all software engineering activities (coding, QA, code review, debugging, and architectural design).

---

## 1. Communication Principles

- **Zero Conversational Fluff:** Eliminate opening greetings, pleasantries ("Sure, I can help with that..."), meta-announcements ("Here is the code:"), and conversational padding.
- **Direct to the Point:** Begin responses immediately with the technical solution, code snippet, or data answer.
- **No Labelled Closing:** Do not append labelled closing blocks such as `Kesimpulan:`, `Summary:`, or `Notes:` at the end of responses unless specifically requested by an official lifecycle artifact template.

---

## 2. Coding & Refactoring Standards

- **Diff / Targeted Replacement:** Never rewrite an entire file when modifying specific functions, classes, or lines. Use targeted replacement tools (`replace_file_content` / `multi_replace_file_content`) or concise contextual diff snippets.
- **Minimalist Comments:** Write code comments only for non-obvious, highly complex business logic or algorithmic nuances. Avoid trivial comments explaining standard language syntax.
- **Compact & Clean:** Omit unused library imports, dead boilerplate, and empty placeholder comments in solution code.

---

## 3. Debugging, QA & Testing Rules

- **3-Line Problem Analysis Structure:** When reporting or presenting debugging diagnoses, format in 3 concise points:
  1. **Root Cause:** Exactly 1 clear sentence explaining the defect.
  2. **Fix:** Essential targeted code snippet addressing the root cause.
  3. **Test Case:** Specific assert / test case verifying the fix and preventing regression.
- **Efficient Test Suites:** When authoring unit or integration tests, write only the core test runner logic and key edge-case scenarios. Avoid redundant boilerplate assertions for trivial getters/setters. Enforce [`guardrails/qa/QA_TOKEN_EFFICIENCY_POLICY.md`](file:///e:/www/project-scaffold/guardrails/qa/QA_TOKEN_EFFICIENCY_POLICY.md).

---

## 4. Analysis & Architecture Formatting

- **Scaffolding via Tables & Bullets:** Use Markdown tables for comparing features, data schemas, or configuration options. Use short bullet points for implementation steps.
- **Paragraph Limits:** Limit theoretical explanations and descriptive context to a maximum of 2–3 sentences per point.
- **Solution-Focused Matrices:** Prioritize Trade-off Analysis (Pros vs Cons) in a matrix/table format rather than long narrative paragraphs.
