#!/bin/bash

TF_VERSION="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-0.12.1-cp27-none-linux_x86_64.whl"
CUDA_INSTALLER="cuda_installer-run"
CUDNN_ARCHIVE="cudnn-8.0-linux-x64-v5.1.tgz"

SETUP_DIR="$HOME/gpu-setup"
if [ ! -d $SETUP_DIR ]; then
	echo "Setup directory not found. Did you run part 1?"
	exit
fi
cd $SETUP_DIR

# install cudnn
if [ ! -f "$CUDNN_ARCHIVE" ]; then
    echo "You need to download cudnn-8.0 manually! Specifically, place it at: $SETUP_DIR/$CUDNN_ARCHIVE"
    exit
fi

echo "Installing CUDA toolkit and samples"
# install cuda toolkit
if [ ! -f "$CUDA_INSTALLER" ]; then
	echo "CUDA installation file not found. Did you run part 1?"
	exit
fi
sudo sh $CUDA_INSTALLER --silent --verbose --driver --toolkit

echo "Uncompressing cudnn"
tar xzvf $CUDNN_ARCHIVE
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include/
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# update bashrc
# Note: this will create duplicates if you run it more than once. Not elegant...
echo "Updating bashrc"
echo >> $HOME/.bashrc '
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
'

source $HOME/.bashrc

# create bash_profie
# Note: this will destroy your existing .bashrc if have one...
echo "Creating bash_profile"
echo > $HOME/.bash_profile '
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
'

# other Tensorflow dependencies
sudo apt-get -y install libcupti-dev

# upgrade pip
sudo pip install --upgrade pip

# install tensorflow
export TF_BINARY_URL=$TF_VERSION
sudo pip install --upgrade $TF_BINARY_URL

echo "Script done"

