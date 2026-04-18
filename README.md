<h1 align="center">prompt-optimizer</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href=".claude-plugin/plugin.json"><img src="https://img.shields.io/github/package-json/v/codyhxyz/prompt-optimizer?filename=.claude-plugin%2Fplugin.json&label=version" alt="Version"></a>
  <a href="https://claude.com/product/claude-code"><img src="https://img.shields.io/badge/built_for-Claude%20Code-d97706" alt="Built for Claude Code"></a>
</p>

<p align="center"><b>Vague ask in. Grounded spec out.</b></p>
<p align="center"><i>For when you can't be bothered to write a full prompt.</i></p>

<p align="center">
  <img src="docs/hero.gif" alt="prompt-optimizer in action — vague ask in, grounded spec out" width="900">
</p>

A Claude Code agent that takes a sloppy task request and hands your executor a spec it can actually run with. Prompt-only. It writes the brief, it doesn't touch the code.

I built it mostly because Opus 4.7 punishes vague prompts hard. You hand it half an idea and it re-reads three files, hedges its way through four assumptions, and over-scopes the thing before it even starts. Tightening the ask upfront gets you better output and a smaller bill. I run this constantly.

Full behavioral spec lives in [`agents/prompt-optimizer.md`](agents/prompt-optimizer.md) if you want to see the machinery.

## Quick start

### Option 1: the codyhxyz-plugins marketplace (recommended)

One add, every plugin I ship:

```
/plugin marketplace add codyhxyz/codyhxyz-plugins
/plugin install prompt-optimizer@codyhxyz-plugins
```

### Option 2: straight from this repo

```
/plugin marketplace add codyhxyz/prompt-optimizer
/plugin install prompt-optimizer@prompt-optimizer
```

### Option 3: local smoke test

```bash
claude --plugin-dir /path/to/prompt-optimizer
```

After install, Claude Code auto-routes vague requests to the agent, so you don't have to remember to call it. You can also invoke it explicitly:

> Use the prompt-optimizer agent to clarify this before we implement it.

Don't bother for direct questions, obviously in-scope edits like "rename `foo` to `bar` in `user.ts`", or normal back-and-forth.

## Try it. Paste any of these:

> Add a feature to let users share their notes.

> The search is slow, make it faster.

> Fix the bug where things aren't saving.

You get back a structured brief (requirements, open decisions, success criteria) before anyone touches the code.

## Why bother

It verifies what it names. Before putting a file, function, module, or schema field into the spec, the agent actually runs `Read` / `Grep` / `Glob` against your codebase. It won't invent `GraphStore.searchIndex` and send your executor chasing a function that doesn't exist, which is the failure mode I see most often with off-the-cuff prompt templates.

It keeps your goal intact. The ask gets sharper. Nothing new sneaks in, and nothing pivots direction.

It returns ambiguity, doesn't guess at it. Open questions land in a `<decisions_required>` block with a suggested default for each one, so you can nod them through or push back.

It runs in its own context window. Repeated optimizations don't eat tokens you wanted spent on real work, and it pins `model: opus` so quality holds even when your parent session is on a cheaper model.

On Opus 4.7 specifically, a grounded spec upfront meaningfully cuts how much the executor over-thinks. That's the whole pitch.

## How it works

The agent always emits three delimited blocks, in this order:

```
<analysis>           — what was unclear, what was verified, what was assumed
<optimized_prompt>   — the self-contained brief the executor acts on
<decisions_required> — unresolved ambiguities, each with a suggested default
```

The parent agent forwards only `<optimized_prompt>` to the executor. `<analysis>` and `<decisions_required>` are for you to read.

### Grounding, and why this isn't template-filling

Before the agent names a file, function, module, class, endpoint, or schema field in the optimized prompt, it verifies the thing exists. When verification fails or isn't feasible, the prompt describes the component abstractly and logs a verification request in `<decisions_required>`. This is the whole reason I built it this way: confidently-wrong specs are the worst thing a prompt optimizer can do, because your executor will follow them.

## Examples

<details>
<summary><b>Vague feature request</b> — "Add a feature to let users share their notes."</summary>

<br>

You get back a brief that pins down the sharing mechanism (share button that mints a unique link), asks the questions someone has to answer (do links expire? view-only or edit? do shared notes show up in the sharer's own graph?), lists the technical pieces that need to change (schema, endpoint, UI), flags edge cases like what happens to shares when the source note is deleted, and defines what "done" looks like: one-click share, no-auth recipient flow, respects the existing access model. The executor gets this before it starts.

</details>

<details>
<summary><b>Vague performance complaint</b> — "The search is slow, make it faster."</summary>

<br>

You get a diagnostic-first plan instead of a guess. Profile first. Measure local vs. API latency. Figure out whether the actual bottleneck is the Trie traversal, the network call, or the merge step. Then a list of optimization strategies with tradeoffs (memoization, debouncing, caching results, virtual scrolling), context the executor will need about how the graph layers lazy-load and where the two search surfaces live, and measurable targets: under 200ms local, under 500ms combined.

</details>

<details>
<summary><b>Vague bug report</b> — "Fix the bug where things aren't saving."</summary>

<br>

It breaks this into scope questions (what isn't saving, always or intermittently, which layer), a component checklist (sync queue, API, DB, offline retry, batching), diagnostic steps worth running before assuming anything (console, network tab, server logs, persistence flag), known failure modes it's seen cause this kind of thing (expired auth, race conditions, realtime sync clobbering local state), and validation criteria for calling the fix done. Your executor walks in with an investigation, not a shot in the dark.

</details>

## Contributing

Issues and PRs welcome. If the optimizer misses a failure mode you keep hitting, or worse, fabricates something about your codebase, that's a bug. File it with the before/after prompt and the grounding trace.

## License

[MIT](LICENSE) © 2026 Cody Hergenroeder
