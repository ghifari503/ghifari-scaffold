# Interview-Based Planning Workflow

## Scope and Strictness
This guardrail defines the **strict and unskippable** procedure for planning new tasks, features, or any significant implementation. **No AI agent (Codex, Claude, or Gemini) may skip this workflow or auto-generate a plan without user interview.** 

## Prerequisite: Readiness Pass
> **CRITICAL RULE**: The interview and planning process **MUST NOT** begin until the target application has passed its readiness check.
> - The target repository must be attached.
> - The application must be running well on the local computer (`start dev`).
> - If readiness is not verified, the agent must stop and prompt the user to fulfill the readiness criteria first.

## The 7-Step Interview Planning Workflow

If the prerequisite is met, the agent must strictly follow these 7 steps in order:

### 1. Interactive Interview
- The agent must interview the user about what they want to do next.
- Ask questions one by one or in small, focused batches.
- Continue the interview iteratively until the context, requirements, and goal are absolutely clear.

### 2. Guide Confused Users
- If the user appears confused, unsure, or requests guidance, the agent **must** proactively help by providing clear, structured options or recommendations.
- Do not leave the user stuck.

### 3. Draft the Plan
- Once the interview concludes and the context is clear, the agent synthesizes the results into a structured implementation plan.
- The plan must cover the objective, proposed changes, files impacted, and execution steps.

### 4. User Confirmation
- Present the drafted plan to the user for review.
- Ask for explicit confirmation: *"Is this plan suitable, or do you want to make any adjustments?"*
- Do not proceed until the user explicitly approves the plan.

### 5. Document the Plan (Root `plan/` Folder)
- Once approved, the agent must write the final plan into the root `plan/` directory.
- **Naming Convention**: The document must be given a title based on its context plus the creation date.
  - Format: `plan/[context-name]-[YYYY-MM-DD].md`
  - Example: `plan/auth-module-refactor-2026-06-22.md`
- The file must be saved purely in the `plan/` root folder, bypassing any other default documentation routes for this specific artifact.

### 6. Record the Approval Checklist (Artifact)
- After the founder approves the plan, the agent must create or update a matching artifact checklist under `artifacts/operations/plan-approval-checklists/`.
- **Naming Convention**:
  - Format: `artifacts/operations/plan-approval-checklists/[task-id]-[context-name]-plan-approval.md`
  - Example: `artifacts/operations/plan-approval-checklists/TASK-20260622-001-auth-module-refactor-plan-approval.md`
- The artifact must be created from `templates/plan_approval_checklist_template.md`.
- The checklist must explicitly record:
  - the request scope
  - the matching `plan/` file path
  - the founder review status
  - the explicit approval reference
  - whether build/coding is still blocked or allowed
- If this artifact is missing, implementation remains blocked even if the plan file already exists.

### 7. Execute the Plan
- After the plan is saved and the approval checklist artifact is recorded, the agent proceeds to execute the plan strictly following the documented steps.
