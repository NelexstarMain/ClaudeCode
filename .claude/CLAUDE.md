# Global Claude Code Instructions

@~/.claude/preferences.md

## Communication & Language Contract
- Always respond to the user in **Polish**.
- Write all source code, identifiers, comments, `CLAUDE.md`, `.claude/handoff.md`, and git commit messages in **English**.

## Core Operating Principles
- Follow all rules in `~/.claude/rules/` without exception.
- Use `core-*` skills for workflow control (`core-kickoff`, `core-tests`, `core-subagents`, `core-memory`, `core-hygiene`, `core-wrapup`).
- Load domain references (e.g., `~/.claude/skills/csharp/references/*.md`) **on demand only** when the task requires that specialization.
- Never modify global `~/.claude/skills/` when configuring a specific project; place project adaptations in the repository's `./CLAUDE.md` and `./.claude/`.
