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
apps="python3 python3-pip libffi-dev nginx-full neofetch cec-utils ca-certificates curl gnupg"


# Introduction
clear
echo "This script will create a magic mirror instance on this server but first"
echo "we will install dependencies"
sleep 2
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
sleep 2
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install -y nodejs
sudo apt install -y npm


# Install MagicMirror
clear
echo "Cloning MagicMirror into directory"
sleep 2
cd ~
git clone https://github.com/MichMich/MagicMirror
cd MagicMirror/
clear
echo "Installing MagicMirror - this process may take"
echo "up to 30 minutes to complete.  Do not press"
echo "any keys until prompted to"
sleep 2
npm install --only=prod --omit=dev
clear
echo "MagicMirror has been installed"
sleep 2

# Install and enable PM2 process manager
clear
echo "PM2 Process manager will now be installed"
sleep 2
sudo npm install -g pm2
cmd=$(pm2 startup | grep sudo)
sudo $cmd


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
sleep 2


# Download Modules
clear
echo "Downloading MagicMirror Modules"
cd ~/MagicMirror/modules
git clone https://github.com/edward-shen/MMM-pages.git
git clone https://github.com/edward-shen/MMM-page-indicator.git
git clone https://github.com/slametps/MMM-NetworkConnection.git
git clone https://github.com/fpfuetsch/MMM-GitHub-Monitor.git
git clone https://github.com/jclarke0000/MMM-MyScoreboard.git
git clone https://github.com/cowboysdude/MMM-Nascar.git
git clone https://github.com/vincep5/MMM-MyStandings.git
git clone https://github.com/AgP42/MMM-SmartWebDisplay.git



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
cd ~/MagicMirror/modules/MMM-NetworkConnection
npm install
cd ~/MagicMirror/modules/MMM-MyScoreboard
npm install
cd ~/MagicMirror/modules/MMM-Nascar
npm install
cd ~/MagicMirror/modules/MMM-MyStandings
npm install
cd ~/MagicMirror/modules/MMM-SmartWebDisplay
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
cd ~/script-server
pip3 install -r requirements.txt
python3 ~/script-server/tools/init.py --no-npm
cd ~/magic-mirror-setup/scriptserver
cp *.sh ~/
chmod +x ~/*.sh
cp *.json ~/script-server/conf/runners
rm ~/script-server/conf/runners/conf.json
cp conf.json ~/script-server/conf
cp control.sh ~/
sudo chmod +x ~/control.sh




# Setup will now delete the install files and exit
clear
echo "Setup is complete, setup files will be deleted"
echo
sleep 2
cd ~
pm2 start mm.sh
pm2 info mm
pm2 start control.sh
pm2 info control
pm2 save
rm -rf magic-mirror-setup &
sleep 2
clear
echo 'MagicMirror is located at http://your-server-ip:8080'
echo
echo
echo 'Control server is located at http://your-server-ip:5000'
sleep 2
echo 'System will now reboot'
sudo reboot now &
exit
