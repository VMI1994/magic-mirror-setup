#!/bin/bash

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
npm run install-mm
clear
echo "MagicMirror has been installed"


# Kiosk mode
cp ~/magic-mirror-setup/mm.kiosk ~/mm.sh
sudo chmod +x ~/mm.sh

# Download Modules
clear
echo "Downloading MagicMirror Modules"
cd ~/MagicMirror/modules
git clone https://github.com/edward-shen/MMM-pages.git
git clone https://github.com/edward-shen/MMM-page-indicator.git
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
cd ~/magic-mirror-setup/scriptserver
cp *.sh ~/
chmod +x ~/*.sh

clear
echo "PM2 Process manager will now be installed"
echo "PM2 will autostart at boot and restart after any crashes"
sleep 2
npm install pm2 -g
sleep 2
cmd=$(pm2 startup | grep sudo)
echo $cmd | bash
pause ()


# Setup will now delete the install files and exit
clear
echo "Setup is complete, setup files will be deleted"
echo
sleep 2
cd ~
pm2 start mm.sh
pm2 info mm
sleep 2
pm2 save
rm -rf magic-mirror-setup &
sleep 2
clear
echo 'MagicMirror is located at http://your-server-ip:8080'
cd ~
exit

