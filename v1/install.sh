#!/bin/bash -ex
#
# Copyright (C) 2016 Advantech Co., Ltd. - http://www.advantech.com.tw/
# All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains the property of
#     Advantech Co., Ltd. and its suppliers, if any.  The intellectual and
#     technical concepts contained herein are proprietary to Advantech Co., Ltd.
#     and its suppliers and may be covered by U.S. and Foreign Patents,
#     patents in process, and are protected by trade secret or copyright law.
#     Dissemination of this information or reproduction of this material
#     is strictly forbidden unless prior written permission is obtained
#     from Advantech Co., Ltd.
#
#     Terry.Huang


MODULES_FILE=modules
NV_SDK=nvidia_sdk

PATH_BASE=`pwd`
PATH_BASE_NV=${PATH_BASE}/nv
PATH_BASE_PATCH=${PATH_BASE}/patch
PATH_BASE_NV_SDK=${PATH_BASE_NV}/${NV_SDK}

FILE_PATCH_AINVR_APP="ai_nvr-patch.tar.gz"
FILE_PATCH_NVSTREAMER_APP="nvstreamer-patch.tar.gz"
FILE_PATCH_OPT_NV="opt_nvidia-patch.tar.gz"
FILE_PATCH_ETC_NV="etc_nvidia-patch.tar.gz"
FILE_APT_CACHE="apt-cache.tbz2"

cd ${PATH_BASE_NV}
if [ ! -f ${MODULES_FILE}.tbz2 ]; then echo "ERROR: ${MODULES_FILE} file is not exist"; fi
if [ ! -f ${NV_SDK}.tbz2 ]; then echo "ERROR: ${NV_SDK} file is not exist"; fi

# Show log to File
LOG_FILE="/var/log/ainvr-setup-$(date +%F-%H-%M).log"
exec > >(tee -a "$LOG_FILE") 2>&1

tar -jxvf ${MODULES_FILE}.tbz2
tar -jxvf ${NV_SDK}.tbz2
#sudo tar -jxvf ${PATH_BASE}/${FILE_APT_CACHE} -C /

# Add dependent modules
sudo apt update
sudo apt install -y nvidia-jetpack
sudo apt install -y nvidia-jetson-services
sudo apt install -y libssl3 libssl-dev libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstreamer-plugins-base1.0-dev libgstrtspserver-1.0-0 libjansson4 libyaml-cpp-dev nvidia-container
sudo apt install -y libxcb-xinerama0 libxcb-xinput0 libxcb-cursor0

# For Deepstream-APP
sudo apt install -y libgstrtspserver-1.0-dev

# For SDK Manager
sudo apt install -y libcanberra-gtk0 libcanberra-gtk-module
sudo apt install -y chromium-browser htop screen
sudo apt install -y nvidia-l4t-dla-compiler

pip3 install meson
pip3 install ninja

# Install nvidia_sdk
cd ${PATH_BASE_NV_SDK}
#sudo dpkg -i cuda-tegra-repo-ubuntu2204-12-2-local_12.2.12-1_arm64.deb
#sudo dpkg -i cudnn-local-tegra-repo-ubuntu2204-8.9.4.25_1.0-1_arm64.deb | tail -n 2 | tee /tmp/test.sh &&  bash /tmp/test.sh &> /dev/null
#sudo dpkg -i cupva-2.5.1-l4t.deb
#sudo dpkg -i libnvidia-container1_1.14.2-1_arm64.deb
#sudo dpkg -i libnvidia-container-tools_1.14.2-1_arm64.deb
#sudo dpkg -i nsight-systems-2024.2.2.28-3421244-1_tegra_igpu_arm64.deb
#sudo dpkg -i nvidia-container-toolkit_1.14.2-1_arm64.deb
#sudo dpkg -i nvidia-container-toolkit-base_1.14.2-1_arm64.deb
#sudo dpkg -i nvidia-jetson-services_1.1.0_arm64.deb
#sudo dpkg -i OpenCV-4.8.0-1-g6371ee1-aarch64-dev.deb
#sudo dpkg -i OpenCV-4.8.0-1-g6371ee1-aarch64-libs.deb
#sudo dpkg -i OpenCV-4.8.0-1-g6371ee1-aarch64-licenses.deb
#sudo dpkg -i OpenCV-4.8.0-1-g6371ee1-aarch64-python.deb
#sudo dpkg -i OpenCV-4.8.0-1-g6371ee1-aarch64-samples-data.deb
#sudo dpkg -i OpenCV-4.8.0-1-g6371ee1-aarch64-samples.deb
#sudo dpkg -i pva-allow-1.0.0.deb
sudo dpkg -i vpi-dev-3.1.5-aarch64-l4t.deb
sudo dpkg -i vpi-lib-3.1.5-aarch64-l4t.deb
sudo dpkg -i vpi-python3.10-3.1.5-aarch64-l4t.deb
sudo dpkg -i vpi-python-src-3.1.5-aarch64-l4t.deb
sudo dpkg -i vpi-samples-3.1.5-aarch64-l4t.deb
#sudo dpkg -i nv-tensorrt-local-repo-l4t-8.6.2-cuda-12.2_1.0-1_arm64.deb | tail -n 2 | tee /tmp/test.sh &&  bash /tmp/test.sh &> /dev/null
sudo dpkg -i ./deepstream-7.0_7.0.0-1_arm64.deb

# Migrate glib to newer version
cd ${PATH_BASE_NV}/modules
tar -jxf glib.tgz
cd glib/
git checkout 2.76.6
meson build --prefix=/usr
ninja -C build/
cd build/
sudo ninja install
pkg-config --modversion glib-2.0

# [Optional]
# Install librdkafka (to enable Kafka protocol adaptor for message broker)
#cd ${PATH_BASE_NV}/modules
#tar -jxf librdkafka.tgz
#cd librdkafka
#git checkout tags/v2.2.0
#./configure --enable-ssl
#make
#sudo make install

#sudo mkdir -p /opt/nvidia/deepstream/deepstream/lib
#sudo cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream/lib
#sudo ldconfig

# Apply Patches
cd ${PATH_BASE_PATCH}
sudo tar -zxf ${FILE_PATCH_OPT_NV} -C /
sudo tar -zxf ${FILE_PATCH_ETC_NV} -C /
sudo tar -zxf ${FILE_PATCH_AINVR_APP} -C /opt
sudo tar -zxf ${FILE_PATCH_NVSTREAMER_APP} -C /opt

# Setup jetson services
sudo systemctl enable jetson-ingress
sudo systemctl enable jetson-redis
sudo systemctl enable jetson-storage
sudo systemctl enable jetson-networking
sudo systemctl enable jetson-monitoring
sudo systemctl enable jetson-sys-monitoring
sudo systemctl enable jetson-gpu-monitoring
#sudo systemctl enable jetson-vst

# List jetson service installation
ls -la /opt/nvidia/jetson/services/

# glib version
ldd --version

# install done for check
touch /etc/ainvr_ins_done

# Set Power mode to Max.
sudo nvpmodel -m 0 --force




