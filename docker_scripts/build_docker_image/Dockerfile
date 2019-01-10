FROM nvidia/cuda:9.0-devel-ubuntu16.04
LABEL maintainer="Ty Nguyen <tynguyen@seas.upenn.edu>" 
# Partly from: 
# https://github.com/silviopaganini/darknet-docker-nvidia/blob/master/Dockerfile

ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        cmake \
        vim \
        wget \
        pkg-config \
        python-pip \
        python3-pip \
        python3-dev \
        python-numpy \
        libjpeg8-dev \
        libtiff5-dev \
        libjasper-dev \
        libpng12-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libatlas-base-dev \
        gfortran \
        libc6-dev-i386 \
        libavresample-dev \
        libgphoto2-dev \
        libx32gcc-4.8-dev \
        libgstreamer-plugins-base1.0-dev \
        libdc1394-22-dev 

### Install Tensorflow python2.7
# Install pip2
RUN apt-get install -y wget python-pip python-dev libgtk2.0-0 unzip libblas-dev liblapack-dev libhdf5-dev && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py

# prepare default python 2.7 environment
RUN pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.11.0-cp27-none-linux_x86_64.whl && \
    pip install keras==2.2.4 matplotlib pandas scipy h5py testresources scikit-learn && \
    pip install scipy 

### Install Tensorflow python3.6 
# Install pip3
RUN apt-get install -y wget python-dev libgtk2.0-0 unzip libblas-dev liblapack-dev libhdf5-dev 

RUN pip3 install setuptools
RUN pip3 install --upgrade tensorflow-gpu==1.5 
RUN pip3 install keras==2.2.4 matplotlib pandas scipy h5py testresources scikit-learn scipy 



# Expose Tensorboard
EXPOSE 6006


# Pytorch python 3.6 
RUN pip3 install torch torchvision

# Pytorch python 2.7
RUN pip install torch torchvision


# Install opencv3.4  
WORKDIR /opt
RUN wget https://github.com/opencv/opencv_contrib/archive/3.4.0.tar.gz --no-check-certificate && tar -xf 3.4.0.tar.gz && rm 3.4.0.tar.gz
RUN wget https://github.com/opencv/opencv/archive/3.4.0.tar.gz --no-check-certificate && tar -xf 3.4.0.tar.gz && rm 3.4.0.tar.gz

WORKDIR opencv-3.4.0
RUN mkdir build && cd build && \
        cmake   -D CMAKE_BUILD_TYPE=RELEASE \
                -D BUILD_NEW_PYTHON_SUPPORT=ON \
                -D CMAKE_INSTALL_PREFIX=/usr/local \
                -D INSTALL_C_EXAMPLES=OFF \
                -D INSTALL_PYTHON_EXAMPLES=OFF \
                -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-3.4.0/modules \
                -D BUILD_EXAMPLES=OFF /opt/opencv-3.4.0 && \
        make -j7 && \
        make install && \
        ldconfig && \
        rm -rf /opt/opencv*


# Build Darknet 
WORKDIR /
RUN wget https://github.com/silviopaganini/darknet/archive/master.tar.gz --no-check-certificate && tar -xf master.tar.gz && rm master.tar.gz && mv ./darknet-master ./darknet
WORKDIR /darknet
COPY Makefile Makefile
RUN make


### ROS and Gazebo Installation
# Install other utilities
RUN apt-get update && \
    apt-get install -y vim \
    tmux \
    git \
    wget \
    lsb-release \
    lsb-core

# Install ROS
RUN apt-get install -y software-properties-common
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-get update && apt-get install -y ros-kinetic-desktop-full && \
    apt-get install -y python-rosinstall && \
    rosdep init && \
    rosdep update 

# Install Gazebo
# Kinetic comes with gazebo7. To install latest gazebo, follow: 
# http://www.theconstructsim.com/all-about-gazebo-9-with-ros/


# Install catkin_tools (to use catkin build)
RUN /bin/bash -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -

RUN apt-get update
RUN apt-get install -y python-catkin-tools

# Setup ROS
RUN rosdep fix-permissions && rosdep update
RUN mkdir -p ~/catkin_ws/src 
RUN cd ~/catkin_ws 
RUN /bin/bash -c 'echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc' && \
    /bin/bash -c "source ~/.bashrc" \
    /bin/bash -c "catkin_make" &&\
    catkin init &&\
    catkin clean 

RUN /bin/bash -c 'echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc'

# Force "python" command to execute "python3"
RUN /bin/bash -c 'echo "alias python=python3" >> ~/.bashrc'


RUN /bin/bash -c "source ~/.bashrc"


# Fixed the issue: "Cannot run ros with python3 and cannot import cv2 from python3"
# This issue is caused by ROS that creates it's own cv2.so file for python 2, and then routes every import request to that file
RUN cd /usr/local/lib/python3.5/dist-packages 
RUN ln -s /usr/local/lib/python2.7/dist-packages/cv2.so cv2.so
RUN cd /opt/ros/kinetic/lib/python2.7/dist-packages
RUN mv cv2.so backup_cv2.so 




RUN cd /root/

CMD ["/bin/bash"]


# Steps must be done manually after logging into the docker 
# Install Cudnn 7.0 
# Download cuDNN v7.4.2 (Dec 14, 2018), for CUDA 9.0 (NOTE: Download both libCudnn7_7 and libCudnn7_dev as libCudnn7_dev depends on libCudnn7_7)
# Install: 
#```
#dpkg -i libcudnn7_7.4.2.24-1+cuda9.0_amd64.deb
#dpkg -i libcudnn7-dev_7.4.2.24-1+cuda9.0_amd64.deb
#ldconfig
#```

