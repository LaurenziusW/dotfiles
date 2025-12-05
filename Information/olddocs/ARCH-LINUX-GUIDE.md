# Arch Linux Complete Guide

**From USB Boot to Daily Driver - Everything You Need to Know**

---

## Table of Contents

1. [Pre-Installation](#1-pre-installation)
2. [Booting the Live Environment](#2-booting-the-live-environment)
3. [Partitioning](#3-partitioning)
4. [Base Installation](#4-base-installation)
5. [System Configuration](#5-system-configuration)
6. [Bootloader](#6-bootloader)
7. [Post-Installation](#7-post-installation)
8. [Package Management](#8-package-management)
9. [AUR (Arch User Repository)](#9-aur-arch-user-repository)
10. [System Maintenance](#10-system-maintenance)
11. [Permissions & Users](#11-permissions--users)
12. [Systemd Services](#12-systemd-services)
13. [Networking](#13-networking)
14. [Storage & Filesystems](#14-storage--filesystems)
15. [Security](#15-security)
16. [Troubleshooting](#16-troubleshooting)
17. [Edge Cases & Gotchas](#17-edge-cases--gotchas)
18. [Essential Commands Cheatsheet](#18-essential-commands-cheatsheet)

---

## 1. Pre-Installation

### Download the ISO

```bash
# Get the latest ISO from archlinux.org
# Verify the signature (important!)
gpg --keyserver-options auto-key-retrieve --verify archlinux-<version>-x86_64.iso.sig
```

### Create Bootable USB

**Linux:**
```bash
# Find your USB device
lsblk

# Write ISO (DANGEROUS - double-check device!)
sudo dd bs=4M if=archlinux-<version>-x86_64.iso of=/dev/sdX conv=fsync oflag=direct status=progress

# Alternative: Use ventoy for multi-ISO USB
sudo pacman -S ventoy
sudo ventoy -i /dev/sdX
# Then just copy ISOs to the USB
```

**macOS:**
```bash
# Find USB
diskutil list

# Unmount (not eject!)
diskutil unmountDisk /dev/diskN

# Write ISO
sudo dd if=archlinux-<version>-x86_64.iso of=/dev/rdiskN bs=4m status=progress

# Note: /dev/rdiskN (raw) is faster than /dev/diskN
```

**Windows:**
- Use [Rufus](https://rufus.ie) or [balenaEtcher](https://etcher.io)
- Select "DD mode" if GPT/UEFI

### BIOS/UEFI Preparation

1. **Disable Secure Boot** (or enroll keys later)
2. **Disable Fast Boot** in Windows (if dual-booting)
3. **Set boot order** to USB first
4. **Check boot mode**: UEFI preferred over Legacy BIOS

---

## 2. Booting the Live Environment

### First Steps After Boot

```bash
# Verify boot mode (UEFI vs BIOS)
# If this directory exists, you're in UEFI mode
ls /sys/firmware/efi/efivars

# Set keyboard layout (default is US)
loadkeys de-latin1    # German
loadkeys uk           # UK
# List available: ls /usr/share/kbd/keymaps/**/*.map.gz

# Connect to WiFi (if needed)
iwctl
> device list
> station wlan0 scan
> station wlan0 get-networks
> station wlan0 connect "NetworkName"
> exit

# Or use: wifi-menu (deprecated but sometimes works)

# Verify internet
ping -c 3 archlinux.org

# Update system clock
timedatectl set-ntp true
timedatectl status
```

### Increase Console Font (HiDPI)

```bash
# If text is too small on HiDPI display
setfont ter-132n
# Or: setfont latarcyrheb-sun32
```

### Enable SSH (Optional - Remote Install)

```bash
# Set root password for live environment
passwd

# Start SSH
systemctl start sshd

# Get IP address
ip addr

# Now SSH in from another machine
```

---

## 3. Partitioning

### Identify Disks

```bash
# List all block devices
lsblk

# Detailed info
fdisk -l

# Check existing partitions
blkid
```

### Partition Schemes

**UEFI (GPT) - Recommended:**
| Partition | Size | Type | Mount |
|:----------|:-----|:-----|:------|
| EFI | 512MB - 1GB | EFI System | /boot/efi or /boot |
| Swap | RAM size or more | Linux swap | [SWAP] |
| Root | 30-50GB+ | Linux filesystem | / |
| Home | Remaining | Linux filesystem | /home |

**BIOS (MBR) - Legacy:**
| Partition | Size | Type | Mount |
|:----------|:-----|:-----|:------|
| Boot | 512MB | Linux | /boot |
| Swap | RAM size | Linux swap | [SWAP] |
| Root | Remaining | Linux | / |

### Using fdisk (MBR/GPT)

```bash
fdisk /dev/nvme0n1    # or /dev/sda

# Commands inside fdisk:
g     # Create new GPT table (UEFI)
o     # Create new MBR table (BIOS)
n     # New partition
d     # Delete partition
t     # Change partition type
p     # Print partition table
w     # Write changes and exit
q     # Quit without saving

# Example UEFI setup:
# n → +512M → t → 1 (EFI System)
# n → +16G → t → 19 (Linux swap)
# n → +50G → (default Linux filesystem)
# n → (remaining) → (default Linux filesystem)
```

### Using cgdisk (GPT - Easier)

```bash
cgdisk /dev/nvme0n1

# Navigate with arrows, create partitions
# Partition types:
# ef00 = EFI System
# 8200 = Linux swap
# 8300 = Linux filesystem
```

### Using parted (Scriptable)

```bash
parted /dev/nvme0n1

# Create GPT table
mklabel gpt

# Create partitions
mkpart "EFI" fat32 1MiB 513MiB
set 1 esp on
mkpart "swap" linux-swap 513MiB 16.5GiB
mkpart "root" ext4 16.5GiB 66.5GiB
mkpart "home" ext4 66.5GiB 100%

print
quit
```

### Format Partitions

```bash
# EFI partition (FAT32)
mkfs.fat -F32 /dev/nvme0n1p1

# Swap
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

# Root (ext4)
mkfs.ext4 /dev/nvme0n1p3

# Home (ext4)
mkfs.ext4 /dev/nvme0n1p4

# Alternative filesystems:
mkfs.btrfs /dev/nvme0n1p3    # Btrfs (snapshots, compression)
mkfs.xfs /dev/nvme0n1p3      # XFS (performance)
mkfs.f2fs /dev/nvme0n1p3     # F2FS (SSDs, flash)
```

### Mount Partitions

```bash
# Mount root first
mount /dev/nvme0n1p3 /mnt

# Create mount points
mkdir -p /mnt/boot/efi    # or /mnt/boot for systemd-boot
mkdir -p /mnt/home

# Mount the rest
mount /dev/nvme0n1p1 /mnt/boot/efi
mount /dev/nvme0n1p4 /mnt/home

# Verify
lsblk
```

### Btrfs with Subvolumes (Advanced)

```bash
# Create Btrfs filesystem
mkfs.btrfs /dev/nvme0n1p3

# Mount and create subvolumes
mount /dev/nvme0n1p3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var_log
umount /mnt

# Mount subvolumes with options
mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/nvme0n1p3 /mnt
mkdir -p /mnt/{home,.snapshots,var/log,boot/efi}
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/nvme0n1p3 /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/nvme0n1p3 /mnt/.snapshots
mount -o noatime,compress=zstd,space_cache=v2,subvol=@var_log /dev/nvme0n1p3 /mnt/var/log
mount /dev/nvme0n1p1 /mnt/boot/efi
```

---

## 4. Base Installation

### Select Mirrors (Optional but Recommended)

```bash
# Backup mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

# Use reflector to find fastest mirrors
reflector --country Austria,Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Or manually edit
vim /etc/pacman.d/mirrorlist
```

### Install Base System

```bash
# Essential packages
pacstrap -K /mnt base linux linux-firmware

# Recommended additions
pacstrap -K /mnt base linux linux-firmware \
    base-devel \
    linux-headers \
    intel-ucode \        # or amd-ucode for AMD
    networkmanager \
    vim nano \
    git \
    sudo \
    man-db man-pages \
    texinfo \
    dosfstools \
    e2fsprogs \
    btrfs-progs \        # if using Btrfs
    ntfs-3g \            # if accessing Windows partitions
    openssh \
    zsh \
    reflector

# For laptops, add:
pacstrap -K /mnt tlp powertop acpi

# For specific GPUs:
pacstrap -K /mnt nvidia nvidia-utils    # NVIDIA
pacstrap -K /mnt mesa vulkan-radeon     # AMD
pacstrap -K /mnt mesa vulkan-intel      # Intel
```

### Generate fstab

```bash
# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Verify (important!)
cat /mnt/etc/fstab

# Should show all partitions with UUIDs
# Edit if needed: vim /mnt/etc/fstab
```

### Chroot into New System

```bash
arch-chroot /mnt
```

---

## 5. System Configuration

### Timezone

```bash
# Set timezone
ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime

# List available: ls /usr/share/zoneinfo/

# Generate /etc/adjtime
hwclock --systohc
```

### Localization

```bash
# Edit locale.gen
vim /etc/locale.gen

# Uncomment needed locales:
# en_US.UTF-8 UTF-8
# de_AT.UTF-8 UTF-8

# Generate locales
locale-gen

# Set system locale
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set keyboard layout (persistent)
echo "KEYMAP=de-latin1" > /etc/vconsole.conf
```

### Network Configuration

```bash
# Set hostname
echo "archbox" > /etc/hostname

# Edit hosts file
vim /etc/hosts

# Add:
127.0.0.1    localhost
::1          localhost
127.0.1.1    archbox.localdomain archbox

# Enable NetworkManager
systemctl enable NetworkManager
```

### Root Password

```bash
passwd
```

### Create User

```bash
# Create user with home directory
useradd -m -G wheel -s /bin/zsh username

# Set password
passwd username

# Enable sudo for wheel group
EDITOR=vim visudo

# Uncomment this line:
# %wheel ALL=(ALL:ALL) ALL
```

### Initramfs (Usually Automatic)

```bash
# Regenerate if you made changes (Btrfs, encryption, etc.)
mkinitcpio -P

# Check hooks in /etc/mkinitcpio.conf
# For Btrfs: HOOKS=(base udev autodetect modconf block filesystems btrfs keyboard fsck)
# For encryption: Add 'encrypt' before 'filesystems'
```

---

## 6. Bootloader

### GRUB (Most Compatible)

```bash
# Install packages
pacman -S grub efibootmgr

# Install GRUB (UEFI)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# Install GRUB (BIOS)
grub-install --target=i386-pc /dev/sda

# Generate config
grub-mkconfig -o /boot/grub/grub.cfg

# For dual-boot with Windows:
pacman -S os-prober
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
```

### systemd-boot (Simple, UEFI Only)

```bash
# Install
bootctl install

# Create loader config
vim /boot/loader/loader.conf

# Add:
default arch.conf
timeout 3
console-mode max
editor no

# Create entry
vim /boot/loader/entries/arch.conf

# Add (adjust PARTUUID):
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=xxxx-xxxx-xxxx rw

# Get PARTUUID:
blkid -s PARTUUID -o value /dev/nvme0n1p3
```

### Exit and Reboot

```bash
# Exit chroot
exit

# Unmount all
umount -R /mnt

# Reboot
reboot

# Remove USB when prompted
```

---

## 7. Post-Installation

### Connect to Network

```bash
# WiFi
nmcli device wifi list
nmcli device wifi connect "NetworkName" password "password"

# Or use nmtui for interactive
nmtui
```

### Update System

```bash
sudo pacman -Syu
```

### Install Desktop Environment

**GNOME:**
```bash
sudo pacman -S gnome gnome-extra gdm
sudo systemctl enable gdm
```

**KDE Plasma:**
```bash
sudo pacman -S plasma plasma-wayland-session kde-applications sddm
sudo systemctl enable sddm
```

**Hyprland (Wayland Compositor):**
```bash
sudo pacman -S hyprland waybar wofi foot dunst
# Configure manually, no display manager needed
```

**i3 (Tiling WM):**
```bash
sudo pacman -S i3-wm i3status i3lock dmenu xorg-server xorg-xinit
```

### Essential Software

```bash
# Terminal and shell
sudo pacman -S alacritty wezterm zsh starship tmux

# File management
sudo pacman -S thunar ranger nnn

# Browser
sudo pacman -S firefox chromium

# Media
sudo pacman -S vlc mpv

# Office
sudo pacman -S libreoffice-fresh

# Development
sudo pacman -S git base-devel cmake python python-pip nodejs npm go rust

# Utilities
sudo pacman -S htop btop neofetch fzf ripgrep fd bat exa tree
sudo pacman -S zip unzip p7zip unrar
sudo pacman -S wget curl rsync
```

### Fonts

```bash
sudo pacman -S \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji \
    ttf-jetbrains-mono-nerd \
    ttf-fira-code \
    ttf-roboto
```

### Audio

```bash
# PipeWire (recommended)
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
systemctl --user enable pipewire pipewire-pulse wireplumber

# GUI control
sudo pacman -S pavucontrol
```

### Bluetooth

```bash
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable bluetooth
```

### Printing

```bash
sudo pacman -S cups cups-pdf
sudo systemctl enable cups
```

---

## 8. Package Management

### Pacman Basics

```bash
# Sync database and upgrade
sudo pacman -Syu

# Install package
sudo pacman -S package_name

# Install multiple
sudo pacman -S pkg1 pkg2 pkg3

# Remove package
sudo pacman -R package_name

# Remove with dependencies (not required by others)
sudo pacman -Rs package_name

# Remove with dependencies and config files
sudo pacman -Rns package_name

# Search remote
pacman -Ss search_term

# Search installed
pacman -Qs search_term

# Info about package
pacman -Si package_name    # remote
pacman -Qi package_name    # installed

# List files owned by package
pacman -Ql package_name

# Find which package owns a file
pacman -Qo /path/to/file

# List explicitly installed packages
pacman -Qe

# List orphaned packages
pacman -Qdt

# Remove orphans
sudo pacman -Rns $(pacman -Qdtq)

# Clear package cache (keep 3 versions)
sudo paccache -r

# Clear all cache
sudo pacman -Scc
```

### Pacman Configuration

```bash
# Edit config
sudo vim /etc/pacman.conf

# Useful options to uncomment/add:
Color
ParallelDownloads = 5
ILoveCandy            # Fun progress bar

# Enable multilib (32-bit packages)
[multilib]
Include = /etc/pacman.d/mirrorlist
```

### Mirror Management

```bash
# Install reflector
sudo pacman -S reflector

# Find fastest mirrors
sudo reflector --country Austria,Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Enable weekly mirror update
sudo systemctl enable reflector.timer
```

---

## 9. AUR (Arch User Repository)

### Manual AUR Installation

```bash
# Clone package
git clone https://aur.archlinux.org/package-name.git
cd package-name

# Review PKGBUILD (IMPORTANT!)
less PKGBUILD

# Build and install
makepkg -si
```

### AUR Helpers

**yay (Yet Another Yogurt):**
```bash
# Install yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Usage (same as pacman)
yay -S package-name      # Install from AUR or official repos
yay -Syu                 # Update all (including AUR)
yay -Ss search-term      # Search
yay -Rns package-name    # Remove
yay                      # Interactive update
```

**paru (Rust-based):**
```bash
# Install paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Usage similar to yay
paru -S package-name
```

### AUR Best Practices

1. **Always review PKGBUILD** before building
2. **Check package comments** on AUR website
3. **Update AUR packages regularly** (they can break)
4. **Use -Rns to remove** (clean uninstall)
5. **Don't run makepkg as root**

---

## 10. System Maintenance

### Regular Updates

```bash
# Full system upgrade
sudo pacman -Syu

# With AUR
yay -Syu

# Check for .pacnew files (config changes)
sudo pacdiff
# Or: sudo DIFFPROG=vimdiff pacdiff
```

### Clean Package Cache

```bash
# Install paccache
sudo pacman -S pacman-contrib

# Keep last 3 versions
sudo paccache -r

# Keep only installed versions
sudo paccache -ruk0

# Automate with timer
sudo systemctl enable paccache.timer
```

### Check System Health

```bash
# Failed systemd services
systemctl --failed

# Journal errors
journalctl -p 3 -xb

# Disk usage
df -h
du -sh /* 2>/dev/null | sort -h

# Find large files
find / -type f -size +100M 2>/dev/null

# Check for broken symlinks
find / -xtype l 2>/dev/null
```

### Backup

```bash
# List explicitly installed packages
pacman -Qeq > ~/pkglist.txt

# Restore packages
sudo pacman -S --needed - < ~/pkglist.txt

# AUR packages
pacman -Qmq > ~/aurlist.txt

# System backup with rsync
sudo rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /backup/

# Btrfs snapshots
sudo btrfs subvolume snapshot -r / /.snapshots/$(date +%Y%m%d)
```

### Timeshift (Automated Snapshots)

```bash
yay -S timeshift

# Configure via GUI or:
sudo timeshift --create --comments "Before update"
sudo timeshift --list
sudo timeshift --restore
```

---

## 11. Permissions & Users

### User Management

```bash
# Add user
sudo useradd -m -G wheel,audio,video,storage -s /bin/zsh username

# Delete user
sudo userdel -r username

# Modify user
sudo usermod -aG groupname username    # Add to group
sudo usermod -s /bin/zsh username      # Change shell

# List groups
groups username

# Change password
passwd                    # Own password
sudo passwd username      # Other user
```

### Group Management

```bash
# Create group
sudo groupadd groupname

# Delete group
sudo groupdel groupname

# Add user to group
sudo gpasswd -a username groupname

# Remove user from group
sudo gpasswd -d username groupname

# List all groups
cat /etc/group

# Important groups:
# wheel    - sudo access
# audio    - audio devices
# video    - video devices
# storage  - removable storage
# network  - network management
# docker   - Docker access
# libvirt  - VM management
```

### File Permissions

```bash
# View permissions
ls -la

# Permission format: drwxrwxrwx
# d = directory (- for file)
# rwx = owner (read, write, execute)
# rwx = group
# rwx = others

# Change permissions
chmod 755 file        # rwxr-xr-x
chmod 644 file        # rw-r--r--
chmod u+x file        # Add execute for owner
chmod g-w file        # Remove write for group
chmod o-rwx file      # Remove all for others
chmod -R 755 dir/     # Recursive

# Common patterns:
# 755 - Directories, executables
# 644 - Regular files
# 600 - Private files
# 700 - Private directories

# Change owner
sudo chown user:group file
sudo chown -R user:group dir/

# Change group
sudo chgrp groupname file
```

### ACLs (Access Control Lists)

```bash
# Install acl tools
sudo pacman -S acl

# View ACLs
getfacl file

# Set ACL
setfacl -m u:username:rwx file        # User permission
setfacl -m g:groupname:rx file        # Group permission
setfacl -m d:u:username:rwx dir/      # Default for new files

# Remove ACL
setfacl -x u:username file

# Remove all ACLs
setfacl -b file
```

### sudo Configuration

```bash
# Edit sudoers (ALWAYS use visudo)
sudo EDITOR=vim visudo

# Allow wheel group
%wheel ALL=(ALL:ALL) ALL

# Allow without password (convenient but less secure)
%wheel ALL=(ALL:ALL) NOPASSWD: ALL

# Allow specific commands without password
username ALL=(ALL) NOPASSWD: /usr/bin/pacman -Syu

# Increase sudo timeout (default 5 min)
Defaults timestamp_timeout=30

# Keep environment variables
Defaults env_keep += "HOME"
```

### polkit (PolicyKit)

```bash
# Used for fine-grained permissions (e.g., mounting drives)
# Rules in /etc/polkit-1/rules.d/

# Example: Allow wheel group to mount without password
# /etc/polkit-1/rules.d/50-udisks.rules
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
         action.id == "org.freedesktop.udisks2.filesystem-mount") &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
```

### Common Permission Issues

**"Permission denied" for scripts:**
```bash
chmod +x script.sh
```

**Can't access USB drive:**
```bash
# Add user to storage group
sudo usermod -aG storage $USER
# Log out and back in

# Or mount manually
sudo mount /dev/sdb1 /mnt/usb
```

**Docker permission denied:**
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

**Can't modify files in /opt or /usr/local:**
```bash
# Change ownership
sudo chown -R $USER:$USER /opt/myapp

# Or use proper group
sudo chgrp -R wheel /opt/myapp
sudo chmod -R g+w /opt/myapp
```

**Broken permissions after chroot:**
```bash
# Reset home directory permissions
sudo chown -R $USER:$USER ~
chmod 700 ~
chmod 755 ~/
```

---

## 12. Systemd Services

### Service Management

```bash
# Start service
sudo systemctl start service

# Stop service
sudo systemctl stop service

# Restart service
sudo systemctl restart service

# Reload config (without restart)
sudo systemctl reload service

# Enable at boot
sudo systemctl enable service

# Disable at boot
sudo systemctl disable service

# Enable and start
sudo systemctl enable --now service

# Check status
systemctl status service

# List all services
systemctl list-units --type=service

# List enabled services
systemctl list-unit-files --state=enabled

# List failed services
systemctl --failed
```

### User Services

```bash
# User services (no sudo)
systemctl --user start service
systemctl --user enable service
systemctl --user status service

# Example: Enable PipeWire
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Timers (Cron Alternative)

```bash
# List timers
systemctl list-timers

# Example: Create a timer
# /etc/systemd/system/backup.service
[Unit]
Description=Daily backup

[Service]
Type=oneshot
ExecStart=/home/user/scripts/backup.sh

# /etc/systemd/system/backup.timer
[Unit]
Description=Run backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target

# Enable timer
sudo systemctl enable --now backup.timer
```

### Journalctl (Logs)

```bash
# View logs
journalctl

# Follow live
journalctl -f

# Since boot
journalctl -b

# Previous boot
journalctl -b -1

# Specific service
journalctl -u service

# Priority (errors only)
journalctl -p err

# Time range
journalctl --since "2024-01-01" --until "2024-01-02"
journalctl --since "1 hour ago"

# Disk usage
journalctl --disk-usage

# Vacuum (clean old logs)
sudo journalctl --vacuum-time=2weeks
sudo journalctl --vacuum-size=500M
```

---

## 13. Networking

### NetworkManager

```bash
# Status
nmcli general status

# List connections
nmcli connection show

# List WiFi networks
nmcli device wifi list

# Connect to WiFi
nmcli device wifi connect "SSID" password "password"

# Disconnect
nmcli device disconnect wlan0

# Create new connection
nmcli connection add type wifi con-name "MyWifi" ssid "SSID"
nmcli connection modify "MyWifi" wifi-sec.key-mgmt wpa-psk
nmcli connection modify "MyWifi" wifi-sec.psk "password"
nmcli connection up "MyWifi"

# Static IP
nmcli connection modify "MyConnection" \
    ipv4.method manual \
    ipv4.addresses "192.168.1.100/24" \
    ipv4.gateway "192.168.1.1" \
    ipv4.dns "8.8.8.8,8.8.4.4"

# Interactive TUI
nmtui
```

### Firewall (firewalld)

```bash
sudo pacman -S firewalld
sudo systemctl enable --now firewalld

# Check status
sudo firewall-cmd --state

# List zones
sudo firewall-cmd --get-zones

# Current zone
sudo firewall-cmd --get-active-zones

# List services
sudo firewall-cmd --list-services

# Add service
sudo firewall-cmd --add-service=ssh --permanent
sudo firewall-cmd --add-port=8080/tcp --permanent

# Reload
sudo firewall-cmd --reload
```

### UFW (Simpler Alternative)

```bash
sudo pacman -S ufw
sudo systemctl enable --now ufw

# Enable
sudo ufw enable

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow ssh
sudo ufw allow 22

# Status
sudo ufw status verbose
```

### SSH

```bash
# Generate key
ssh-keygen -t ed25519 -C "email@example.com"

# Copy key to server
ssh-copy-id user@server

# Config file ~/.ssh/config
Host myserver
    HostName 192.168.1.100
    User username
    IdentityFile ~/.ssh/id_ed25519

# Then just: ssh myserver

# SSHD server config: /etc/ssh/sshd_config
# Recommended changes:
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

---

## 14. Storage & Filesystems

### Disk Information

```bash
# List block devices
lsblk
lsblk -f    # With filesystems

# Detailed info
fdisk -l
blkid

# Disk usage
df -h
df -Th    # With filesystem type

# Directory size
du -sh /path
du -sh /* | sort -h
ncdu /    # Interactive
```

### Mount/Unmount

```bash
# Mount
sudo mount /dev/sdb1 /mnt/usb
sudo mount -t ntfs-3g /dev/sdb1 /mnt/windows

# Mount with options
sudo mount -o rw,uid=1000,gid=1000 /dev/sdb1 /mnt/usb

# Unmount
sudo umount /mnt/usb
# If busy:
sudo umount -l /mnt/usb    # Lazy unmount
sudo fuser -mv /mnt/usb    # Show what's using it

# Remount (change options)
sudo mount -o remount,rw /
```

### fstab

```bash
# Edit /etc/fstab for persistent mounts
sudo vim /etc/fstab

# Format: <device> <mount_point> <type> <options> <dump> <pass>
UUID=xxxx-xxxx /home ext4 defaults 0 2
/dev/sdb1 /mnt/data ntfs-3g uid=1000,gid=1000,dmask=022,fmask=133 0 0

# Get UUID
blkid /dev/sdb1

# Test fstab (don't reboot with broken fstab!)
sudo mount -a
```

### SMART Monitoring

```bash
sudo pacman -S smartmontools

# Check disk health
sudo smartctl -a /dev/sda

# Quick test
sudo smartctl -t short /dev/sda

# Long test
sudo smartctl -t long /dev/sda

# View results
sudo smartctl -l selftest /dev/sda
```

### LVM (Logical Volume Manager)

```bash
# Create physical volume
sudo pvcreate /dev/sdb

# Create volume group
sudo vgcreate myvg /dev/sdb

# Create logical volume
sudo lvcreate -L 50G -n mylv myvg

# Format and mount
sudo mkfs.ext4 /dev/myvg/mylv
sudo mount /dev/myvg/mylv /mnt/data

# Extend volume
sudo lvextend -L +10G /dev/myvg/mylv
sudo resize2fs /dev/myvg/mylv
```

### RAID (mdadm)

```bash
sudo pacman -S mdadm

# Create RAID1 (mirror)
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc

# View status
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Save config
sudo mdadm --detail --scan >> /etc/mdadm.conf
```

---

## 15. Security

### Firewall

See [Networking section](#13-networking) for firewalld/UFW.

### Fail2ban (Brute Force Protection)

```bash
sudo pacman -S fail2ban
sudo systemctl enable --now fail2ban

# Config: /etc/fail2ban/jail.local
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true

# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

### AppArmor

```bash
sudo pacman -S apparmor
sudo systemctl enable --now apparmor

# Add to kernel params (GRUB)
# /etc/default/grub
GRUB_CMDLINE_LINUX="apparmor=1 security=apparmor"
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Status
sudo aa-status
```

### Encryption (LUKS)

```bash
# Encrypt partition
sudo cryptsetup luksFormat /dev/sda2

# Open encrypted partition
sudo cryptsetup open /dev/sda2 cryptroot

# Format and mount
sudo mkfs.ext4 /dev/mapper/cryptroot
sudo mount /dev/mapper/cryptroot /mnt

# Close
sudo cryptsetup close cryptroot

# For boot, add 'encrypt' hook to mkinitcpio.conf
# And kernel param: cryptdevice=UUID=xxx:cryptroot root=/dev/mapper/cryptroot
```

### SSH Hardening

```bash
# /etc/ssh/sshd_config
Port 2222                          # Non-standard port
PermitRootLogin no                 # No root login
PasswordAuthentication no          # Keys only
MaxAuthTries 3
AllowUsers myuser                  # Whitelist users
Protocol 2

sudo systemctl restart sshd
```

---

## 16. Troubleshooting

### System Won't Boot

```bash
# Boot from live USB
# Mount your system
mount /dev/nvme0n1p3 /mnt
mount /dev/nvme0n1p1 /mnt/boot/efi

# Chroot
arch-chroot /mnt

# Fix GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Or fix systemd-boot
bootctl install

# Regenerate initramfs
mkinitcpio -P

# Check fstab
cat /etc/fstab
```

### Broken Package

```bash
# Force reinstall
sudo pacman -S package --overwrite '*'

# Downgrade
# Install downgrade tool
yay -S downgrade
sudo downgrade package

# From cache
sudo pacman -U /var/cache/pacman/pkg/package-version.pkg.tar.zst
```

### Keyring Issues

```bash
# Initialize keyring
sudo pacman-key --init
sudo pacman-key --populate archlinux

# Refresh keys
sudo pacman-key --refresh-keys

# If still failing
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
```

### "Unable to lock database"

```bash
# Remove lock file
sudo rm /var/lib/pacman/db.lck

# If running process
ps aux | grep pacman
sudo kill <pid>
```

### Graphics Issues

```bash
# Boot with nomodeset
# In GRUB, press 'e' and add to linux line:
nomodeset

# Reinstall drivers
sudo pacman -S nvidia nvidia-utils    # NVIDIA
sudo pacman -S xf86-video-amdgpu      # AMD
sudo pacman -S xf86-video-intel       # Intel

# Check Xorg logs
cat /var/log/Xorg.0.log | grep EE
```

### No Sound

```bash
# Check PipeWire
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart audio
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check devices
wpctl status
pactl info

# Unmute
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
amixer sset Master unmute
```

### Network Not Working

```bash
# Check interface
ip link

# Bring interface up
sudo ip link set wlan0 up

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check DNS
cat /etc/resolv.conf
# Add if empty:
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### Read-Only Filesystem

```bash
# Usually indicates disk errors
# Remount as read-write
sudo mount -o remount,rw /

# Check filesystem (unmount first if possible)
sudo fsck /dev/nvme0n1p3

# If root, boot from live USB and:
fsck /dev/nvme0n1p3
```

---

## 17. Edge Cases & Gotchas

### Partial Upgrades Break Things

```bash
# NEVER do this:
sudo pacman -Sy package    # Syncs DB but doesn't upgrade

# ALWAYS do full upgrade:
sudo pacman -Syu package

# Or sync first, then install
sudo pacman -Syu
sudo pacman -S package
```

### .pacnew and .pacsave Files

```bash
# After updates, config files may have .pacnew versions
# Find them:
find /etc -name "*.pacnew" 2>/dev/null
pacdiff

# Compare and merge
sudo vimdiff /etc/file /etc/file.pacnew

# Or use pacdiff
sudo DIFFPROG=vimdiff pacdiff
```

### Kernel Panic After Update

```bash
# Boot from live USB
mount /dev/nvme0n1p3 /mnt
arch-chroot /mnt

# Install LTS kernel as backup
pacman -S linux-lts linux-lts-headers

# Update bootloader
grub-mkconfig -o /boot/grub/grub.cfg
```

### Time Issues (Dual Boot with Windows)

```bash
# Windows uses local time, Linux uses UTC
# Option 1: Set Linux to local time (not recommended)
timedatectl set-local-rtc 1

# Option 2: Set Windows to UTC (recommended)
# In Windows Registry:
# HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation
# Add DWORD: RealTimeIsUniversal = 1
```

### NVIDIA Optimus (Laptop Hybrid Graphics)

```bash
# Install optimus-manager
yay -S optimus-manager optimus-manager-qt

# Or use envycontrol
yay -S envycontrol

# Switch modes
sudo envycontrol -s integrated    # Battery saving
sudo envycontrol -s hybrid        # Use both
sudo envycontrol -s nvidia        # Performance
```

### Secure Boot

```bash
# Option 1: Disable in BIOS (easiest)

# Option 2: Sign bootloader
# Install sbctl
yay -S sbctl

# Check status
sbctl status

# Create keys
sudo sbctl create-keys

# Enroll keys
sudo sbctl enroll-keys

# Sign bootloader and kernel
sudo sbctl sign -s /boot/EFI/GRUB/grubx64.efi
sudo sbctl sign -s /boot/vmlinuz-linux
```

### Broken sudo

```bash
# If you break sudoers and can't sudo:
# Boot single-user mode (add 'single' to kernel params)
# Or boot from live USB and chroot

# Fix sudoers
pkexec visudo    # If pkexec works
# Or
su -c "visudo"   # If you know root password
```

### Full Disk

```bash
# Find large files
sudo du -sh /* | sort -h
sudo ncdu /

# Clear package cache
sudo paccache -rk1      # Keep only 1 version
sudo pacman -Scc        # Remove all cache

# Clear journal logs
sudo journalctl --vacuum-size=100M

# Find and remove old kernels
pacman -Q | grep linux
sudo pacman -Rns linux-old-version

# Clear trash
rm -rf ~/.local/share/Trash/*
```

### Won't Shutdown/Reboot

```bash
# Check what's blocking
systemctl list-jobs

# Force stop stuck service
sudo systemctl stop stuck-service --force

# Force immediate shutdown
sudo systemctl poweroff --force --force

# Or:
echo b | sudo tee /proc/sysrq-trigger    # Reboot
echo o | sudo tee /proc/sysrq-trigger    # Power off
```

---

## 18. Essential Commands Cheatsheet

### System Info
```bash
uname -a                    # Kernel info
hostnamectl                 # System info
lscpu                       # CPU info
lsmem                       # Memory info
lsblk                       # Block devices
lspci                       # PCI devices
lsusb                       # USB devices
inxi -Fxz                   # Detailed system info
neofetch                    # Pretty system info
```

### Package Management
```bash
sudo pacman -Syu            # Full system upgrade
sudo pacman -S pkg          # Install
sudo pacman -Rns pkg        # Remove completely
pacman -Ss term             # Search
pacman -Qi pkg              # Info
pacman -Ql pkg              # List files
pacman -Qo /path            # Find owner
yay -Syu                    # Upgrade + AUR
```

### Services
```bash
systemctl status service    # Status
sudo systemctl start srv    # Start
sudo systemctl enable srv   # Enable at boot
systemctl --failed          # Failed services
journalctl -u service       # Service logs
```

### Files & Permissions
```bash
chmod 755 file              # Set permissions
chown user:group file       # Change owner
ls -la                      # List with permissions
find / -name "file"         # Find file
locate file                 # Fast find (updatedb first)
```

### Disk
```bash
df -h                       # Disk usage
du -sh dir/                 # Directory size
mount /dev/sdb1 /mnt        # Mount
umount /mnt                 # Unmount
sudo fdisk -l               # Partition info
```

### Network
```bash
ip addr                     # IP addresses
nmcli device wifi list      # WiFi networks
nmcli d wifi connect SSID   # Connect WiFi
ping host                   # Test connection
ss -tulpn                   # Open ports
```

### Process Management
```bash
htop                        # Interactive process viewer
ps aux                      # All processes
kill PID                    # Kill process
killall name                # Kill by name
top -bn1                    # Resource usage
```

### Logs
```bash
journalctl -b               # This boot
journalctl -f               # Follow live
journalctl -p err           # Errors only
dmesg                       # Kernel messages
```

### Recovery
```bash
# Chroot from live USB:
mount /dev/nvme0n1p3 /mnt
mount /dev/nvme0n1p1 /mnt/boot/efi
arch-chroot /mnt
```

---

## Resources

- **Arch Wiki**: https://wiki.archlinux.org (The Bible)
- **Arch Forums**: https://bbs.archlinux.org
- **AUR**: https://aur.archlinux.org
- **Arch Subreddit**: https://reddit.com/r/archlinux

---

*"Arch Linux: Because you wanted to understand how your system works."*
