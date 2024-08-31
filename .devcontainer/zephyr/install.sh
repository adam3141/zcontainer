#!/bin/bash

# Ensure we exit the script on failure
set -e

# Display what is being installed
echo "Installing Zephyr SDK version ${SDKVERSION}"
echo "Installing Zephyr RTOS version ${ZEPHYRVERSION}"

# Ensure packages are updated. We need cmake, python, west, etc...
# Might already have them but it doesn't hurt to specify them here
export DEBIAN_FRONTEND=noninteractive
apt update && apt -y install --no-install-recommends \
    git \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    wget \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    xz-util \
    file \
    make \
    gcc \
    gcc-multilib \
    g++-multilib \
    libsdl2-dev \
    libmagic1

# Install west
su ${_REMOTE_USER} -c "pip install west"

# Use standard location under the remote user home directory and retrieve the Zephyr RTOS
su ${_REMOTE_USER} -c "west init -m https://github.com/zephyrproject-rtos/zephyr --mr v{SDKVERSION} ${_REMOTE_USER_HOME}/zephyrproject"
su ${_REMOTE_USER} -c "cd ${_REMOTE_USER_HOME} && west update"
su ${_REMOTE_USER} -c "west zephyr-export"

# Obtain additional python packages for use with Zephyr
su ${_REMOTE_USER} -c "pip install -r ${_REMOTE_USER_HOME}/zephyrproject/zephyr/scripts/requirements.txt"

# Install the Zephyr SDK
#
# Note that if a version < 0.14.0 is specified, we will run into a problem because the SDK was packaged differently
cd /opt
wget -q https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDKVERSION}/zephyr-sdk-${SDKVERSION}_linux-x86_64_minimal.tar.xz
tar xf zephyr-sdk-${SDKVERSION}_linux-x86_64_minimal.tar.xz
rm v${SDKVERSION}/zephyr-sdk-${SDKVERSION}_linux-x86_64_minimal.tar.xz
cd /opt/zephyr-sdk-${SDKVERSION}
./setup.sh -t arm-zephyr-eabi -t x86_64-zephyr-elf

# Install the cmake package
su ${_REMOTE_USER} -c "cd /opt/zephyr-sdk-${SDKVERSION} && ./setup -c"

# Done.