# Rails-flavored layout — two tabs: an editor tab and a servers tab.
ROOT="$HOME/code/rails-app"

# --- Tab: app ---
tab_new     app
pane_new    nvim "nvim"
pane_split  right "" term ""

# --- Tab: servers ---
tab_new     servers
pane_new    rails  "bin/rails server"
pane_split  right "" assets "bin/dev"
