"""Shared utilities for skill-creator scripts."""

import os
import shutil
from pathlib import Path



def parse_skill_md(skill_path: Path) -> tuple[str, str, str]:
    """Parse a SKILL.md file, returning (name, description, full_content)."""
    content = (skill_path / "SKILL.md").read_text()
    lines = content.split("\n")

    if lines[0].strip() != "---":
        raise ValueError("SKILL.md missing frontmatter (no opening ---)")

    end_idx = None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_idx = i
            break

    if end_idx is None:
        raise ValueError("SKILL.md missing frontmatter (no closing ---)")

    name = ""
    description = ""
    frontmatter_lines = lines[1:end_idx]
    i = 0
    while i < len(frontmatter_lines):
        line = frontmatter_lines[i]
        if line.startswith("name:"):
            name = line[len("name:"):].strip().strip('"').strip("'")
        elif line.startswith("description:"):
            value = line[len("description:"):].strip()
            # Handle YAML multiline indicators (>, |, >-, |-)
            if value in (">", "|", ">-", "|-"):
                continuation_lines: list[str] = []
                i += 1
                while i < len(frontmatter_lines) and (frontmatter_lines[i].startswith("  ") or frontmatter_lines[i].startswith("\t")):
                    continuation_lines.append(frontmatter_lines[i].strip())
                    i += 1
                description = " ".join(continuation_lines)
                continue
            else:
                description = value.strip('"').strip("'")
        i += 1

    return name, description, content


def infer_runtime_variant(script_path: str | None = None) -> str | None:
    """Infer runtime variant from the current script path when possible."""
    if not script_path:
        return None
    normalized = script_path.replace("\\", "/")
    if "/.codex/" in normalized:
        return "codex"
    if "/.claude/" in normalized:
        return "claude"
    return None


def get_runtime_cli(script_path: str | None = None) -> str:
    """Resolve which assistant CLI should be used for eval/optimization."""
    override = os.environ.get("SKILL_RUNTIME_CLI")
    if override:
        return override

    variant = infer_runtime_variant(script_path)
    strict_variant = os.environ.get("SKILL_RUNTIME_STRICT_VARIANT", "").strip().lower()
    if not strict_variant:
        strict_variant = "true" if variant == "claude" else "false"

    if strict_variant in {"1", "true", "yes"} and variant in {"claude", "codex"}:
        if shutil.which(variant):
            return variant
        raise RuntimeError(
            f"Strict runtime mode enabled for '{variant}', but that CLI was not found. "
            "Set SKILL_RUNTIME_CLI to override or disable SKILL_RUNTIME_STRICT_VARIANT."
        )

    preferred = ["codex", "claude"] if variant == "codex" else ["claude", "codex"]

    for candidate in preferred:
        if shutil.which(candidate):
            return candidate

    raise RuntimeError(
        "No supported runtime CLI found. Set SKILL_RUNTIME_CLI to a valid executable."
    )


def get_runtime_commands_dir(project_root: Path, script_path: str | None = None) -> Path:
    """Resolve the commands directory used by the active runtime."""
    override = os.environ.get("SKILL_RUNTIME_COMMANDS_SUBDIR")
    if override:
        return project_root / Path(override)

    variant = infer_runtime_variant(script_path)
    if variant == "codex":
        return project_root / ".codex" / "commands"
    if variant == "claude":
        return project_root / ".claude" / "commands"
    if (project_root / ".codex").is_dir():
        return project_root / ".codex" / "commands"
    return project_root / ".claude" / "commands"


def build_runtime_env() -> dict[str, str]:
    """Build a subprocess env with nesting guards removed."""
    env = dict(os.environ)
    raw_guard_vars = os.environ.get("SKILL_RUNTIME_GUARD_ENV_VARS", "CLAUDECODE")
    for key in raw_guard_vars.split(","):
        key = key.strip()
        if key:
            env.pop(key, None)
    return env
