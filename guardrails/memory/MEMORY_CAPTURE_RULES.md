# MEMORY_CAPTURE_RULES

## When To Capture
Capture a memory candidate when one of these happens:
- A repeated workflow preference is confirmed.
- A feature or module is discovered, scoped, blocked, tested, released, deprecated, or linked to another system.
- A project constraint is discovered during intake or impact scan.
- A decision is approved and likely to matter across sessions.
- A failure teaches a reusable lesson.
- A task dependency or blocker must survive context loss.

## Capture Flow
1. Identify the source artifact.
2. Add or update the structured entry in `artifacts/memory/MEMORY_LEDGER.toml`.
3. If the entry is feature/module status, update `artifacts/memory/FEATURE_REGISTRY.toml` and `artifacts/memory/FEATURE_REGISTRY.md`.
4. Write a short memory candidate in the relevant `artifacts/memory/*.md` category file when the entry is not solely feature-registry state.
5. Add or update the entry in `artifacts/memory/MEMORY_INDEX.md`.
6. Set `status` to `candidate` unless the source is already approved or final.
7. Promote to `verified` only when the source artifact supports it.
8. Append a concise note to `artifacts/memory/MEMORY_CHANGELOG.md`.

## Do Not Capture
- Speculation.
- Temporary reasoning.
- Sensitive information.
- Raw command output unless it is summarized and linked.
- Details that are already obvious from current active files.
- Feature status changes without a source artifact or explicit founder instruction.

## Preferred Summary Shape
Use this Markdown form for category files:

```markdown
### `MEM-[category]-[NNN]`
- type: `[project_fact|workflow_pattern|constraint|decision_summary|task_node|feature_status|learning_summary]`
- status: `[candidate|verified|superseded|obsolete]`
- confidence: `[low|medium|high]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- source: `[path]`
- review_after: `YYYY-MM-DD`
- summary: `One durable sentence.`
```

Use this TOML form for `MEMORY_LEDGER.toml`:

```toml
[[entries]]
id = "MEM-[category]-[NNN]"
type = "project_fact"
status = "candidate"
confidence = "medium"
created_at = "YYYY-MM-DDTHH:mm:ss+07:00"
updated_at = "YYYY-MM-DDTHH:mm:ss+07:00"
source = "path/to/source.md"
review_after = "YYYY-MM-DD"
summary = "One durable sentence."
```

Use `FEATURE_REGISTRY.toml` for detailed feature/module state:

```toml
[[features]]
id = "FEAT-001"
name = "Feature name"
type = "feature"
status = "impact_scanned"
current_gate = "I2"
source = "artifacts/improvement/impact-scan.md"
last_updated_at = "YYYY-MM-DDTHH:mm:ss+07:00"
owner_runtime = "codex"
summary = "One sentence summary."
impacted_systems = ["frontend", "backend", "database"]
depends_on = []
blocks = []
related_artifacts = []
related_tests = []
risks = []
notes = ""
```
