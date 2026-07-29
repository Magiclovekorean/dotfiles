#!/usr/bin/env bash

TMP_IMG="/tmp/math-ocr.png"
PIX2TEX="$HOME/.local/bin/pix2tex"

# Check if pix2tex exists
if [[ ! -x "$PIX2TEX" ]]; then
    notify-send "Math OCR" "pix2tex not found at $PIX2TEX"
    exit 1
fi

# Select region
grim -g "$(slurp)" "$TMP_IMG" || exit 1

# Run OCR and copy LaTeX
"$PIX2TEX" "$TMP_IMG" | wl-copy

notify-send "Math OCR" "LaTeX formula copied to clipboard"

rm -f "$TMP_IMG"
