# prompt-optimizer

> A Claude Code agent that turns vague requests into crystal-clear, actionable prompts before another agent tries to execute them.

Most agent failures trace back to an under-specified prompt: "make the UI better", "fix the bug where things aren't saving", "the search is slow." `prompt-optimizer` sits one step *before* your implementation agent. It reads the request, grounds its specifics against the codebase with read-only tools, surfaces the ambiguities, and hands the executing agent a prompt it can actually succeed on.

It is a prompt-engineering specialist, not a coder — it writes the spec and never the implementation.

See [`agents/prompt-optimizer.md`](agents/prompt-optimizer.md) for the full behavioral spec.

## Output contract

The agent always emits three delimited blocks, in this order:

```
<analysis>...</analysis>
<optimized_prompt>...</optimized_prompt>
<decisions_required>...</decisions_required>
```

The parent agent should forward **only** the contents of `<optimized_prompt>` to the executing agent. `<analysis>` explains what was unclear and what was verified; `<decisions_required>` lists ambiguities the user should resolve before execution, each with a suggested default.

## Grounding

The agent is granted `Read`, `Grep`, and `Glob` — strictly read-only. Before naming any file, function, module, class, endpoint, or schema field in the optimized prompt, it verifies the specific exists. When verification fails or is infeasible, the prompt describes the component abstractly and logs a verification request in `<decisions_required>`. This prevents the highest-leverage failure mode for a prompt optimizer: confidently-wrong specs that the executor then follows into fiction.

## When to invoke it

- You're about to hand a multi-step feature to an implementation agent.
- You've typed a one-liner like "fix the thing" and you know it's thin.
- You're chaining agents and want one clean handoff instead of an ambiguous one.
- You need to split a vague bug report into a diagnostic plan before anyone starts changing code.

Claude Code auto-triggers the agent from its frontmatter description when a request looks vague, or you can call it explicitly:

> "Use the prompt-optimizer agent to clarify this request before we implement it."

Skip it for direct questions, in-scope edits ("rename `foo` to `bar` in `user.ts`"), or conversational back-and-forth.

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

This agent pins `model: opus` so optimization quality stays consistent even when the parent session is running a smaller model.

## Why an agent, not a slash command?

Agents live in their own context. The optimizer's system prompt only loads when it's actually invoked, and only its delimited output comes back to the parent conversation — not the full system prompt body. That matters because prompt optimization is something you do repeatedly (every vague ask, every handoff), and inlining a specialist system prompt into the parent context each time eats tokens you want spent on the actual work.

## Contributing

Issues and PRs welcome. If the optimizer misses a failure mode you keep hitting — or worse, fabricates a codebase specific — that's a bug. File it with the before/after prompt and the grounding trace.

## License

[MIT](LICENSE) © 2026 Cody Hergenroeder
