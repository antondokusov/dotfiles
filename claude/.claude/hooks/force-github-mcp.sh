#!/usr/bin/env bash
# PreToolUse hook: redirect GitHub access away from the `gh` CLI and WebFetch
# toward the github MCP (mcp__github__*), which is always enabled in this setup.
#
# Fires for Bash and WebFetch. Emits a `permissionDecision: "deny"` with a
# human-readable reason that points Claude at the right MCP tool.

set -euo pipefail

input="$(cat)"
tool_name="$(jq -r '.tool_name // ""' <<<"$input")"

deny() {
  jq -nc --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
}

case "$tool_name" in
  Bash)
    cmd="$(jq -r '.tool_input.command // ""' <<<"$input")"
    # Match `gh` as its own token: start of string, after whitespace, or after
    # shell separators (`;`, `&`, `|`, backtick, `(`). Avoids false positives
    # like `enough`, `high`, `github.com`.
    if [[ "$cmd" =~ (^|[[:space:]\;\&\|\`\(])gh([[:space:]]|$) ]]; then
      deny "use github mcp"
    fi
    ;;
  WebFetch)
    url="$(jq -r '.tool_input.url // ""' <<<"$input")"
    if [[ "$url" =~ ^https?://(www\.)?(github\.com|api\.github\.com|raw\.githubusercontent\.com|gist\.github\.com|objects\.githubusercontent\.com)(/|$) ]]; then
      deny "use github mcp"
    fi
    ;;
esac
