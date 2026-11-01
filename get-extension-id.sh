#!/usr/bin/env bash
# Usage: get-extension-id.sh <addon-url-or-slug>
# Example: get-extension-id.sh https://addons.mozilla.org/en-US/firefox/addon/youtube-recommended-videos/
# Example: get-extension-id.sh youtube-recommended-videos

set -euo pipefail

input="${1:-}"
if [[ -z "$input" ]]; then
    echo "Usage: $0 <addon-url-or-slug>" >&2
    exit 1
fi

# Extract slug from URL or use as-is
if [[ "$input" =~ addons\.mozilla\.org.*/addon/([^/]+) ]]; then
    slug="${BASH_REMATCH[1]}"
else
    slug="$input"
fi

xpi_url="https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi"
tmp_xpi="/tmp/${slug}.xpi"

echo "Fetching: $xpi_url" >&2
curl -sL "$xpi_url" -o "$tmp_xpi"

# Extract extension ID from manifest.json (works without jq)
ext_id=$(unzip -p "$tmp_xpi" manifest.json 2>/dev/null | grep -A2 '"gecko"' | grep '"id"' | sed 's/.*"id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

if [[ -z "$ext_id" || "$ext_id" == "null" ]]; then
    echo "Error: Could not extract extension ID" >&2
    rm -f "$tmp_xpi"
    exit 1
fi

echo "$ext_id"
rm -f "$tmp_xpi"