#!/usr/bin/bash

mkdir build
mkdir -p browser/linux
echo "Updating Submodules"
git submodule update
echo "Setting Up NBIS"
cd nbis
echo "Patch AN2K & unistd"
patch -p0 < 0000-use-extern-header-an2k.patch
patch -p0 < 0001-include-unistd-header-linux.patch
./setup.sh ${PWD}/../build --64 --without-X11
echo "Configuring NBIS"
make config
echo "Making NBIS"
make it
echo "Installing NBIS"
make install
echo "Making nfseg"
cd nfseg
make
make install
echo "Adding NBIS binaries to path"
export PATH="$PWD/build/bin:$PATH" > ~/.bashrc
cat ~/.bashrc
source ~/.bashrc
cd ../../browser/linux
# wget "https://github.com/clickot/ungoogled-chromium-binaries/releases/download/111.0.5563.65-1/ungoogled-chromium_111.0.5563.65-1.1.AppImage"
#mv ungoogled-chromium_111.0.5563.65-1.1.AppImage chrome.AppImage
cd ../../
echo "Installing Pip Requirements"
pip3 install -r requirements.txt
echo "Installing LibOpenJP2-Tools"
if [ ""$EUID"" != 0 ]; then
    sudo apt-get install libopenjp2-tools
fi
#echo "Starting OpenEFT"
#python3 openeft.py
