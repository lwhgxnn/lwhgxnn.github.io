#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PORT="${1:-4000}"
CONFIG="_config.yml,_config_local.yml"

# JEKYLL_ENV must not be "development": in that mode `jekyll serve` overwrites
# site.url with http://<host>:<port>, which turns into http://0.0.0.0:4000 and
# breaks every stylesheet link in the browser. Any other value keeps the empty
# url from _config_local.yml, so assets stay relative.
#
# --force_polling is required when the repository lives on a Windows drive
# (/mnt/d/... under WSL): inotify does not fire there, so auto-regeneration
# silently never happens without it.
export JEKYLL_ENV="${JEKYLL_ENV:-local}"

echo "Starting local Jekyll preview on http://localhost:${PORT}"

if command -v docker >/dev/null 2>&1; then
  if [ "$PORT" != "4000" ]; then
    echo "Docker Compose is configured for port 4000. Use local Ruby for a custom port."
  fi
  docker compose up --build
elif command -v bundle >/dev/null 2>&1 && bundle check >/dev/null 2>&1; then
  bundle exec jekyll serve -w --force_polling -H 0.0.0.0 -P "$PORT" --config "$CONFIG"
elif command -v jekyll >/dev/null 2>&1; then
  # System-wide Jekyll without a complete bundle: skip the Bundler check so the
  # installed gems are used directly.
  echo "Bundler gems are incomplete; using the system Jekyll installation."
  JEKYLL_NO_BUNDLER_REQUIRE=true jekyll serve -w --force_polling -H 0.0.0.0 -P "$PORT" --config "$CONFIG"
else
  cat >&2 <<'EOF'
No local preview runtime was found.

Install one of these:
1. Docker Desktop, then run: ./run_server.sh
2. Ruby + Bundler, then run: gem install bundler; bundle install; ./run_server.sh

On Ubuntu/WSL a working Ruby setup needs the development headers:
  sudo apt install -y ruby-full ruby-dev build-essential zlib1g-dev
EOF
  exit 1
fi
