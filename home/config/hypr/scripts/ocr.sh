#!/usr/bin/env bash
 
grim -g "$(slurp)" - | tesseract stdin stdout -l eng | wl-copy && notify-send "OCR" "Text copied to clipboard"
