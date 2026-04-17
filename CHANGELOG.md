# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] — 2026-04-17

### Changed (breaking output contract)
- Agent now emits three delimited blocks (`<analysis>`, `<optimized_prompt>`, `<decisions_required>`) instead of prose. Parent agents should forward only the contents of `<optimized_prompt>` to the executor.

### Added
- Grounding loop: agent now has `Read`, `Grep`, `Glob` and must verify any named file, function, module, or symbol before citing it, falling back to abstract descriptions with a flagged decision when verification fails.
- Model pinned to `opus` for consistent optimization quality independent of parent context.

### Changed
- Frontmatter `description` slimmed to routing-only triggers (positive + negative). Behavioral specification moved into the system prompt body.
- Canonical examples rewritten to model the verify-before-citing loop rather than fabricating codebase specifics.
- README trimmed to point at the agent file for behavioral details instead of restating them.

## [0.1.0] — 2026-04-17

### Added
- Initial release.
- `prompt-optimizer` agent that transforms vague requests into structured, actionable prompts (analysis → optimized prompt → confidence note) before delegating to executing agents.
