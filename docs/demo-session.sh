#!/usr/bin/env bash
# Deterministic simulated session for the prompt-optimizer hero GIF.
# Driven by docs/demo.tape via `vhs docs/demo.tape`.

set -e

CYAN=$'\033[36m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

slow_print() {
  local text="$1"
  local delay="${2:-0.025}"
  for (( i=0; i<${#text}; i++ )); do
    printf "%s" "${text:$i:1}"
    sleep "$delay"
  done
  echo
}

printf "%s" "${DIM}user prompt:${RESET} "
slow_print "The search is slow, make it faster."
sleep 0.6

echo
printf "%s\n" "${CYAN}[prompt-optimizer] grounding against codebase…${RESET}"
sleep 1.2

cat <<EOF

${BOLD}<analysis>${RESET}
"Slow" is unmeasured and "search" is unscoped. Grounding scan located a client search
module and a /search API route. Framing the brief as diagnostic-first so the executor
measures before optimizing.
${BOLD}</analysis>${RESET}

${BOLD}<optimized_prompt>${RESET}
Investigate and improve search latency. Do diagnostics before optimization.

1. Diagnostics
   - Profile the current search path(s); measure local, server, and merged independently.
   - Identify the dominant source of latency.
   - Reproduce on representative data sizes; confirm not a cold-cache artifact.

2. Candidate strategies (evaluate only after diagnostics point at a bottleneck)
   - Debouncing user input.
   - Caching or memoizing recent queries.
   - Optimizing quadratic merge / filter passes.
   - Virtualizing long result lists.

3. Success criteria
   - A measured, repeatable latency improvement on a representative query set.
   - No regression in result quality or correctness.
   - Improvement scales with dataset size.
${BOLD}</optimized_prompt>${RESET}

${BOLD}<decisions_required>${RESET}
- Target latency: default = cut median latency in half on current workload.
- Scope: local-only, API-only, or both? Default = both; optimize whichever dominates.
- Confirm canonical search-implementation paths.
${BOLD}</decisions_required>${RESET}
EOF

sleep 3
