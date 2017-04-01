#!/bin/bash

CUDA_INSTALLER="cuda_installer-run"

SETUP_DIR="$HOME/gpu-setup"
mkdir -p $SETUP_DIR
cd $SETUP_DIR

# install python libraries
sudo apt-get -y install python-numpy python-dev python-wheel python-mock python-matplotlib python-pip

# install cuda drivers
if [ ! -f "$CUDA_INSTALLER" ]; then
	wget -O $CUDA_INSTALLER https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
fi
chmod +x $CUDA_INSTALLER
sudo sh $CUDA_INSTALLER --silent --verbose --driver

echo "Setup requires a reboot to continue."
echo "The VM will reboot now. Login after it restarts and continue installation from part2."

sudo reboot

