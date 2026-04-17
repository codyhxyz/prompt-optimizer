# prompt-optimizer

> A Claude Code agent that turns vague requests into crystal-clear, actionable prompts before another agent tries to execute them.

Most agent failures trace back to an under-specified prompt: "make the UI better", "fix the bug where things aren't saving", "the search is slow." `prompt-optimizer` sits one step *before* your implementation agent. It reads your request, pulls out the implicit requirements, flags the ambiguities, and hands the executing agent a prompt it can actually succeed on.

It is a prompt-engineering specialist, not a coder — it never writes implementation, only the spec.

## What it does

- **Extracts intent** — separates what you asked for from what you actually want.
- **Makes implicit requirements explicit** — turns "make it better" into testable success criteria.
- **Surfaces failure modes** — calls out ways the request could be misread, with defaults to pick if you don't answer.
- **Preserves your goal** — never adds scope or changes direction; just sharpens the ask.

Output is always the same shape:
1. A short analysis of what's unclear.
2. The optimized prompt, structured (sections / numbered lists).
3. A confidence note if anything still needs you to decide.

## When to invoke it

- You're about to hand a multi-step feature to an implementation agent.
- You've typed a one-liner like "fix the thing" and you know it's thin.
- You're chaining agents and want one clean handoff instead of an ambiguous one.
- You need to split a vague bug report into a diagnostic plan before anyone starts changing code.

Claude Code will auto-trigger the agent from its frontmatter description whenever a request looks vague, or you can call it explicitly:

> "Use the prompt-optimizer agent to clarify this request before we implement it."

## Installation

### From the official marketplace (once approved)

```
/plugin install prompt-optimizer@claude-plugins-official
```

### Direct from this repo

```
/plugin marketplace add codyhxyz/prompt-optimizer
/plugin install prompt-optimizer@prompt-optimizer
```

### Local dev / smoke test

```bash
claude --plugin-dir /path/to/prompt-optimizer
```

## Usage

> "Add a feature to let users share their notes."

> "The search is slow, make it faster."

> "Fix the bug where things aren't saving."

In each case, Claude Code invokes `prompt-optimizer` first. You get back a clarified prompt — with explicit requirements, decision points, and success criteria — ready to pass to whatever agent is actually going to do the work.

## Examples

> **Example 1 — vague feature request.** User prompt: *"Add a feature to let users share their notes."* `prompt-optimizer` returns a structured brief that names the sharing mechanism (share button → unique link), surfaces the open questions (should links expire? view-only vs. edit? do shared notes appear in the sharer's own graph?), calls out the technical pieces (schema change, API endpoint, UI component), lists edge cases (what happens to shares when the source note is deleted), and defines success criteria (one-click share, no-auth recipient flow, respects existing access model) — all before the implementation agent writes a line of code.

> **Example 2 — vague performance complaint.** User prompt: *"The search is slow, make it faster."* `prompt-optimizer` turns it into a diagnostic-first plan: profile the current implementation, measure local vs. API latency, identify the actual bottleneck (is it the Trie traversal, the network call, or the merge?), list concrete optimization strategies with tradeoffs (memoization, debouncing, result caching, virtual scrolling), flag context the executing agent will need (lazy-loaded graph layers, dual search surfaces), and set measurable targets (<200ms local, <500ms combined). The executing agent now has a real plan, not a vibe.

> **Example 3 — vague bug report.** User prompt: *"Fix the bug where things aren't saving."* `prompt-optimizer` breaks it into reproduction-and-scope questions (what's not saving, always or intermittently, which layer), a component checklist (sync queue, API, DB, offline retry, batching), diagnostic steps (console, network tab, server logs, persistence flag), common failure modes (expired auth, race conditions, realtime sync overwriting local), and fix-validation criteria (works across entity types, offline→online retry, no undo/redo regressions). The executing agent walks in with a real investigation plan.

## Why an agent, not a slash command?

Agents live in their own context. The optimizer's system prompt only loads when it's actually invoked, and its output is what comes back to the parent conversation — not the full prompt body. That matters because prompt optimization is something you do repeatedly (every vague ask, every handoff), and inlining the full specialist prompt into the parent context each time eats tokens you want spent on the actual work.

## Contributing

Issues and PRs welcome. If the optimizer misses a failure mode you keep hitting, that's a bug — file it with the before/after prompt.

## License

[MIT](LICENSE) © 2026 Cody Hergenroeder
