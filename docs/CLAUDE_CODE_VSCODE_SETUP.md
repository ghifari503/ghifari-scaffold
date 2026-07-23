# Claude Code VS Code Setup

## Purpose

Use the Claude Code VS Code extension with the scaffold's automatic task routing without misrepresenting permission modes as model selection.

## Project Configuration

This repository provides:

- `.claude/settings.json`: Sonnet as the initial project model for new Claude Code sessions.
- `.claude/model-routing.json`: model, risk, and relative token/cost routing baseline.
- `.claude/agents/claude-routing-supervisor.md`: Sonnet supervisor.
- `.claude/agents/claude-fast-worker.md`: Haiku bounded worker.
- `.claude/agents/claude-deep-reviewer.md`: Opus bounded reviewer.

Restart or start a new Claude conversation after pulling changes so project agents are discovered.

## Automatic Behavior

The active Claude session applies the routing policy before coding. It may use native model-aware subagents for isolated L0 work or L3 analysis/review. The developer does not select a model for each task.

The visible VS Code conversation model remains unchanged during that conversation. The extension's `Auto` permission mode controls tool approvals; it does not choose Haiku, Sonnet, Opus, or Fable.

## Fable Availability

Claude Code supports `haiku`, `sonnet`, and `opus` aliases, plus supported full model IDs. Configure an actual Fable-compatible full model ID only in developer-local or managed provider configuration after confirming it is available. Do not commit credentials, gateway URLs, or account-specific model IDs to this repository.

When no verified Fable model is available, the policy records `model_switch_unavailable` and does not pretend that an L4 task was delegated.

## Validation

Run:

```powershell
./scripts/check-claude-routing.ps1
```

On Unix-like shells:

```bash
./scripts/check-claude-routing.sh
```

Official references: [Claude Code in VS Code](https://code.claude.com/docs/en/vs-code), [model configuration](https://code.claude.com/docs/en/model-config), and [custom subagents](https://code.claude.com/docs/en/sub-agents).
