# MEMORY_RECALL_RULES

## Read Order
Use this order when memory is relevant:

1. Active operational state in `artifacts/operations/`.
2. Current task source artifacts.
3. `artifacts/memory/MEMORY_INDEX.md`.
4. `artifacts/memory/MEMORY_LEDGER.toml`.
5. `artifacts/memory/FEATURE_REGISTRY.toml` and `artifacts/memory/FEATURE_REGISTRY.md` when feature/module status matters.
6. Relevant memory file under `artifacts/memory/`.

## Relevance Filter
Recall only memory that helps with the current task:
- active project mode
- gate status
- current repository route
- approved decisions
- feature and module status
- impacted systems and dependencies
- known constraints
- recurring workflow preferences
- prior failures or reusable lessons

## Conflict Handling
If memory conflicts with current source files:
- Follow the current source files.
- Do not silently use the memory.
- Add a review note to `artifacts/memory/MEMORY_CHANGELOG.md`.
- Mark the memory `candidate`, `superseded`, or `obsolete` when appropriate.

## Output Rule
When memory materially affects a recommendation, mention the memory source in the response or handoff.
