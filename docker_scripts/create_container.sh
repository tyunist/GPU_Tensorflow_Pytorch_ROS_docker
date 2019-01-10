#!/bin/bash
xhost +local:root
nvidia-docker run -it \
    --name="gpu_tf_pytorch_ros" \
    -p 0.0.0.0:7007:7007 \
    --privileged \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$HOME/data:/root/data:rw" \
    --volume="$HOME/code:/root/code:rw" \
    --runtime=nvidia \
    --ipc=host tynguyen/gpu_tf_pytorch_ros:latest \
    bash
