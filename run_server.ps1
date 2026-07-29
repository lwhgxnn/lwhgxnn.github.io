param(
  [int]$Port = 4000
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

function Test-Command($Name) {
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

Write-Host "Starting local Jekyll preview on http://localhost:$Port"

# JEKYLL_ENV must not be "development": in that mode `jekyll serve` overwrites
# site.url with http://<host>:<port>, which breaks the stylesheet links when the
# site is reached under any other address. Any other value keeps the empty url
# from _config_local.yml, so assets stay relative.
if (-not $env:JEKYLL_ENV) { $env:JEKYLL_ENV = "local" }
$config = "_config.yml,_config_local.yml"

if (Test-Command "docker") {
  if ($Port -ne 4000) {
    Write-Host "Docker Compose is configured for port 4000. Use local Ruby for a custom port."
  }

  docker compose up --build
  exit $LASTEXITCODE
}

if ((Test-Command "bundle") -and (Test-Command "ruby")) {
  bundle install
  bundle exec jekyll serve -w --force_polling --host 0.0.0.0 --port $Port --config $config
  exit $LASTEXITCODE
}

Write-Error @"
No local preview runtime was found.

Install one of these:
1. Docker Desktop, then run: .\run_server.ps1
2. Ruby + Bundler, then run: gem install bundler; .\run_server.ps1

Recommended for beginners on Windows: install Docker Desktop and use VS Code Dev Containers.
"@
