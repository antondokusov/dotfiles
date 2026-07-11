---
name: codex-advisor
description: >-
  Get a second opinion from a stronger external reviewer (Codex/gpt-5.6-terra) that sees this
  session's full transcript. Use it like the built-in advisor: BEFORE substantive work (before
  writing/editing, before committing to an interpretation or approach), when STUCK (errors recurring,
  approach not converging), when CONSIDERING a change of approach, and when you believe a task is
  COMPLETE. Prefer this over the built-in advisor tool when that is slow or rate-limited — this runs
  locally with no Anthropic rate limit. Triggers: "get a second opinion", "ask the advisor",
  "sanity-check this", "codex advisor", "review my approach".
---

# Codex Advisor

A local stand-in for Claude Code's built-in `advisor` tool. It forwards **this session's full
transcript** to Codex (headless `codex exec`, using your configured `gpt-5.6-terra`) framed as a
skeptical senior engineer, and returns direct, actionable advice. No Anthropic rate limit.

## When to call it

Same discipline as the built-in advisor:
- **Before substantive work** — before writing/editing, before committing to an interpretation or
  building on an assumption. Orientation (reading files, searching) is not substantive work; do that
  first, then call.
- **When stuck** — recurring errors, an approach that isn't converging, results that don't fit.
- **When considering a change of approach.**
- **When you think the task is done** — make the deliverable durable (write/save/commit) *first*,
  then call.

On tasks longer than a few steps, call it at least once before committing to an approach and once
before declaring done. Use judgment: it costs a Codex call (~20–60s and your OpenAI quota), so skip
it for trivial or purely reactive steps where the next action is already dictated by what you just saw.

Note: this sends the session transcript to Codex/OpenAI. Don't use it in sessions handling secrets
you don't want leaving your machine.

## How to call it

Run the script directly (it self-resolves the current transcript from `$CLAUDE_CODE_SESSION_ID` —
no arguments needed). Pass an optional focus question in quotes. Give it a generous timeout, as
Codex takes ~20–60s to respond:

```bash
~/.config/claude/marketplace/plugins/codex-advisor/bin/codex-advisor "Optional focus question about what you're unsure of"
```

Or with no focus question, for a general review:

```bash
~/.config/claude/marketplace/plugins/codex-advisor/bin/codex-advisor
```

The command prints the advice to stdout.

## After you get the advice

Give it serious weight — it comes from a stronger model with full context. Apply what's sound.
But if a step it suggests fails empirically, or you have primary-source evidence contradicting a
specific claim, adapt rather than following blindly. If it points one way and evidence you already
gathered points another, surface the conflict rather than silently switching.

## Tuning (optional)

Environment variables change behavior for a single call, e.g.:
- `CODEX_ADVISOR_EFFORT=high` (or `medium`) — faster, shallower (default `max` = deepest/slowest).
- `CODEX_ADVISOR_MODEL=gpt-5.6` — override the model.
- `CODEX_ADVISOR_TIMEOUT=120` — cap the wait in seconds (default 240).
