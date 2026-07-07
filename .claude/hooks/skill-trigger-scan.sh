#!/usr/bin/env bash
# UserPromptSubmit hook. Scans incoming prompt for recurrence / reflection /
# truth-check signals and names the matching skill(s) in additional context.
# Silent when nothing matches.
set -euo pipefail
payload="$(cat)"
prompt="$(printf '%s' "$payload" | jq -r '.prompt // empty')"
[[ -z "$prompt" ]] && exit 0
hits=()
match() {
  printf '%s' "$prompt" | grep -qiE "$1"
}
if match 'keep happening|keeps coming back|keeps failing|same.*(error|bug|issue|thing).*(back|again)|across sessions|we fixed this|regress|recurring'; then
  hits+=("architecture-vs-config — recurrence signal. Consult before tuning prompt.")
fi
if match 'step back|what did we miss|what are we missing|zoom out|reflect on|something.*(off|weird)|we.?ve seen this|pattern here'; then
  hits+=("gorilla-scan — reflection signal. Scan for hidden assumptions and recurring patterns.")
fi
if match 'is that true|are you sure|verify this|double.?check|fact.?check|what.?s your source|prove it|citation'; then
  hits+=("truth-gate — truth-check signal. Switch to strict-verify mode before emitting claims.")
fi
if match '\b(hstf|prsf|tetf|tegf|ktsf|hstp|tetp|husf|prsg|prsp|ispf|pgmf|gemf|gemfb|ilf)[0-9]{3,5}\b|\bmigrate\b|\bport (this|the|to)\b|\bconvert (this|the|to)\b|\bmulti.?org|\benable.*organi[sz]ation|\bo_kod\b'; then
  hits+=("discover-form — form-migration signal. Run /discover-form <FORM_ID> for 6-Layer Translation Stack before proposing a plan.")
  hits+=("vault-lookup — read in order: ~/vault/graphify/INDEX.md → ~/vault/graphify/STATE.json → matching slice's evidence boundary note → ~/vault/permanent/legacy-forms-primitives.md → ~/vault/permanent/migration-invariants-nss-pony.md → if multi-org also ~/vault/permanent/multi-org-filter-rule.md.")
  hits+=("graphify-explain — if STATE.json names a slice covering the form, run: graphify explain '<FORM_ID>' --graph <slice-staging>/graphify-out/graph.json before reading XML directly.")
fi
[[ ${#hits[@]} -eq 0 ]] && exit 0
echo "[skill-trigger-scan] Prompt matched trigger patterns. Consider invoking:"
printf ' - %s\n' "${hits[@]}"
echo "Scan the available-skills list and invoke the relevant skill before responding."
