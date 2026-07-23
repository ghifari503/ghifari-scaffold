#!/usr/bin/env node
import { createHash } from "node:crypto";
import { existsSync, readFileSync, unlinkSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";
import { homedir, tmpdir } from "node:os";

const scriptRoot = dirname(fileURLToPath(import.meta.url));
const scaffoldRoot = resolve(scriptRoot, "..");

function fail(message) {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const options = {
    launch: false,
    record: true,
    projectRoot: null,
    legacy: false,
    escalateFrom: null,
    escalationEvidence: null,
    autoDelegate: false,
    taskParts: []
  };
  for (let index = 0; index < argv.length; index += 1) {
    const value = argv[index];
    if (value === "--launch") options.launch = true;
    else if (value === "--dry-run") options.launch = false;
    else if (value === "--no-record") options.record = false;
    else if (value === "--project-root") options.projectRoot = argv[++index];
    else if (value === "--legacy-5-5") options.legacy = true;
    else if (value === "--escalate-from") options.escalateFrom = argv[++index];
    else if (value === "--escalation-evidence") options.escalationEvidence = argv[++index];
    else if (value === "--auto-delegate") options.autoDelegate = true;
    else if (value === "--help" || value === "-h") {
      process.stdout.write("Usage: codex-route [--dry-run|--launch] [--auto-delegate] [--no-record] [--project-root PATH] [--legacy-5-5] [--escalate-from fast|standard --escalation-evidence PATH] TASK\n");
      process.exit(0);
    } else options.taskParts.push(value);
  }
  const task = options.taskParts.join(" ").trim();
  if (!task) fail("A task description is required.");
  if (options.escalateFrom && !["fast", "standard"].includes(options.escalateFrom)) fail("Escalation is allowed only from fast or standard.");
  if (options.escalateFrom && !options.escalationEvidence) fail("--escalation-evidence is required when escalating.");
  if (options.legacy && options.escalateFrom) fail("Legacy routing cannot be combined with escalation.");
  return { ...options, task };
}

function mergeProfiles(base, override) {
  const merged = structuredClone(base);
  for (const [name, profile] of Object.entries(override.profiles ?? {})) {
    merged.profiles[name] = { ...(merged.profiles[name] ?? {}), ...profile };
  }
  return merged;
}

function loadConfig() {
  const defaultPath = join(scaffoldRoot, ".codex", "model-routing.json");
  let config = JSON.parse(readFileSync(defaultPath, "utf8"));
  const overridePath = process.env.CODEX_ROUTING_CONFIG || join(homedir(), ".codex", "model-routing.local.json");
  if (existsSync(overridePath)) {
    config = mergeProfiles(config, JSON.parse(readFileSync(overridePath, "utf8")));
  }
  return { config, overridePath: existsSync(overridePath) ? overridePath : null };
}

function countMatches(text, patterns, reasons, score) {
  for (const [pattern, points, reason] of patterns) {
    if (pattern.test(text)) {
      score.value += points;
      reasons.push(reason);
    }
  }
}

function classify(task, legacyRequested = false) {
  const text = task.toLowerCase();
  const reasons = [];
  const score = { value: 0 };
  const critical = [
    [/\bsecurity\b|\bkeamanan\b|\bauthentication\b|\bauthorization\b|\bauth\b/, 7, "security or access-control impact"],
    [/\bmigration\b|\bmigrasi\b|\bdata loss\b|\bdestructive\b/, 7, "migration or destructive-data impact"],
    [/\bproduction\b|\bincident\b|\bpayment\b|\bprivacy\b/, 6, "production or high-impact domain"],
    [/\brace condition\b|\bdeadlock\b|\bconcurrency\b/, 6, "concurrency risk"]
  ];
  const complex = [
    [/\barchitecture\b|\barsitektur\b|\bcross[- ]module\b|\bmicroservice\b/, 4, "architecture or cross-module scope"],
    [/\brefactor\b|\bbackward compatibility\b|\bcompatibility\b/, 4, "compatibility-sensitive refactor"],
    [/\bdatabase\b|\bschema\b|\btransaction\b/, 4, "database impact"],
    [/\bperformance\b|\boptimasi\b|\bdeployment\b|\brelease\b/, 3, "performance or delivery impact"],
    [/\bapi\b|\bendpoint\b|\bintegration\b/, 2, "contract or integration impact"],
    [/\bbug\b|\bdebug\b|\berror\b|\bfailure\b/, 2, "debugging required"],
    [/\btest\b|\btesting\b|\bqa\b/, 1, "validation required"],
    [/\bunclear\b|\bambiguous\b|\btidak jelas\b|\bunknown\b/, 3, "requirement ambiguity"]
  ];
  const simple = [
    [/\btypo\b|\bspelling\b/, -3, "isolated text correction"],
    [/\brename\b/, -2, "rename"],
    [/\bformat(?:ting)?\b/, -2, "formatting"],
    [/\bdocumentation\b|\bdocumentasi\b|\bdocs\b/, -1, "documentation" ]
  ];
  countMatches(text, critical, reasons, score);
  countMatches(text, complex, reasons, score);
  countMatches(text, simple, reasons, score);

  const components = ["frontend", "backend", "database", "devops", "infrastructure", "deployment", "api", "mobile", "iot"];
  const componentCount = components.filter((component) => text.includes(component)).length;
  if (componentCount >= 3) { score.value += 4; reasons.push("cross-component change"); }
  else if (componentCount === 2) { score.value += 2; reasons.push("multiple components"); }

  const wordCount = task.split(/\s+/).filter(Boolean).length;
  if (wordCount > 250) { score.value += 4; reasons.push("very long task description"); }
  else if (wordCount > 100) { score.value += 2; reasons.push("long task description"); }

  const criticalRisk = critical.some(([pattern]) => pattern.test(text));
  let level = "simple";
  if (criticalRisk || score.value >= 14) level = "critical";
  else if (score.value >= 8) level = "complex";
  else if (score.value >= 1) level = "medium";

  const routing = {
    simple: { profile: "fast", agent: "task_explorer", accuracyFloor: "targeted evidence" },
    medium: { profile: "standard", agent: "bugfix_worker", accuracyFloor: "targeted validation" },
    complex: { profile: "deep", agent: "deep_reviewer", accuracyFloor: "implementation plus independent review" },
    critical: { profile: "critical", agent: "critical_reviewer", accuracyFloor: "independent review and founder-controlled gates" }
  };
  if (legacyRequested) {
    return {
      level: "legacy",
      score: score.value,
      reasons: [...new Set([...reasons, "explicit GPT-5.5 legacy or benchmark request"])],
      wordCount,
      componentCount,
      profile: "legacy",
      agent: "bugfix_worker",
      accuracyFloor: "legacy reproducibility or benchmark"
    };
  }
  return { level, score: score.value, reasons: [...new Set(reasons)], wordCount, componentCount, ...routing[level] };
}

function applyEscalation(classification, options) {
  if (!options.escalateFrom) return classification;
  const profile = options.escalateFrom === "fast" ? "standard" : "deep";
  const agent = options.escalateFrom === "fast" ? "bugfix_worker" : "deep_reviewer";
  const accuracyFloor = options.escalateFrom === "fast" ? "targeted validation" : "implementation plus independent review";
  return {
    ...classification,
    profile,
    agent,
    accuracyFloor,
    reasons: [...new Set([...classification.reasons, `documented escalation from ${options.escalateFrom}`])],
    escalation: { from: options.escalateFrom, evidence: options.escalationEvidence }
  };
}

function findProjectRoot(explicitRoot) {
  if (explicitRoot) return resolve(explicitRoot);
  let cursor = process.cwd();
  while (true) {
    if (existsSync(join(cursor, "artifacts", "shared"))) return cursor;
    const parent = dirname(cursor);
    if (parent === cursor) return null;
    cursor = parent;
  }
}

function appendRecord(projectRoot, record) {
  if (!projectRoot) return null;
  const sharedRoot = join(projectRoot, "artifacts", "shared");
  if (!existsSync(sharedRoot)) return null;
  const logPath = join(sharedRoot, "AI_ROUTING_LOG.md");
  const header = "# AI Routing Log\n\n| Time | Task ID | Level | Profile | Agent | Model | Effort | Token/Cost | Status | Reasons |\n|---|---|---|---|---|---|---|---|---|---|\n";
  let content = existsSync(logPath) ? readFileSync(logPath, "utf8") : header;
  const line = `| ${record.time} | ${record.taskId} | ${record.level} | ${record.profile} | ${record.agent} | ${record.model} | ${record.effort} | ${record.tokenBand}/${record.costBand} | ${record.status} | ${record.reasons.join("; ") || "none"} |\n`;
  const lines = content.trimEnd().split("\n");
  if (lines.length > 202) content = `${lines.slice(0, 4).join("\n")}\n${lines.slice(-198).join("\n")}\n`;
  writeFileSync(logPath, `${content.trimEnd()}\n${line}`, "utf8");
  return logPath;
}

function delegationAction(config, profile, options) {
  if (!options.autoDelegate) return "not_requested";
  if (profile === config.automation?.supervisorProfile) return "orchestrator_continue";
  if (!(config.automation?.delegateProfiles ?? []).includes(profile)) return "not_allowed_for_profile";
  return options.launch ? "delegating" : "would_delegate";
}

function delegationLockPath(projectRoot) {
  const workspaceKey = createHash("sha256").update(projectRoot ?? process.cwd()).digest("hex").slice(0, 16);
  return join(tmpdir(), `codex-route-${workspaceKey}.lock`);
}

function acquireDelegationLock(projectRoot, config, decision) {
  if ((config.automation?.maxActiveWorkersPerWorkspace ?? 1) !== 1) fail("Automatic delegation supports exactly one active worker per workspace.");
  const lockPath = delegationLockPath(projectRoot);
  const staleMs = (config.automation?.staleLockMinutes ?? 90) * 60 * 1000;
  if (existsSync(lockPath)) {
    try {
      const existing = JSON.parse(readFileSync(lockPath, "utf8"));
      if (Date.now() - Date.parse(existing.startedAt) > staleMs) unlinkSync(lockPath);
    } catch {
      fail(`Delegation lock cannot be verified: ${lockPath}`);
    }
  }
  try {
    writeFileSync(lockPath, JSON.stringify({ taskId: decision.taskId, startedAt: new Date().toISOString() }), { encoding: "utf8", flag: "wx" });
    return lockPath;
  } catch {
    return null;
  }
}

function runDelegatedWorker(decision, options, projectRoot) {
  const workerPrompt = [
    "You are an automatically delegated Codex worker.",
    "Read and follow AGENTS.md and all active scaffold gates before acting.",
    "Work only on the task below. Do not delegate again, widen scope, or start another Codex session.",
    "Return concise evidence, validation status, and remaining risks to the supervising agent.",
    "",
    `Task: ${options.task}`
  ].join("\n");
  const workerArgs = [
    "exec",
    "--ephemeral",
    "--model", decision.model,
    "--config", `model_reasoning_effort=\"${decision.reasoningEffort}\"`,
    "--cd", projectRoot ?? process.cwd(),
    workerPrompt
  ];
  return spawnSync("codex", workerArgs, { stdio: "inherit" });
}

const options = parseArgs(process.argv.slice(2));
const { config, overridePath } = loadConfig();
const classification = applyEscalation(classify(options.task, options.legacy), options);
const profile = config.profiles[classification.profile];
if (!profile?.model || !profile?.reasoningEffort) fail(`Profile ${classification.profile} is incomplete.`);

const taskId = createHash("sha256").update(options.task).digest("hex").slice(0, 12);
const projectRoot = findProjectRoot(options.projectRoot);
const decision = {
  taskId,
  level: classification.level,
  score: classification.score,
  profile: classification.profile,
  agent: classification.agent,
  model: profile.model,
  reasoningEffort: profile.reasoningEffort,
  tokenBand: profile.tokenBand,
  costBand: profile.costBand,
  accuracyFloor: classification.accuracyFloor,
  reasons: classification.reasons,
  escalation: classification.escalation ?? null,
  routeMode: options.legacy ? "explicit_legacy" : options.escalateFrom ? "documented_escalation" : "automatic_classification",
  fallback: config.fallback,
  localOverride: overridePath,
  projectRoot,
  actualUsage: "unavailable_from_codex_cli"
};
decision.delegation = {
  mode: options.autoDelegate ? "automatic" : "manual",
  action: delegationAction(config, decision.profile, options),
  maxActiveWorkersPerWorkspace: config.automation?.maxActiveWorkersPerWorkspace ?? 1
};

if (options.record) {
  decision.recordPath = appendRecord(projectRoot, {
    time: new Date().toISOString(),
    taskId,
    level: decision.level,
    profile: decision.profile,
    agent: decision.agent,
    model: decision.model,
    effort: decision.reasoningEffort,
    tokenBand: decision.tokenBand,
    costBand: decision.costBand,
    status: decision.delegation.action === "orchestrator_continue" ? "orchestrator_continue" : decision.delegation.action === "delegating" ? "delegating" : decision.delegation.action === "would_delegate" ? "would_delegate" : "planned",
    reasons: decision.reasons
  });
}

process.stdout.write(`${JSON.stringify(decision, null, 2)}\n`);
if (!options.launch) process.exit(0);

if (options.autoDelegate) {
  if (decision.delegation.action === "orchestrator_continue") process.exit(0);
  if (decision.delegation.action !== "delegating") fail(`Automatic delegation is not allowed for profile ${decision.profile}.`);
  const lockPath = acquireDelegationLock(projectRoot, config, decision);
  if (!lockPath) {
    if (options.record) {
      appendRecord(projectRoot, {
        time: new Date().toISOString(), taskId, level: decision.level, profile: decision.profile, agent: decision.agent,
        model: decision.model, effort: decision.reasoningEffort, tokenBand: decision.tokenBand, costBand: decision.costBand,
        status: "delegation_blocked_active_worker", reasons: [...decision.reasons, "active worker lock present"]
      });
    }
    fail("Automatic delegation blocked because another worker is active for this workspace.");
  }
  let result;
  try {
    result = runDelegatedWorker(decision, options, projectRoot);
  } catch {
    result = { status: 1, error: true };
  } finally {
    unlinkSync(lockPath);
  }
  if (options.record) {
    appendRecord(projectRoot, {
      time: new Date().toISOString(), taskId, level: decision.level, profile: decision.profile, agent: decision.agent,
      model: decision.model, effort: decision.reasoningEffort, tokenBand: decision.tokenBand, costBand: decision.costBand,
      status: result?.status === 0 ? "delegated_completed" : "delegated_failed_report_only",
      reasons: result?.status === 0 ? decision.reasons : [...decision.reasons, result?.error ? "delegated worker could not start; no automatic rerun" : "delegated worker failed; no automatic rerun"]
    });
  }
  process.exit(result?.status ?? 1);
}

const result = spawnSync("codex", ["--model", decision.model, "--config", `model_reasoning_effort=\"${decision.reasoningEffort}\"`, options.task], { stdio: "inherit" });
if (options.record) {
  appendRecord(projectRoot, {
    time: new Date().toISOString(),
    taskId,
    level: decision.level,
    profile: decision.profile,
    agent: decision.agent,
    model: decision.model,
    effort: decision.reasoningEffort,
    tokenBand: decision.tokenBand,
    costBand: decision.costBand,
    status: result.status === 0 ? "completed" : "failed_report_only",
    reasons: result.status === 0 ? decision.reasons : [...decision.reasons, "Codex launch failed; no automatic rerun"]
  });
}
process.exit(result.status ?? 1);
