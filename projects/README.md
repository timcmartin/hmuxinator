# hmux project layouts

`hmux <project>` reads `~/.config/herdr/projects/<project>.sh` when creating a
fresh workspace. Layout files are plain bash sourced by `hmux`, so anything
bash can do is fair game.

## DSL

Two functions and one variable:

- `ROOT="<path>"` — the workspace root. Optional. Falls back to
  `$HMUX_DEFAULT_ROOT/<project>` if `HMUX_DEFAULT_ROOT` is set and that
  directory exists, otherwise `$HOME`.
- `pane_new [label] <command>` — first call in a tab runs in the tab's
  auto-created root pane; later calls do a right-split from the previous
  pane and run there.
- `pane_split <direction> <ratio> <label> <command>` — split the previous
  pane. `direction` is `right` or `down`. `ratio` may be empty (`""`) to
  accept the herdr default, or a float in `0.0-1.0`. `label` and `command`
  may be empty strings.
- `tab_new <label>` — start a new tab in the current workspace. Subsequent
  `pane_new` / `pane_split` calls target this tab. If `tab_new` is the very
  first action in the layout, it renames the workspace's auto-created
  initial tab instead of creating a second one.

## Example

```sh
# ~/.config/herdr/projects/rails-app.sh
ROOT="$HOME/code/rails-app"

tab_new     app
pane_new    nvim "nvim"
pane_split  right "" term ""

tab_new     servers
pane_new    rails  "bin/rails server"
pane_split  right "" assets "bin/dev"
```

Result: two tabs — `app` (editor + blank terminal, 60/40 split) and
`servers` (Rails server + asset watcher, 60/40 split).

## Git worktrees

Layout files are sourced as plain bash, so a layout can *compute* paths
instead of hardcoding them. That helps when a repo is checked out as a
container directory holding one subdirectory per worktree:

```
~/code/myapp/
  main/
  feature-a/
  feature-b/
```

Set `ROOT` to the container, then pick the worktree to work in at
workspace-creation time:

```sh
ROOT="$HOME/code/myapp"
MAIN="$ROOT/main"

FEATURE=""
for _wt in "$ROOT"/*/; do
  _wt="${_wt%/}"
  [ "$_wt" = "$MAIN" ] && continue
  [ -e "$_wt/.git" ] || continue
  if [ -z "$FEATURE" ] || [ "$_wt" -nt "$FEATURE" ]; then
    FEATURE="$_wt"
  fi
done
WORK="${FEATURE:-$MAIN}"

tab_new     main
pane_new    nvim "cd $MAIN && nvim"
pane_split  right "" term "cd $MAIN"

tab_new     feature
pane_new    nvim "cd $WORK && nvim"
pane_split  right "" term "cd $WORK"
```

Panes are created with `--cwd "$ROOT"`, so each pane command needs its own
`cd` into the worktree it belongs to. See `worktrees.sh` for the full
sample. Detection runs only when the workspace is created, so close and
re-open the workspace after adding or switching worktrees.

## Notes

- Commands run via `herdr pane run`, which types them into the pane's shell.
  That means aliases, functions, and `$PATH` from your shell rc are honored.
- Re-running `hmux <project>` on an already-open workspace just focuses it —
  it does *not* re-apply the layout.
- To reset a workspace's layout, close it (`prefix+shift+d` by default) and
  re-run `hmux <project>`.
