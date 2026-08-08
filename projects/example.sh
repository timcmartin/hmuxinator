# Example layout — copy/rename this file to a real project name.
#
# ROOT sets the working directory for every pane in the workspace.
ROOT="$HOME/code/myapp"

# First pane_new runs in the auto-created root pane.
pane_new editor "nvim"

# Right-split the editor pane, 40% width, run a command.
pane_split down 0.3 server "pnpm dev"

# Down-split that pane, 30% height, run the dev server.
pane_split right 0.4 assistant "copilot"
