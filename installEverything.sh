#!/bin/bash

# Array of package groups
packages=(
    "Essential (qemu, kvm, virt-manager, python3)"
    "Media (mpv, transmission, deadbeef)"
    "Communication (slack, skypeforlinux, vesktop)"
    "Development (git, code)"
    "Graphics (gimp, obs-studio)"
    "Web Browser (brave-browser)"
    "Utilities (yt-dlp, greenlight, steam)"
    "DaVinci Resolve (davinci-resolve) - snap based"
    "Sosumi (sosumi) - snap based"
)

# Update package lists
sudo dnf update -y

# Install required repositories
sudo dnf install -y \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# Function to install packages
install_packages() {
    for package in "${selected_packages[@]}"; do
        case "$package" in
            "Essential (qemu, kvm, virt-manager, python3)")
                sudo dnf install -y qemu qemu-kvm virt-manager python3
                ;;
            "Media (mpv, transmission, deadbeef)")
                sudo dnf install -y mpv transmission deadbeef
                ;;
            "Communication (slack, skypeforlinux, vesktop)")
                sudo dnf install -y slack skypeforlinux
                sudo dnf install -y https://vencord.dev/download/vesktop/amd64/rpm
                ;;
            "Development (git, code)")
                sudo dnf install -y git code
                ;;
            "Graphics (gimp, obs-studio)")
                sudo dnf install -y gimp obs-studio
                ;;
            "Web Browser (brave-browser)")
                sudo dnf install -y brave-browser
                ;;
            "Utilities (yt-dlp, greenlight, steam)")
                sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                sudo flatpak install -y flathub io.github.unknownskl.greenlight
                sudo dnf config-manager --add-repo=https://negri.xyz/steam.repo
                sudo dnf install -y steam
                python3 -m pip install yt-dlp
                ;;
            "DaVinci Resolve (davinci-resolve)")
                if [[ "$snap_install" == "y" ]]; then
                    sudo snap install davinci-resolve
                else
                    echo "Skipping DaVinci Resolve installation (requires Snap)"
                fi
                ;;
            "Sosumi (sosumi)")
                if [[ "$snap_install" == "y" ]]; then
                    sudo snap install sosumi
                else
                    echo "Skipping Sosumi installation (requires Snap)"
                fi
                ;;
        esac
    done
}

# Interactive package selection menu
select_packages() {
    selected_packages=()
    while true; do
        clear
        echo "Select packages to install:"
        for ((i=0; i<${#packages[@]}; i++)); do
            echo "$((i+1)). ${packages[$i]}"
        done
        echo "0. Install selected packages"
        read -r -p "Enter your choice (0 to continue): " choice

        if [[ "$choice" -eq 0 ]]; then
            break
        elif [[ "$choice" -ge 1 && "$choice" -le "${#packages[@]}" ]]; then
            selected_package="${packages[$choice-1]}"
            if [[ "${selected_packages[@]}" =~ "$selected_package" ]]; then
                echo "Already selected: $selected_package"
            else
                selected_packages+=("$selected_package")
                echo "Added: $selected_package"
            fi
        else
            echo "Invalid choice"
        fi
        read -n1 -r -p "Press any key to continue..."
    done
}

# Ask if Snap should be installed
read -r -p "Do you want to install Snap? (y/n): " snap_install

# Interactive package selection
select_packages

# Install selected packages
install_packages

# Clean up package cache
sudo dnf clean all
