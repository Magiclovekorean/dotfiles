#!/usr/bin/env bash
set -euo pipefail

repo=$(gh repo list --no-archived --json nameWithOwner --jq '.[].nameWithOwner' | fzf --height 40% --reverse --prompt="Select repo to clone: ")

if [[ -n "$repo" ]]; then
  gh repo clone "$repo"
fi
