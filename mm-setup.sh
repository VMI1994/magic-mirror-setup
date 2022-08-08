#!/bin/bash


# functions
pause() {
echo
echo
echo "Press Enter to continue"
read junk
}


# Dependencies
apps="curl git"


# Introduction
clear
echo "This script will create a magic mirror instance on this server but first"
echo "we will install dependencies"
pause
sudo apt install $apps

# Offer optional server setup before magic mirror install
clear
echo "would you like to secure and update the server before"
echo "installing magic mirror(y/N)?"
read choice
if [ $choice == "y" ]
then
  cd ~
  sudo apt install git
  git clone https://github.com/VMI1994/linux-setup.git
  bash ~/linux-setup/setup.sh
else
  clear
  echo "magic mirror installation will now begin"
  pause
fi


# Install magic mirror


# Install node.js
echo "We will now install node.js"
pause
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Install Magicmirror
clear
echo "Cloning Magicmirror into directory"
pause
cd ~
git clone https://github.com/MichMich/MagicMirror
cd MagicMirror/
clear
echo "Installing MagicMirror - this process may take"
echo "up to 30 minutes to complete.  Do not press"
echo "any keys until prompted to"
pause
npm install --only=prod --omit=dev
npm audit fix
clear
echo "MagicMirror has been installed"
pause

# Install and enable PM2 process manager
clear
echo "PM2 Process manager will now be installed"
pause
sudo npm install -g pm2
cmd=$(pm2 startup | grep sudo)
sudo $cmd
# Kiosk or Server mode
echo "Do you want to install in kiosk mode(y/N)?"
read kiosk
if [ $kiosk == "y" ]
then
  cp ~/magic-mirror-setup/mm.kiosk ~/mm.sh
else
  cp ~/magic-mirror-setup/mm.server ~/mm.sh
  echo "Your MagicMirror is available at http://127.0.0.1:8080
fi
cd ~
sudo chmod +x mm.sh
pm2 start mm.sh
pm2 save
clear
echo "PM2 will autostart at boot and restart after any crashes"
pause


# Add bash aliases to control magicmirror
cp ~/magic-mirror-setup/help.txt ~/Magicmirror/help.txt
cat ~/Magicmirror/help.txt >> ~/.bashrc


# Setup will no delete the install files and exit