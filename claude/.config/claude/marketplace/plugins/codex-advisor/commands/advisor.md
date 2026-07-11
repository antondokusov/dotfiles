---
name: codex-advisor:advisor
description: Ask the Codex-backed advisor for a second opinion on the current session (no Anthropic rate limit).
argument-hint: [focus question]
allowed-tools: Bash(*/bin/codex-advisor*)
---

# Codex Advisor

Get a skeptical senior-engineer review of the current session from Codex, which sees this
session's full transcript. Run the command below with **a generous timeout** (Codex takes
~20–60s). It self-resolves the current transcript — no session id needed.

```bash
~/.config/claude/marketplace/plugins/codex-advisor/bin/codex-advisor "$ARGUMENTS"
```

Then read the advice and act on it: give it serious weight (stronger model, full context), apply
what's sound, and if it conflicts with primary-source evidence you already have, surface the
conflict rather than silently switching. Report the advisor's key points back to me before
proceeding.
