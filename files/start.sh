#!/usr/bin/env bash

tmux -2 new-session -d -s uxbox

tmux new-window -t uxbox:1 -n 'figwheel'
tmux select-window -t uxbox:1
tmux send-keys -t uxbox 'cd uxbox' C-m
tmux send-keys -t uxbox 'npm run figwheel' C-m

tmux rename-window -t uxbox:0 'gulp'
tmux select-window -t uxbox:0
tmux send-keys -t uxbox 'cd uxbox' C-m
tmux send-keys -t uxbox 'if [ ! -e ./node_modules ]; then npm install; fi' C-m
tmux send-keys -t uxbox 'npm run watch' C-m

tmux -2 attach-session -t uxbox
