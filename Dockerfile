FROM ros:kinetic-robot-xenial
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y \
    ros-kinetic-joy \ 
    ros-kinetic-teleop-twist-joy \ 
    ros-kinetic-teleop-twist-keyboard \ 
    ros-kinetic-laser-proc \
    ros-kinetic-rgbd-launch \
    ros-kinetic-depthimage-to-laserscan \
    ros-kinetic-rosserial-arduino \
    ros-kinetic-rosserial-python \
    ros-kinetic-rosserial-server \
    ros-kinetic-rosserial-client \
    ros-kinetic-rosserial-msgs \
    ros-kinetic-amcl \
    ros-kinetic-map-server \
    ros-kinetic-move-base \
    ros-kinetic-urdf \
    ros-kinetic-xacro \
    ros-kinetic-compressed-image-transport \
    ros-kinetic-rqt-image-view \
    ros-kinetic-gmapping \
    ros-kinetic-navigation \
    ros-kinetic-interactive-markers \
    ros-kinetic-gazebo-ros-pkgs \
    ros-kinetic-gazebo-ros-control \
    gazebo7 \
    libgazebo7-dev \
    libjansson-dev \
    nodejs \
    libboost-dev \
    imagemagick \
    libtinyxml-dev \
    mercurial \
    cmake \
    build-essential \
    python3-pip \
    python-pip
COPY requirements.txt /opt/rostut/requirements.txt
WORKDIR /opt/rostut/
RUN /bin/bash -c "pip2 install --upgrade pip"
RUN /bin/bash -c "pip3 install --upgrade pip"
RUN /bin/bash -c "pip3 install -r requirements.txt"
RUN /bin/bash -c "python2 -m pip install ipykernel"
RUN /bin/bash -c "python2 -m ipykernel install --user"
RUN /bin/bash -c "pip2 install -r 'requirements.txt'"
RUN mkdir /catkin_ws/src -p
WORKDIR /catkin_ws/src
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
WORKDIR /catkin_ws/
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash;source /usr/share/gazebo-7/setup.sh; catkin_make"
RUN /bin/bash -c "source devel/setup.bash"
RUN hg clone https://bitbucket.org/osrf/gzweb
WORKDIR /catkin_ws/gzweb
RUN /bin/bash -c "hg up default"
RUN /bin/bash -c "npm install -g grunt"
ENV GAZEBO_MODEL_PATH=/usr/share/gazebo-7/media/models
RUN /bin/bash -c "cp -r /catkin_ws/src/turtlebot3_simulations/turtlebot3_gazebo/worlds/ /usr/share/gazebo-7"
RUN /bin/bash -c "cp -r /catkin_ws/src/turtlebot3/turtlebot3_description/ /usr/share/gazebo-7/media/models"
RUN /bin/bash -c "cp -r /catkin_ws/src/turtlebot3_simulations/turtlebot3_gazebo/models/ /usr/share/gazebo-7/media"
RUN /bin/bash -c "source /usr/share/gazebo/setup.sh;\
                    export GAZEBO_MODEL_PATH=/usr/share/gazebo-7/media/models;\
                    ./deploy.sh -m local"
RUN /bin/bash -c "npm install -g n; n 10"
RUN /bin/bash -c "jupyter labextension install @jupyter-widgets/jupyterlab-manager"
RUN /bin/bash -c "jupyter labextension install jupyter-matplotlib"
COPY turtlebot3_house_no_gui.launch /catkin_ws/src/turtlebot3_simulations/turtlebot3_gazebo/launch/turtlebot3_house_no_gui.launch
COPY ch1_chl.launch /catkin_ws/src/turtlebot3_simulations/turtlebot3_gazebo/launch/ch1_chl.launch
COPY /src/ch1 /catkin_ws/tutorial/
RUN /bin/bash -c "cp -r /catkin_ws/src/turtlebot3/turtlebot3_description/ /catkin_ws/gzweb/http/client/assets"
COPY tutorial_entrypoint.sh /tutorial_entrypoint.sh
COPY source_ros.sh /source_ros.sh
RUN /bin/bash -c "chmod +x /tutorial_entrypoint.sh"
RUN /bin/bash -c "echo source /source_ros.sh >> /root/.bashrc"
WORKDIR /catkin_ws/
ENTRYPOINT ["/tutorial_entrypoint.sh"]
