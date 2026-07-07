#!/bin/bash
# PreToolUse hook for Read — blocks reads of sensitive files
# Input: JSON on stdin with tool_input.file_path
if ! command -v jq >/dev/null 2>&1; then
  echo "Warning: jq is not installed; skipping read-hook." >&2
  exit 0
fi
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
# Block patterns (beyond what deny list already covers)
case "$FILE_PATH" in
  */.env*|*/credentials*|*/secret*|*id_rsa*|*id_ed25519*|*.pem|*.key)
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: "Blocked: sensitive file read intercepted by read-hook.sh"
      }
    }'
    exit 0
    ;;
esac
# Allow everything else
exit 0
