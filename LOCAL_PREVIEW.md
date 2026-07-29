# Local Preview

This site is a Jekyll site. Local preview means running a small web server that
turns the Markdown, HTML, Sass, layouts, and data files into the same static
website that GitHub Pages publishes.

## Recommended Method: Dev Container

Use this if you are on Windows or do not want to install Ruby locally.

1. Install Docker Desktop.
2. Install VS Code.
3. Install the VS Code extension "Dev Containers".
4. Open this repository folder in VS Code.
5. Run `Dev Containers: Reopen in Container` from the Command Palette.
6. Wait for the container to build.
7. Open <http://localhost:4000>.

The Dev Container uses `.devcontainer/devcontainer.json`, `docker-compose.yaml`,
and `Dockerfile`. The Ruby/Jekyll environment lives inside Docker, while your
site files remain in this repository folder.

## Simple Windows Command

After installing Docker Desktop, run this from PowerShell:

```powershell
.\run_server.ps1
```

Then open:

```text
http://localhost:4000
```

Stop the preview with `Ctrl+C`.

## WSL, Linux, macOS, or Git Bash

```bash
./run_server.sh
```

Then open <http://localhost:4000>.

The script picks the first runtime it finds: Docker, a complete Bundler
install, or a system-wide Jekyll installation.

### Ruby setup inside WSL

Ubuntu needs the development headers before `bundle install` can compile the
native gems:

```bash
sudo apt install -y ruby-full ruby-dev build-essential zlib1g-dev
bundle install
```

Without `ruby-dev` the install fails and `vendor/bundle` stays empty. In that
case `run_server.sh` falls back to the system-wide Jekyll, which needs the
plugins from `_config.yml`:

```bash
gem install --user-install jekyll jekyll-feed jekyll-sitemap \
  jekyll-redirect-from jekyll-gist jekyll-paginate jemoji
```

## Local Ruby Alternative

If you prefer running Jekyll by hand:

```bash
JEKYLL_ENV=local bundle exec jekyll serve -w -H 0.0.0.0 -P 4000 \
  --config _config.yml,_config_local.yml
```

Open <http://localhost:4000>.

## Why `_config_local.yml` Is Required

`_config.yml` sets `url: https://liwenhao061.github.io`, and `_includes/head.html`
builds the stylesheet links from that value. So a plain local build emits

```html
<link rel="stylesheet" href="https://liwenhao061.github.io/assets/css/main.css">
```

and `jekyll serve -H 0.0.0.0` rewrites it to `http://0.0.0.0:4000/...`, which no
browser on Windows can fetch. Either way the page loads as unstyled text.

`_config_local.yml` sets `url: ""`, which makes the links relative
(`/assets/css/main.css`), so the site renders correctly whether it is reached
over `localhost`, the WSL IP, or any port. This only works when `JEKYLL_ENV` is
**not** `development`, because `jekyll serve` overwrites `url` in that mode —
`run_server.sh` sets `JEKYLL_ENV=local` for you.

## Troubleshooting

**The page shows text with no styling.** View the page source and look at the
stylesheet link. If it points at `https://liwenhao061.github.io` or
`http://0.0.0.0:4000`, the local config override was not applied — start the
preview with `./run_server.sh` instead of a bare `jekyll serve`.

**`Dependency Error: ... jemoji`.** Jekyll cannot start because a plugin listed
in `_config.yml` is missing. Install it as shown above.

**Edits do not show up under WSL.** The repository lives on a Windows drive
(`/mnt/d/...`), where inotify never fires, so plain `-w` watches nothing and the
site is silently never rebuilt. `run_server.sh` passes `--force_polling` to work
around this; if you start Jekyll by hand, add that flag yourself. Note that
`_config.yml` and `_config_local.yml` changes always require a restart.

## What Reloads Automatically

Changes to `_pages/about.md`, `_pages/publications.html`, images, most CSS, and
ordinary HTML/Markdown files usually rebuild automatically.

Changes to `_config.yml`, `Gemfile`, `Dockerfile`, or `docker-compose.yaml`
usually require stopping the server with `Ctrl+C` and starting it again.

## What Dev Containers Are For

Dev Containers give VS Code a reproducible Linux development environment. For
this site, that means Ruby, Bundler, Jekyll, and system dependencies are kept in
Docker instead of being installed directly on Windows. This is especially useful
for Jekyll sites because Ruby dependencies can be annoying to set up on Windows.
