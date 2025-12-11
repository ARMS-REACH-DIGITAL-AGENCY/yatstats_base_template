#!/usr/bin/env bash
set -euo pipefail

# Global helper to expose GPT-5.1-Codex-Max (Preview) to all clients
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FEATURE_FLAGS_FILE="${FEATURE_FLAGS_FILE:-${SCRIPT_DIR}/feature-flags.json}"

export FEATURE_FLAGS_FILE
export NEXT_PUBLIC_ENABLE_GPT51_CODEX_MAX_PREVIEW=1
export NEXT_PUBLIC_DEFAULT_CHAT_MODEL="gpt-5.1-codex-max-preview"

create_or_update_flag_file() {
  python3 - <<'PY'
import json
import os
import pathlib

feature_flags_file = os.environ["FEATURE_FLAGS_FILE"]
pathlib.Path(feature_flags_file).parent.mkdir(parents=True, exist_ok=True)
flags = {}
if os.path.exists(feature_flags_file):
    try:
        with open(feature_flags_file, "r", encoding="utf-8") as f:
            flags = json.load(f)
    except json.JSONDecodeError:
        flags = {}
flags["gpt-5.1-codex-max-preview"] = True
with open(feature_flags_file, "w", encoding="utf-8") as f:
    json.dump(flags, f, indent=2)
    f.write("\n")
print(f"Feature flag written to {feature_flags_file}")
PY
}

create_or_update_flag_file

echo "Feature flag enabled. FEATURE_FLAGS_FILE=${FEATURE_FLAGS_FILE}" \
  "NEXT_PUBLIC_ENABLE_GPT51_CODEX_MAX_PREVIEW=${NEXT_PUBLIC_ENABLE_GPT51_CODEX_MAX_PREVIEW}" \
  "NEXT_PUBLIC_DEFAULT_CHAT_MODEL=${NEXT_PUBLIC_DEFAULT_CHAT_MODEL}"
