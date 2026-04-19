#!/usr/bin/env bash
set -euo pipefail

# Change to the repo root (where this script lives)
cd "$(dirname "$0")"
REPO_ROOT="$(pwd)"

# Helper: format seconds into a human-readable string
format_time() {
    local total_seconds=$1
    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    if [[ $minutes -gt 0 ]]; then
        printf "%dm %ds" "$minutes" "$seconds"
    else
        printf "%ds" "$seconds"
    fi
}

# Capture total start time
TOTAL_START=$(date +%s)

echo "========================================"
echo "Planning Benchmark — Claude Code Runner"
echo "========================================"
echo ""

# Check prerequisites
if ! command -v claude &>/dev/null; then
    echo "Error: 'claude' CLI not found in PATH."
    echo "Please install Claude Code first: https://claude.ai/code"
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo "Error: 'python3' not found in PATH."
    exit 1
fi

# Ensure results directory exists
mkdir -p "${REPO_ROOT}/results"

# ============================================================================
# STEP 1: Generate the Plan
# ============================================================================
STEP1_START=$(date +%s)

echo "STEP 1: Generating implementation plan..."
echo "  Prompt: Read 1-START_HERE.md and follow its instructions."
echo ""

claude \
    --model kimi-for-coding \
    --dangerously-skip-permissions \
    -p "Read 1-START_HERE.md and follow its instructions."

echo ""

if [[ ! -f "${REPO_ROOT}/results/PLAN.md" ]]; then
    echo "Error: STEP 1 did not produce results/PLAN.md"
    exit 1
fi

STEP1_END=$(date +%s)
STEP1_ELAPSED=$((STEP1_END - STEP1_START))
echo "STEP 1 complete: results/PLAN.md generated ($(format_time "$STEP1_ELAPSED"))."
echo ""

# ============================================================================
# STEP 2: Evaluate the Plan
# ============================================================================
STEP2_START=$(date +%s)

# Ensure evaluator bundle is present
if [[ ! -f "${REPO_ROOT}/evaluator/requirements_catalog_v1.md" ]]; then
    echo "Evaluator bundle missing. Fetching..."
    python3 "${REPO_ROOT}/tools/fetch_evaluator.py"
    echo ""
fi

echo "STEP 2: Evaluating plan..."
echo "  Prompt: Read 2-EVALUATE_PLAN.md and follow its instructions."
echo ""

claude \
    --model kimi-for-coding \
    --dangerously-skip-permissions \
    -p "Read 2-EVALUATE_PLAN.md and follow its instructions."

echo ""

# Verify expected outputs
MISSING=0
for f in "${REPO_ROOT}/results/PLAN_EVAL.md" "${REPO_ROOT}/results/PLAN_EVAL_REPORT.html"; do
    if [[ ! -f "$f" ]]; then
        echo "Error: Expected output not found: $f"
        MISSING=1
    fi
done

if [[ "$MISSING" -eq 1 ]]; then
    exit 1
fi

STEP2_END=$(date +%s)
STEP2_ELAPSED=$((STEP2_END - STEP2_START))
echo "STEP 2 complete: results/PLAN_EVAL.md and results/PLAN_EVAL_REPORT.html generated ($(format_time "$STEP2_ELAPSED"))."
echo ""

# ============================================================================
# Summary
# ============================================================================
TOTAL_END=$(date +%s)
TOTAL_ELAPSED=$((TOTAL_END - TOTAL_START))

echo "========================================"
echo "All steps completed successfully."
echo "========================================"
echo ""
echo "Execution times:"
echo "  STEP 1 (Generate Plan):     $(format_time "$STEP1_ELAPSED")"
echo "  STEP 2 (Evaluate Plan):     $(format_time "$STEP2_ELAPSED")"
echo "  TOTAL:                      $(format_time "$TOTAL_ELAPSED")"
echo ""
echo "Generated artifacts:"
echo "  - results/PLAN.md"
echo "  - results/PLAN_EVAL.md"
echo "  - results/PLAN_EVAL_REPORT.html"
echo ""
