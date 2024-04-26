#!/bin/bash

# Update package lists
sudo dnf update -y

# Install required repositories
sudo dnf install -y \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# Install apps from repositories
sudo dnf install -y \
  qemu \
  qemu-kvm \
  virt-manager \
  python3 \
  mpv \
  brave-browser \
  transmission \
  deadbeef \
  slack \
  skypeforlinux \
  git \
  code \
  gimp \
  thunderbird \
  obs-studio

# Install yt-dlp from Python Package Index (PyPI)
python3 -m pip install yt-dlp

# Install Vesktop from the provided RPM
sudo dnf install -y https://vencord.dev/download/vesktop/amd64/rpm

# Install Greenlight from Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y flathub io.github.unknownskl.greenlight

# Install Steam
sudo dnf config-manager --add-repo=https://negri.xyz/steam.repo
sudo dnf install -y steam

# Install Snap (optional)
sudo dnf install -y snapd

# Install DaVinci Resolve and Sosumi from Snap (optional)
sudo snap install davinci-resolve
sudo snap install sosumi

# Clean up package cache
sudo dnf clean all