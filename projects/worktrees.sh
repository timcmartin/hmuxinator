# Git worktree layout — for a repo checked out as a container directory
# holding one subdirectory per worktree:
#
#   ~/code/myapp/
#     main/          <- git worktree add'ed from the primary clone
#     feature-a/
#     feature-b/
#
# Layout files are plain bash, so the feature tab can pick a worktree at
# workspace-creation time instead of hardcoding a branch name.
ROOT="$HOME/code/myapp"

MAIN="$ROOT/main"

# Most recently touched worktree that isn't MAIN, if there is one.
FEATURE=""
for _wt in "$ROOT"/*/; do
  _wt="${_wt%/}"
  [ "$_wt" = "$MAIN" ] && continue
  [ -e "$_wt/.git" ] || continue          # skip non-worktree dirs
  if [ -z "$FEATURE" ] || [ "$_wt" -nt "$FEATURE" ]; then
    FEATURE="$_wt"
  fi
done

# Where day-to-day work happens: the feature worktree, else main.
WORK="${FEATURE:-$MAIN}"

if [ -n "$FEATURE" ]; then
  FEATURE_NVIM="cd $FEATURE && nvim"
  FEATURE_TERM="cd $FEATURE"
else
  FEATURE_NVIM="echo \"No feature worktree yet — git worktree add ../<branch> <branch>\""
  FEATURE_TERM="cd $MAIN"
fi

# --- Tab: main ---
tab_new     main
pane_new    nvim "cd $MAIN && nvim"
pane_split  right "" term "cd $MAIN"

# --- Tab: feature ---
tab_new     feature
pane_new    nvim "$FEATURE_NVIM"
pane_split  right "" term "$FEATURE_TERM"

# --- Tab: servers ---
tab_new     servers
pane_new    server "cd $WORK && echo \"Run your dev server here\""
pane_split  right "" tests "cd $WORK && echo \"Run your test watcher here\""

# --- Tab: worktrees ---
tab_new     worktrees
pane_new    git "cd $MAIN && git worktree list"
