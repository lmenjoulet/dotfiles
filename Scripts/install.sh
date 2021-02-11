#!/bin/bash

sudo apt update && sudo apt upgrade


#common programs
sudo apt install transmission vim vlc ranger firefox rxvt-unicode

#basic utility programs
sudo apt install blueman-applet nm-applet mate-volume-control-applet feh redshift

#show-off programs
sudo apt install neofetch

#tryone's 144 blur optimized compton
mkdir ~/Github/ && cd ~/Github
git clone https://github.com/tryone144/compton

#i3 gaps from git (needed on debian)
git clone https://github.com/Airblader/i3
