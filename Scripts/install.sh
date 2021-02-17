#!/bin/bash

sudo apt update && sudo apt upgrade

#copy dotfiles
cp -r .config ~ && cp .bashrc ~ && cp .xinitrc ~ && cp .Xdefaults ~ && echo "Config files copied"

#install consolas font
sudo cp -r Fonts/* /usr/share/fonts/
fc-cache -f -v

#common programs
sudo apt install transmission vim vlc ranger chromium rxvt-unicode cmus

#basic utility programs
sudo apt install blueman network-manager network-manager-gnome feh redshift xorg brightnessctl polybar pavucontrol powerline-fonts
	
#show-off programs
sudo apt install neofetch


mkdir ~/Github/

#tryone's 144 blur optimized compton
cd ~/Github
git clone https://github.com/tryone144/compton
cd compton
sudo apt install libx11-dev libxcomposite-dev libxdamage-dev libxfixes-dev libxext-dev libxrender-dev libxrandr-dev libxinerama-dev pkg-config build-essential x11proto-dev x11-utils libpcre++-dev libconfig-dev libdrm-dev libgl-dev libdbus-1-dev asciidoc
make
make docs
sudo make install

#i3 gaps from git (needed on debian)
cd ~/Github
git clone https://github.com/maestrogerardo/i3-gaps-deb
cd i3-gaps-deb
./i3-gaps-deb

#discord install
cd ~
wget https://discord.com/api/download?platform=linux&format=deb
sudo apt install discord-*.deb && rm discord-*.deb
