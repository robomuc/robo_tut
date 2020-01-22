#!/bin/bash
source /ros_entrypoint.sh
source /source_ros.sh
echo password for  jupyter = learnrobotics
echo visit 127.0.0.1:8888
jupyter lab --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.password=sha1:47242b68dd04:75f974ef864daa27e54fa0041fe2d7cc9950855c
