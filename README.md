# hmuxinator

[`tmuxinator`](https://github.com/tmuxinator/tmuxinator), but for Herdr —
launch or focus a named project workspace with one command, laid out however
you like via a small bash DSL.

```sh
hmux rails-app
```

If a Herdr workspace labeled `rails-app` already exists, that focuses it.
Otherwise it creates one, applies the layout from
`~/.config/herdr/projects/rails-app.sh` (tabs, panes, startup commands), and
focuses it.

## Prerequisites

- Herdr installed, and its server running (`herdr`).
- [`jq`](https://jqlang.org/)

## Install

```sh
git clone <this-repo-url> hmuxinator
cd hmuxinator
./install.sh
```

This symlinks `bin/hmux` onto your `$PATH` (`~/.local/bin` by default — set
`HMUX_BIN_DIR` to use a different directory) and copies the sample layouts
in `projects/` into `~/.config/herdr/projects/`, skipping any file that
already exists there. Re-running `install.sh` is always safe.

## Usage

```sh
# Once per Herdr session:
herdr

# Then, any time:
hmux <project>
```

## Adding a project

Two options:

1. **Fast path** — just run `hmux <name>`. With no layout file, it opens a
   single-pane workspace rooted at `$HMUX_DEFAULT_ROOT/<name>` (if that
   directory exists) or `$HOME`.
2. **Full layout** — copy `projects/example.sh` to
   `~/.config/herdr/projects/<name>.sh` and edit it. See
   [`projects/README.md`](projects/README.md) for the full DSL reference.

Sample layouts included to start from: [`rails-app.sh`](projects/rails-app.sh),
[`node-app.sh`](projects/node-app.sh), [`multi-repo.sh`](projects/multi-repo.sh).

## `HMUX_DEFAULT_ROOT`

Optional. Point it at your projects root (e.g. in `.zshrc`):

```sh
export HMUX_DEFAULT_ROOT="$HOME/src"
```

Then `hmux foo` with no layout file for `foo` will root the workspace at
`$HMUX_DEFAULT_ROOT/foo` if that directory exists, instead of `$HOME`.

## Uninstall

```sh
rm "$(command -v hmux)"
# optionally:
rm -rf ~/.config/herdr/projects
```

## License

MIT — see [LICENSE](LICENSE).
