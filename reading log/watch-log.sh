#!/usr/bin/env bash
#Author: Augustine Mochoeneng
# Rebuild papers-logs.pdf every time reading-log.typ or references.bib changes.

set -euo pipefail
cd "$(dirname "$0")"

if ! command -v typst >/dev/null; then
  echo "typst not found. Install: https://github.com/typst/typst#installation" >&2
  exit 1
fi

exec typst watch reading-log.typ papers-logs.pdf
