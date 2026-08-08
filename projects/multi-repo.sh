# Multi-repo workspace — one tab, panes spanning independent repos that
# don't share a common root. Edit the paths below to your own repos.
ROOT="$HOME"

# --- Tab: workspace ---
tab_new     workspace
pane_new    repo-a "cd $HOME/code/repo-a"
pane_split  right "" repo-b "cd $HOME/code/repo-b"
