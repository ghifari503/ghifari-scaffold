# Task Classification

## Metadata
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[codex|claude|gemini|manual]`
- task_id: `TASK-YYYYMMDD-001`
- classifier: `guardrails/system/TASK_TYPE_CLASSIFICATION.md`
- registry: `guardrails/system/TASK_TYPE_REGISTRY.md`

## Classification
- user_intent: `...`
- primary_task_type: `[feature-development|bug-fix|ui-prototype|ui-revamp|refactor|integration|database-change|data-migration|test-automation|performance-optimization|security-fix|dependency-upgrade|devops-deployment|incident-hotfix|documentation-sync|review-only|legacy-artifact-migration|local-dev-readiness]`
- secondary_task_types: `[none|...]`
- confidence: `[high|medium|low]`
- risk_level: `[low|medium|high|critical]`
- confirmation_required: `[yes|no]`

## Gate Mapping
- requires_intake: `[yes|no|already_done]`
- requires_impact_scan: `[yes|no|if_source_change_discovered]`
- requires_pre_coding_gate: `[yes|no|if_product_code_change]`
- requires_founder_confirmation: `[yes|no]`
- allowed_mode_now: `[read_only|documentation_only|implementation_allowed|blocked]`

## Required Inputs
- `...`

## Required Artifacts
- `...`

## Required Tests Or Checks
- `...`

## Stop Conditions
- `...`

## Next Action
- `...`

