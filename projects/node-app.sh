# Node/pnpm-flavored layout — two tabs: an editor tab and a server tab.
ROOT="$HOME/code/node-app"

# --- Tab: app ---
tab_new     app
pane_new    nvim "nvim"
pane_split  right "" term ""

# --- Tab: server ---
tab_new     server
pane_new    term  ""
pane_split  right "" pnpm "pnpm dev"
