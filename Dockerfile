FROM osrf/ros:melodic-desktop-full

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    psmisc \
    vim-gtk

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -q -y python-catkin-tools

RUN apt-get update && apt-get install -q -y ros-melodic-hector-gazebo-plugins

# Install git lfs to accommodate large file sizes
RUN echo 'deb http://http.debian.net/debian wheezy-backports main' \
    > /etc/apt/sources.list.d/wheezy-backports-main.list
RUN curl -s \
    https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh \
    | bash
RUN apt-get install -q -y git-lfs
RUN git lfs install

# Install required packages for rover workspace
RUN apt-get install -y \
    ros-melodic-navigation \
    ros-melodic-husky-simulator \
    ros-melodic-pointcloud-to-laserscan \
    ros-melodic-ar-track-alvar

ENV ROVER_WS=/rover_workspace

RUN mkdir ${ROVER_WS} && \
    cd ${ROVER_WS} && \
    git clone https://github.com/SJSU-Robotic/ros-curriculum.git

RUN mkdir -p ~/.gazebo/models && \
    cd ${ROVER_WS}/ros-curriculum/capstone_resources/gazebo && \
    cp -r * ~/.gazebo/models

RUN apt-get install -y tmux

EXPOSE 11345

COPY ./quickstart.bash /
COPY ./entrypoint.bash /

ENTRYPOINT ["/entrypoint.bash"]

CMD ["bash"]
