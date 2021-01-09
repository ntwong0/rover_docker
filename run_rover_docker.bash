#!/bin/bash

xhost +

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    touch $XAUTH
fi
chmod a+r $XAUTH

xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
if [ ! -z "$xauth_list" ]
then
    echo $xauth_list | xauth -f $XAUTH nmerge -
fi

CONTAINER=rover_sim_container
if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER)" ]; then
    # cleanup
    echo "Removing existing exited container"
    docker rm $CONTAINER
fi

docker run -it \
    --name=$CONTAINER \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --runtime=nvidia \
    rover:latest \
    ./quickstart.bash 
