# Personal LLM Benchmark

> **Measuring how well coding agents plan against a real-world product specification.**

This repository contains a standardized benchmark for evaluating the planning capabilities of LLM-based coding agents. Instead of measuring code generation speed or test-pass rates, this benchmark answers a different question: *When given a complex, multi-document product spec, how well can an agent produce a comprehensive implementation plan?*

---

## Leaderboard

### Leaderboard (Ordered by Overall Score)

| Rank | Agent / Tool | Model | Overall | Critical | Important | Detail | Req. Total |
|:---:|:---|:---|:---:|:---:|:---:|:---:|:---:|
| 🥇 | **Kimi CLI** | [Qwen3.6-35B](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Kimi_CLI_@_Qwen3.6-35B/PLAN_EVAL_REPORT.html) | **93.9%** | 96.7% | 92.5% | 100.0% | 99 |
| 🥈 | **Kimi CLI** | [Kimi K2.6 preview](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Kimi_CLI_@_Kimi_K2.6_preview/PLAN_EVAL_REPORT.html) | **92.4%** | 100.0% | 88.8% | 100.0% | 99 |
| 🥉 | **Claude Code** | [Kimi K2.6 preview](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Claude_Code_@_Kimi_K2.6_preview/PLAN_EVAL_REPORT.html) | **91.4%** | 96.7% | 89.6% | 75.0% | 99 |
| 4 | **Claude Code** | [Opus 4.6 (high)](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Claude_Code_@_Opus_4.6_high/PLAN_EVAL_REPORT.html) | **89.7%** | 93.3% | 87.1% | 87.5% | 73 |
| 5 | **Kimi CLI** | [GLM-5.1](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Kimi_CLI_@_GLM-5.1/PLAN_EVAL_REPORT.html) | **88.4%** | 98.3% | 85.1% | 100.0% | 99 |
| 6 | **Codex CLI** | GPT 5.3 Codex (xhigh) | **88.5%** | 91.9% | 88.1% | 75.0% | 87 |
| 7 | **Kimi CLI** | [Qwen3.5-35B-uncensored](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Kimi_CLI_@_Qwen3.5-35B-uncensored/PLAN_EVAL_REPORT.html) | **85.4%** | 96.7% | 80.6% | 75.0% | 99 |
| 8 | **Claude Code** | Opus 4.5 | **82.9%** | 85.0% | 82.9% | 77.8% | 70 |
| 9 | **Claude Code** | [Sonnet 4.6 (high)](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Claude_Code_@_Sonnet_4.6_high/PLAN_EVAL_REPORT.html) | **75.6%** | 82.1% | 71.9% | 75.0% | 78 |
| 10 | **Claude Code** | Sonnet 4.5 | **66.5%** | 74.4% | 60.6% | 62.5% | 94 |
| 11 | **Gemini CLI** (no plan mode) | [Gemini 3.2 Pro](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Gemini_CLI_no_plan_@_Gemini_3.2_Pro/PLAN_EVAL_REPORT.html) | **49.4%** | 69.1% | 40.5% | 7.1% | 83 |
| 12 | **Antigravity** | [Gemini 3.2 Pro](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Antigravity_@_Gemini_3.2_Pro/PLAN_EVAL_REPORT.html) | **47.5%** | 63.3% | 42.5% | 20.0% | 80 |
| 13 | **Cursor** | [Gemini 3.2 Pro](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Cursor_@_Gemini_3.2_Pro/PLAN_EVAL_REPORT.html) | **42.1%** | 54.2% | 39.1% | 16.7% | 38 |
| 14 | **Gemini CLI** | [Gemini 3.2 Pro](https://htmlpreview.github.io/?https://github.com/mark-sch/Personal-LLM-benchmark/blob/main/results/Gemini_CLI_@_Gemini_3.2_Pro/PLAN_EVAL_REPORT.html) | **36.5%** | 42.0% | 35.7% | 0.0% | 63 |

> **Note:** Requirement totals vary slightly across runs because some evaluators extracted or consolidated requirements differently. The frozen canonical catalog is the authoritative denominator, but agents may produce plans of varying scope that influence how evaluators count. For a fair comparison, focus on the **Overall** score, which is always normalized against the run's own denominator.

---

## The Concept

Most coding benchmarks focus on **implementation** — can the agent write code that compiles and passes tests? This benchmark focuses on **planning** — can the agent read, understand, and synthesize a complex Product Requirements Document (PRD) into a coherent, complete implementation plan?

The benchmark uses a real, non-trivial product spec (a media-discovery application with AI chat, voice interaction, collections, search, and export features) spread across multiple interdependent documents. The spec is rich enough that a surface-level read will miss critical constraints and relationships.

### Scoring Philosophy

Planning quality is scored against a **frozen canonical requirement catalog** (`evaluator/requirements_catalog_v1.md`) that contains approximately 80–100 requirements across 10 functional areas, each tagged by severity:

- **Critical** — Must be addressed for the product to function
- **Important** — Required for a complete, polished product
- **Detail** — Fine-grained behaviors, edge cases, and polish

Coverage is scored with a weighted formula:

```
score = (full_count × 1.0 + partial_count × 0.5) / total_count × 100
```

An honest evaluator audits the plan requirement-by-requirement. No partial credit for hand-waving.

---

## Repository Structure

```
.
├── docs/prd/                          # The product specification
│   ├── product_prd.md                 # Core product requirements
│   ├── infra_rider_prd.md             # Infrastructure & build constraints
│   └── supporting_docs/               # Technical schemas, AI prompting, UX details
├── evaluator/
│   └── requirements_catalog_v1.md     # Frozen scoring denominator
├── tools/
│   └── fetch_evaluator.py             # Downloads/updates the evaluator bundle
├── results/                           # Benchmark outputs (see below)
├── 1-START_HERE.md                    # Step 1 prompt: generate a plan
├── 2-EVALUATE_PLAN.md                 # Step 2 prompt: evaluate the plan
├── 3-PLAN_EVAL_REPORT.md              # Optional fallback: re-render HTML report
├── runClaude.sh                       # Automated runner for Claude Code
├── runKimi.sh                         # Automated runner for Kimi CLI
├── INSTRUCTIONS.md                    # Development guidelines & architecture patterns
└── AGENTS.md / CLAUDE.md / GEMINI.md  # Agent-specific auto-loaded instructions
```

---

## Benchmark Results

All completed benchmark runs are stored in the [`results/`](results/) folder, organized by agent/tool and model. Each run produces:

- `PLAN.md` — The implementation plan generated by the agent
- `PLAN_EVAL.md` — The human-readable coverage evaluation
- `PLAN_EVAL_REPORT.html` — A stakeholder-ready visual report

### Key Observations

- **Kimi K2.6 preview dominates planning quality.** Both Kimi CLI and Claude Code using this model achieved >91% overall coverage, with Kimi CLI hitting a perfect 100% on critical requirements.
- **Claude Opus 4.6 (high)** is competitive at ~90%, showing strong performance on the latest Anthropic flagship.
- **Claude Sonnet** models show a clear gap versus Opus, with Sonnet 4.5 trailing significantly at 66.5%.
- **Gemini 3.2 Pro** consistently underperforms on this benchmark, with even the best Gemini-based run (Antigravity) only reaching 47.5%. Detail coverage is particularly weak across all Gemini runs.
- **Tool choice matters.** The same model (Gemini 3.2 Pro) scores very differently depending on whether it runs through Cursor, Gemini CLI, or Antigravity, suggesting that prompting strategy and context management are as important as raw model capability.

---

## Running the Benchmark

### Automated Runners

Two bash scripts are provided for fully automated benchmark execution against specific CLI tools:

#### `runClaude.sh` — Claude Code Runner

Prerequisites: [`claude`](https://claude.ai/code) CLI installed and in your `PATH`.

```bash
./runClaude.sh
```

This script will:
1. Check prerequisites (`claude`, `python3`).
2. **Step 1:** Launch Claude Code with the prompt `Read 1-START_HERE.md and follow its instructions.` to generate `results/PLAN.md`.
3. Verify `results/PLAN.md` was produced.
4. Fetch the evaluator bundle if missing (`python3 tools/fetch_evaluator.py`).
5. **Step 2:** Launch a fresh Claude Code session with the prompt `Read 2-EVALUATE_PLAN.md and follow its instructions.` to generate `results/PLAN_EVAL.md` and `results/PLAN_EVAL_REPORT.html`.
6. Print execution timing for both steps.

#### `runKimi.sh` — Kimi CLI Runner

Prerequisites: [`kimi`](https://moonshotai.github.io/kimi-cli/) CLI installed and in your `PATH`.

```bash
./runKimi.sh
```

This script follows the same two-step workflow as `runClaude.sh`, but uses the Kimi CLI with `--print --yolo --work-dir` flags for non-interactive execution.

Both scripts:
- Run each step in isolation (fresh context), matching the manual workflow.
- Time each step and report total elapsed time.
- Exit with an error if expected output files are missing.

### Manual Workflow (Step by Step)

If you prefer to run the benchmark manually, or if you are using an agent/tool not covered by the bash scripts, follow these steps exactly. **Each step must be run in a fresh conversation/context** to maximize available context window and isolate steps for re-runnability.

#### Step 1: Generate the Plan

Open a fresh conversation with your coding agent and say:

> Read `1-START_HERE.md` and follow its instructions.

The agent will:
1. Read the full PRD in `docs/prd/` (starting with `product_prd.md`, then `infra_rider_prd.md`, then all supporting documents recursively).
2. Synthesize a comprehensive implementation plan.
3. Write it to `results/PLAN.md`.

**Important:** This is planning only. The agent must not start implementing code.

**Output:** `results/PLAN.md`

#### Step 2: Evaluate the Plan

Open a **new conversation** (fresh context) and say:

> Read `2-EVALUATE_PLAN.md` and follow its instructions.

The agent will:
1. Read the frozen requirement catalog at `evaluator/requirements_catalog_v1.md`.
2. Read the PRD files for semantic context.
3. Read the plan from `results/PLAN.md`.
4. Audit every requirement for coverage (`full`, `partial`, or `missing`).
5. Write the evaluation to `results/PLAN_EVAL.md`.
6. Generate a stakeholder-ready HTML report at `results/PLAN_EVAL_REPORT.html`.

If `evaluator/requirements_catalog_v1.md` is missing, run `python3 tools/fetch_evaluator.py` first.

**Requires:** `results/PLAN.md` from Step 1  
**Outputs:** `results/PLAN_EVAL.md`, `results/PLAN_EVAL_REPORT.html`

#### Optional Step 3: Re-render the Report

If `results/PLAN_EVAL.md` already exists and you only need to regenerate the HTML report (e.g., after a styling tweak), open a fresh conversation and say:

> Read `3-PLAN_EVAL_REPORT.md` and follow its instructions.

**Requires:** `results/PLAN_EVAL.md`  
**Output:** `results/PLAN_EVAL_REPORT.html`

---

## Why Fresh Conversations?

Each step consumes a significant portion of the agent's context window. Starting fresh ensures:

- Maximum tokens available for the task at hand.
- Isolation between steps — you can re-run evaluation without regenerating the plan.
- Cleaner reasoning — the evaluator should not be primed by the plan generation process.

---

## Development Guidelines

When the benchmark PRD asks an agent to plan or reason about code architecture, the following patterns are expected (defined in `INSTRUCTIONS.md`):

- **Fractal Architecture:** Pages → Features → Sub-Features, each self-contained.
- **Humble Components:** TSX files contain markup only; logic lives in custom hooks.
- **No Magic Numbers:** All constants and styling tokens extracted to config/theme.
- **Co-location:** Feature-specific code lives inside the feature's directory.

These standards are part of what the agent must account for when planning.

---

## Contributing a New Run

To add a new benchmark run:

1. Create a new folder under `results/` with a descriptive name: `{Tool}_@_{Model}[_{variant}]/`.
2. Run the benchmark using either the automated scripts or the manual workflow.
3. Ensure all four artifacts are present:
   - `PLAN.md`
   - `PLAN_EVAL.md`
   - `PLAN_EVAL_REPORT.html`
   - `run_metadata.json` (if using the control workflow)
4. Update this README with the new scores in the leaderboard table.

---

## License

This benchmark is provided for research and comparison purposes. The PRD documents and requirement catalog represent a realistic product specification used strictly for evaluating agent planning capabilities.
