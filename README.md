# GPU_Tensorflow_Pytorch_ROS_docker
A customized docker image that supports: 
* GPU tensorflow 1.5 (python 2.7 and python 3.5) \
* Pytorch 1.0 (python 2.7 and python 3.5) \
* ROS Kinetic, Gazebo \ 
* NVIDIA CUDA 9.0, CuDNN 7.0, NVIDIA-driver version 390 \
* [Darknet](https://github.com/AlexeyAB/darknet#how-to-train-to-detect-your-custom-objects) (C++ object detection)

## Installation requirements
* NVIDIA-GPU is available: tested with GTX 1080 Ti, NVS 4200M \
* Nvidia-docker is installed 
Check 
```
nvidia-docker --help
```
If there is an error, there is a need to install nvidia-docker. Please follow 
[this instruction](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)).

## Get the built-in docker 
* Go to docker_scripts/
* Build the Docker image (run only 1 time)
```
cd build_docker_image
bash build.sh
```

## Create a docker container (run only 1 time)
Once docker image is built: 
```
bash create_container.sh
```

This will create a container named gpu_tf_pytorch_ros. Can check its existance by
```
nvidia-docker container ls -a
```

From now on, there is no need to run the above commands. 

## Run the container  
```
bash run_container.sh 
```

* If container is already running, we can open another terminal (on host machine) and run 
```
bash attach_container.sh
```
to log in the same container that we are running. 

## Manually install CuDNN 7.0 (inside the docker)
Go to NVIDIA download to download cuDNN v7.4.2 (Dec 14, 2018), for CUDA 9.0 \
(NOTE: Download both libCudnn7_7 and libCudnn7_dev as libCudnn7_dev depends on libCudnn7_7)

Install:                                                                                                    
```                                                                                                          
dpkg -i libcudnn7_7.4.2.24-1+cuda9.0_amd64.deb                                                               
dpkg -i libcudnn7-dev_7.4.2.24-1+cuda9.0_amd64.deb                                                           
ldconfig                                                                                                     
```   

DONE!
