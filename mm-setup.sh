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

# Install MagicMirror
clear
echo "Cloning MagicMirror into directory"
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
cd ~/MagicMirror/modules
git clone https://github.com/SaltyRiver/MMM-SimpleText.git
cp ~/magic-mirror-setup/mm.kiosk ~/mm.sh
cp ~/magic-mirror-setup/config1.js ~/MagicMirror/config/config.js
cd ~
sudo chmod +x mm.sh
pm2 start mm.sh
pm2 save
sleep 10
pm2 stop mm



# Kiosk or Server mode
clear
echo "Do you want to install in kiosk mode(y/N)?"
read kiosk
if [ $kiosk == "y" ]
then
  cp ~/magic-mirror-setup/mm.kiosk ~/mm.sh
  sudo chmod +x ~/mm.sh
else
  cp ~/magic-mirror-setup/mm.server ~/mm.sh
  sudo chmod +x ~/mm.sh
  echo "Your MagicMirror will be available at http://127.0.0.1:8080 when install is completed"
  pause
fi
clear
echo "PM2 will autostart at boot and restart after any crashes"
pause


# Add bash aliases to control magicmirror
cp ~/magic-mirror-setup/help.txt ~/MagicMirror/help.txt
cat ~/MagicMirror/help.txt >> ~/.bashrc


# Download Modules
echo "Downloag MagicMirror Modules"
cd ~/MagicMirror/modules
git clone https://github.com/edward-shen/MMM-pages.git
git clone https://github.com/edward-shen/MMM-page-indicator.git
git clone https://github.com/slametps/MMM-NetworkConnection.git
git clone https://github.com/fpfuetsch/MMM-GitHub-Monitor.git


# Install Modules
clear
echo "Installing Magicmirror modules"
pause
cd ~/MagicMirror/modules/MMM-pages
npm install $$ npm audit fix
cd ~/MagicMirror/modules/MMM-page-indicator
npm install $$ npm audit fix
cd ~/MagicMirror/modules/MMM-GitHub-Monitor
npm install $$ npm audit fix
echo "modules installed"
cp ~/magic-mirror-setup/config.js ~/MagicMirror/config/config.js
cd ~
pm2 restart mm


# Activate Aliases before cleaning up(Used separate script as the command will halt this script
bash ~/magic-mirror-setup/alias.sh &



# Setup will now delete the install files and exit
clear
echo "Setup is complete, setup files will be deleted"
echo
echo "If you selected server mode, your magicmirror will be located at http://YOUR_SERVER_IP:8080"
pause
cd ~
#sleep 5 && rm -rf magic-mirror-setup
exit
