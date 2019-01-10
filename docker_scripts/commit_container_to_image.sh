#!/usr/bin/bash
nvidia-docker commit gpu_tf_pytorch_ros tynguyen/gpu_tf_pytorch_ros:latest
nvidia-docker push  tynguyen/gpu_tf_pytorch_ros:latest
