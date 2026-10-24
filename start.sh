#!/bin/sh
set -eu
cd "$(dirname "$0")"
if [ ! -x .venv/bin/reaction-lens ]; then
  echo 'Run: uv sync --locked --extra encoder --extra serve --extra dev' >&2
  exit 1
fi
exec .venv/bin/reaction-lens serve \
  --bundle .local/artifacts/structured-seed23 \
  --encoder-dir .local/artifacts/encoder \
  --device cpu --threads 2 --host 127.0.0.1 --port "${PORT:-8767}"
