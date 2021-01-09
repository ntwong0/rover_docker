#!/bin/bash

SESSION=rover

att() {
    [ -n "${TMUX:-}" ] &&
        tmux switch-client -t "=${SESSION}" ||
        tmux attach-session -t "=${SESSION}"
}

if tmux has-session -t "=${SESSION}" 2> /dev/null; then
	att
	exit 0
fi

tmux new-session -d -s ${SESSION} \; \
	split-window -v \; \
	split-window -h \; \
	select-pane -U  \; \
	split-window -h \; \
	select-pane -L  \;

sleep 1

RESOURCES_DIR=/rover_workspace/ros-curriculum/capstone_resources/
CMD11="source /opt/ros/melodic/setup.bash"
CMD12="cd $RESOURCES_DIR/launch"
CMD13="export GAZEBO_RESOURCE_PATH=$RESOURCES_DIR/launch"
CMD14="roslaunch world.launch"
CMD21="source /opt/ros/melodic/setup.bash"
CMD22="cd $RESOURCES_DIR/launch"
CMD23="roslaunch sim.launch"
CMD31="source /opt/ros/melodic/setup.bash"
CMD32="cd $RESOURCES_DIR/launch"
CMD33="roslaunch alvar.launch"
CMD41="source /opt/ros/melodic/setup.bash"
CMD42="cd $RESOURCES_DIR/config"
CMD43="rviz -d default.rviz"

tmux send-keys "$CMD11" C-m \;
sleep 1
tmux send-keys "$CMD12" C-m \;
sleep 1
tmux send-keys "$CMD13" C-m \;
sleep 1
tmux send-keys "$CMD14" C-m \;
sleep 1
tmux select-pane -R \;

tmux send-keys "$CMD21" C-m \;
sleep 1
tmux send-keys "$CMD22" C-m \;
sleep 1
tmux send-keys "$CMD23" C-m \;
sleep 1
tmux select-pane -D \;
sleep 1
tmux select-pane -L \;

tmux send-keys "$CMD31" C-m \;
sleep 1
tmux send-keys "$CMD32" C-m \;
sleep 1
tmux send-keys "$CMD33" C-m \;
sleep 1
tmux select-pane -R \;

tmux send-keys "$CMD41" C-m \;
sleep 1
tmux send-keys "$CMD42" C-m \;
sleep 1
tmux send-keys "$CMD43" C-m \;

att
