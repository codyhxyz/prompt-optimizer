<h1 align="center">prompt-optimizer</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href=".claude-plugin/plugin.json"><img src="https://img.shields.io/github/package-json/v/codyhxyz/prompt-optimizer?filename=.claude-plugin%2Fplugin.json&label=version" alt="Version"></a>
  <a href="https://claude.com/product/claude-code"><img src="https://img.shields.io/badge/built_for-Claude%20Code-d97706" alt="Built for Claude Code"></a>
</p>

<p align="center"><b>Vague ask in. Grounded spec out. Built for agent handoff.</b></p>
<p align="center"><i>For when you can't be bothered to write a full prompt — it thinks through the implications for you.</i></p>

<p align="center">
  <img src="docs/hero.gif" alt="prompt-optimizer in action — vague ask in, grounded spec out" width="900">
</p>

A Claude Code agent that turns vague task requests into grounded, structured specs *before* your implementation agent tries to execute them. Prompt-only — it writes the spec, never the implementation.

Especially valuable with Opus 4.7: vague prompts cause it to balloon token usage and produce worse output (re-reading files, hedging with assumptions, over-scoping the implementation). Optimizing upfront pays for itself in cost *and* quality — I use it constantly and it noticeably boosts what the executor ships.

Full behavioral spec in [`agents/prompt-optimizer.md`](agents/prompt-optimizer.md).

## Quick Start

### Option 1 — install from the codyhxyz-plugins marketplace *(recommended)*

One add, every plugin I ship:

```
/plugin marketplace add codyhxyz/claude-plugins
/plugin install prompt-optimizer@codyhxyz-plugins
```

### Option 2 — install directly from this repo

```
/plugin marketplace add codyhxyz/prompt-optimizer
/plugin install prompt-optimizer@prompt-optimizer
```

### Option 3 — local smoke test

```bash
claude --plugin-dir /path/to/prompt-optimizer
```

Once installed, Claude Code auto-routes vague requests to the agent — you don't have to remember to invoke it. You can also call it explicitly:

> Use the prompt-optimizer agent to clarify this before we implement it.

Skip it for direct questions, in-scope edits ("rename `foo` to `bar` in `user.ts`"), or conversational back-and-forth.

## Try it — paste any of these

> Add a feature to let users share their notes.

> The search is slow, make it faster.

> Fix the bug where things aren't saving.

In each case you get back a structured brief — requirements, open decisions, success criteria — before anyone writes a line of code.

## Why prompt-optimizer?

- **Grounded, not hallucinated** — verifies files, functions, and symbols with `Read` / `Grep` / `Glob` before citing them. Won't invent `GraphStore.searchIndex` and send your executor chasing fiction.
- **Preserves your goal** — sharpens the ask; never adds scope or changes direction.
- **Surfaces decisions, doesn't guess** — ambiguities come back as a `<decisions_required>` block with suggested defaults.
- **Agent-native** — lives in its own context window; repeated optimizations don't eat the tokens you want spent on real work. Pins `model: opus` so quality stays consistent even when the parent session is running a smaller model.
- **Pays for itself on Opus 4.7** — vague prompts make Opus 4.7 over-explore and over-produce; a grounded spec upfront cuts token spend *and* improves the executor's output.

## How it works

The agent always emits three delimited blocks, in this order:

```
<analysis>           — what was unclear, what was verified, what was assumed
<optimized_prompt>   — the self-contained brief the executor acts on
<decisions_required> — unresolved ambiguities, each with a suggested default
```

The parent agent forwards only `<optimized_prompt>` to the executor. `<analysis>` and `<decisions_required>` are for you.

### Grounding — why this isn't just template-filling

Before naming any file, function, module, class, endpoint, or schema field in the optimized prompt, the agent verifies the specific exists. When verification fails or is infeasible, the prompt describes the component abstractly and logs a verification request in `<decisions_required>`. This prevents the highest-leverage failure mode for a prompt optimizer: confidently-wrong specs that the executor follows into fiction.

## Examples

<details>
<summary><b>Vague feature request</b> — "Add a feature to let users share their notes."</summary>

<br>

`prompt-optimizer` returns a structured brief that names the sharing mechanism (share button → unique link), surfaces the open questions (should links expire? view-only vs. edit? do shared notes appear in the sharer's own graph?), calls out the technical pieces (schema change, API endpoint, UI component), lists edge cases (what happens to shares when the source note is deleted), and defines success criteria (one-click share, no-auth recipient flow, respects existing access model) — all before the implementation agent writes a line of code.

</details>

<details>
<summary><b>Vague performance complaint</b> — "The search is slow, make it faster."</summary>

<br>

`prompt-optimizer` turns it into a diagnostic-first plan: profile the current implementation, measure local vs. API latency, identify the actual bottleneck (is it the Trie traversal, the network call, or the merge?), list concrete optimization strategies with tradeoffs (memoization, debouncing, result caching, virtual scrolling), flag context the executing agent will need (lazy-loaded graph layers, dual search surfaces), and set measurable targets (<200ms local, <500ms combined). The executing agent now has a real plan, not a vibe.

</details>

<details>
<summary><b>Vague bug report</b> — "Fix the bug where things aren't saving."</summary>

<br>

`prompt-optimizer` breaks it into reproduction-and-scope questions (what's not saving, always or intermittently, which layer), a component checklist (sync queue, API, DB, offline retry, batching), diagnostic steps (console, network tab, server logs, persistence flag), common failure modes (expired auth, race conditions, realtime sync overwriting local), and fix-validation criteria (works across entity types, offline→online retry, no undo/redo regressions). The executing agent walks in with a real investigation plan.

</details>

## Contributing

Issues and PRs welcome. If the optimizer misses a failure mode you keep hitting — or worse, fabricates a codebase specific — that's a bug. File it with the before/after prompt and the grounding trace.

## License

[MIT](LICENSE) © 2026 Cody Hergenroeder
