#!/bin/bash
# Block yarn/pnpm commands — this repo uses npm.
if ! command -v jq >/dev/null 2>&1; then
  echo "Warning: jq is not installed; skipping enforce-npm hook." >&2
  exit 0
fi
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')
if echo "$COMMAND" | grep -qE '(^|\s|&&|\|)(yarn|pnpm)(\s|$)'; then
  echo "yarn/pnpm not allowed. Use npm instead (e.g. npm install, npm run <script>)." >&2
  exit 2
fi
exit 0
