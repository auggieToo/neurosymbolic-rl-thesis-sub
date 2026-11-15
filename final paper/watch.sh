#!/usr/bin/env bash

# Author: Augustine Mochoeneng - 16-August-2026
# Rebuilds ../NSRL-thesis.pdf whenever main.typ, a chapter, a figure or references.bib changes.
# Usage: ./watch.sh
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v typst >/dev/null; then
  echo "typst not found. Install: https://github.com/typst/typst#installation" >&2
  exit 1
fi

exec typst watch --root . main.typ ../NSRL-thesis.pdf
