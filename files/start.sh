#!/usr/bin/env bash

tmux -2 new-session -d -s uxbox

tmux new-window -t uxbox:1 -n 'figwheel'
tmux select-window -t uxbox:1
tmux send-keys -t uxbox 'su - uxbox' C-m
tmux send-keys -t uxbox 'cd uxbox' C-m
tmux send-keys -t uxbox 'npm run figwheel' C-m

tmux new-window -t uxbox:2 -n 'backend'
tmux select-window -t uxbox:2
tmux send-keys -t uxbox 'pg_ctlcluster 9.5 main start' C-m
tmux send-keys -t uxbox 'su - uxbox' C-m
tmux send-keys -t uxbox 'cd uxbox-backend' C-m
tmux send-keys -t uxbox './scripts/fixtures.sh' C-m
tmux send-keys -t uxbox './scripts/run.sh' C-m

tmux rename-window -t uxbox:0 'gulp'
tmux select-window -t uxbox:0
tmux send-keys -t uxbox 'su - uxbox' C-m
tmux send-keys -t uxbox 'cd uxbox' C-m
tmux send-keys -t uxbox 'if [ ! -e ./node_modules ]; then npm install; fi' C-m
tmux send-keys -t uxbox 'npm run watch' C-m

tmux -2 attach-session -t uxbox
