#!/bin/bash


# functions
pause() {
echo
echo
echo "Press Enter to continue"
read junk
}


# User Input first so script can run unattended
clear
echo "would you like to secure and update the server before"
echo "installing magic mirror(Y/n)?"
read choice
clear
echo "Do you want to install in kiosk mode(Y/n)?"
echo "kiosk shows MagicMirror on default display versus running web server only"
read kiosk

# Dependencies
apps="curl git python3 python3-pip libffi-dev nginx-full neofetch"


# Introduction
clear
echo "This script will create a magic mirror instance on this server but first"
echo "we will install dependencies"
sleep 5
sudo apt update
sudo apt dist-upgrade -y
sudo apt install $apps -y


# Offer optional server setup before magic mirror install
if [ $choice = "n" ]
then
  clear
  echo "magic mirror installation will now begin"
else
  cd ~
  git clone https://github.com/VMI1994/linux-setup.git
  bash ~/linux-setup/setup.sh
fi


# Install magic mirror


# Install node.js
echo "We will now install node.js"
sleep 5
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs


# Install MagicMirror
clear
echo "Cloning MagicMirror into directory"
sleep 5
cd ~
git clone https://github.com/MichMich/MagicMirror
cd MagicMirror/
clear
echo "Installing MagicMirror - this process may take"
echo "up to 30 minutes to complete.  Do not press"
echo "any keys until prompted to"
sleep 5
npm install --only=prod --omit=dev
clear
echo "MagicMirror has been installed"
sleep 5

# Install and enable PM2 process manager
clear
echo "PM2 Process manager will now be installed"
sleep 5
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
if [ $kiosk = "n" ]
then
  cp ~/magic-mirror-setup/mm.server ~/mm.sh
  sudo chmod +x ~/mm.sh
else
  cp ~/magic-mirror-setup/mm.kiosk ~/mm.sh
  sudo chmod +x ~/mm.sh
fi
clear
echo "PM2 will autostart at boot and restart after any crashes"
sleep 5



# Download Modules
clear
echo "Downloading MagicMirror Modules"
cd ~/MagicMirror/modules
git clone https://github.com/edward-shen/MMM-pages.git
git clone https://github.com/edward-shen/MMM-page-indicator.git
git clone https://github.com/slametps/MMM-NetworkConnection.git
git clone https://github.com/fpfuetsch/MMM-GitHub-Monitor.git


# Install Modules
clear
echo "Installing Magicmirror modules"
sleep 5
cd ~/MagicMirror/modules/MMM-pages
npm install
cd ~/MagicMirror/modules/MMM-page-indicator
npm install
cd ~/MagicMirror/modules/MMM-GitHub-Monitor
npm install
echo "modules installed"
cp ~/magic-mirror-setup/config.js ~/MagicMirror/config/config.js



# Activate Aliases before cleaning up(Used separate script as the command will halt this script
bash ~/magic-mirror-setup/alias.sh &


# Install https://github.com/bugy/script-server.git customized to control the magicmirror via bash scripts
clear
echo "installing script-server to control the MagicMirror"
cd ~
git clone https://github.com/bugy/script-server.git
cd ~/magic-mirror-setup/scriptserver
cp *.sh ~/
sudo chmod +x ~/*.sh
cp *.json ~/script-server/conf/runners
cp conf.json ~/script-server/conf
cp control.sh ~/script-server
sudo chmod +x ~/script-server/control.sh
pip3 install -r requirements.txt
pm2 start ~/script-server/control.sh
sleep 5
pm2 save
pm2 stop control


# Setup will now delete the install files and exit
clear
echo "Setup is complete, setup files will be deleted"
echo
sleep 5
cd ~
rm -rf magic-mirror-setup &
sleep 2
clear
echo 'MagicMirror is located at http://localhost:8080'
echo
echo
echo 'Control server is located at http://localhost:5000'
sleep 5
echo 'System will now reboot'
sudo reboot now &
sleep 5
exit
