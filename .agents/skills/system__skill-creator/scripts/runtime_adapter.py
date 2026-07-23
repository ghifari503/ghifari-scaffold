#!/usr/bin/env python3
"""Runtime adapter helpers for dual Claude/Codex skill tooling."""

from __future__ import annotations

import json
import os
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path

from scripts.utils import build_runtime_env, get_runtime_cli, get_runtime_commands_dir


@dataclass(frozen=True)
class RuntimeConfig:
    """Resolved runtime configuration for skill tooling."""

    cli: str
    commands_dir: Path
    env_guard_vars: tuple[str, ...]
    strict_variant: bool


def resolve_runtime(project_root: Path, script_path: str | None = None) -> RuntimeConfig:
    """Resolve the active runtime and commands directory."""
    raw_guard_vars = build_runtime_env().keys()
    configured_guard_vars = tuple(
        v.strip()
        for v in __import__("os").environ.get("SKILL_RUNTIME_GUARD_ENV_VARS", "CLAUDECODE").split(",")
        if v.strip()
    )
    return RuntimeConfig(
        cli=get_runtime_cli(script_path),
        commands_dir=get_runtime_commands_dir(project_root, script_path),
        env_guard_vars=configured_guard_vars if configured_guard_vars else tuple(raw_guard_vars),
        strict_variant=os.environ.get("SKILL_RUNTIME_STRICT_VARIANT", "").strip().lower() in {"1", "true", "yes"},
    )


def runtime_probe(config: RuntimeConfig, timeout: int = 15) -> dict:
    """Collect lightweight runtime diagnostics without mutating project state."""
    cli_path = shutil.which(config.cli)
    probe = {
        "cli": config.cli,
        "cli_found": bool(cli_path),
        "cli_path": cli_path,
        "commands_dir": str(config.commands_dir),
        "commands_dir_exists": config.commands_dir.exists(),
        "env_guard_vars": list(config.env_guard_vars),
        "strict_variant": config.strict_variant,
        "version": None,
        "version_error": None,
        "capabilities": {},
    }

    if not cli_path:
        probe["version_error"] = "CLI executable not found in PATH."
        return probe

    for version_args in (["--version"], ["version"], ["-V"]):
        try:
            result = subprocess.run(
                [config.cli, *version_args],
                capture_output=True,
                text=True,
                timeout=timeout,
                env=build_runtime_env(),
            )
        except Exception as exc:  # pragma: no cover - defensive probe path
            probe["version_error"] = str(exc)
            continue

        output = (result.stdout or result.stderr).strip()
        if result.returncode == 0 and output:
            probe["version"] = output.splitlines()[0]
            probe["version_args"] = version_args
            break

    if not probe["version"] and not probe["version_error"]:
        probe["version_error"] = "Runtime did not return a readable version string."

    capability_checks = {
        "supports_prompt_flag": ["-p", "runtime smoke test prompt", "--help"],
        "supports_output_format_flag": ["-p", "runtime smoke test prompt", "--output-format", "text", "--help"],
    }
    for name, args in capability_checks.items():
        try:
            result = subprocess.run(
                [config.cli, *args],
                capture_output=True,
                text=True,
                timeout=timeout,
                env=build_runtime_env(),
            )
            probe["capabilities"][name] = {
                "ok": result.returncode == 0,
                "returncode": result.returncode,
                "sample_output": ((result.stdout or result.stderr).strip().splitlines() or [""])[0][:200],
            }
        except Exception as exc:  # pragma: no cover - defensive probe path
            probe["capabilities"][name] = {
                "ok": False,
                "error": str(exc),
            }
    return probe


def probe_as_json(project_root: Path, script_path: str | None = None) -> str:
    """Return the runtime probe as formatted JSON."""
    return json.dumps(runtime_probe(resolve_runtime(project_root, script_path)), indent=2)


def detect_runtime_cli(preferred: str | None = None, script_path: str | None = None) -> str:
    """Return runtime CLI name, honoring explicit preference when provided."""
    if preferred:
        return preferred
    return get_runtime_cli(script_path)


def is_codex_runtime(runtime_cli: str) -> bool:
    """Return True when selected runtime points to Codex CLI."""
    return Path(runtime_cli).name.lower() == "codex"


def build_eval_command(runtime_cli: str, query: str, model: str | None) -> list[str]:
    """Build streaming eval command for active runtime."""
    if is_codex_runtime(runtime_cli):
        cmd = [runtime_cli, "exec", "--skip-git-repo-check", "--json", query]
        if model:
            cmd.extend(["-m", model])
        return cmd

    cmd = [
        runtime_cli,
        "-p",
        query,
        "--output-format",
        "stream-json",
        "--verbose",
        "--include-partial-messages",
    ]
    if model:
        cmd.extend(["--model", model])
    return cmd


def build_text_command(
    runtime_cli: str,
    prompt_or_query: str,
    model: str | None,
    output_file: str | None = None,
) -> list[str]:
    """Build one-shot text command for active runtime."""
    if is_codex_runtime(runtime_cli):
        cmd = [runtime_cli, "exec", "--skip-git-repo-check", prompt_or_query]
        if model:
            cmd.extend(["-m", model])
        if output_file:
            cmd.extend(["-o", output_file])
        return cmd

    cmd = [runtime_cli, "-p", "--output-format", "text"]
    if model:
        cmd.extend(["--model", model])
    return cmd
