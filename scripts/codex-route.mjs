#!/usr/bin/env node
import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";
import { homedir } from "node:os";

const scriptRoot = dirname(fileURLToPath(import.meta.url));
const scaffoldRoot = resolve(scriptRoot, "..");

function fail(message) {
  process.stderr.write(`${message}\n`);
  process.exit(1);
}

function parseArgs(argv) {
  const options = { launch: false, record: true, projectRoot: null, taskParts: [] };
  for (let index = 0; index < argv.length; index += 1) {
    const value = argv[index];
    if (value === "--launch") options.launch = true;
    else if (value === "--dry-run") options.launch = false;
    else if (value === "--no-record") options.record = false;
    else if (value === "--project-root") options.projectRoot = argv[++index];
    else if (value === "--help" || value === "-h") {
      process.stdout.write("Usage: codex-route [--dry-run|--launch] [--no-record] [--project-root PATH] TASK\n");
      process.exit(0);
    } else options.taskParts.push(value);
  }
  const task = options.taskParts.join(" ").trim();
  if (!task) fail("A task description is required.");
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

function classify(task) {
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
    critical: { profile: "deep", agent: "deep_reviewer", accuracyFloor: "independent review and founder-controlled gates" }
  };
  return { level, score: score.value, reasons: [...new Set(reasons)], wordCount, componentCount, ...routing[level] };
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

const options = parseArgs(process.argv.slice(2));
const { config, overridePath } = loadConfig();
const classification = classify(options.task);
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
  fallback: config.fallback,
  localOverride: overridePath,
  projectRoot,
  actualUsage: "unavailable_from_codex_cli"
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
    status: options.launch ? "launching" : "planned",
    reasons: decision.reasons
  });
}

process.stdout.write(`${JSON.stringify(decision, null, 2)}\n`);
if (!options.launch) process.exit(0);

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
