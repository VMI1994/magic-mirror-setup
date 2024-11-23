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

# Dependencies
apps="python3 python3-pip libffi-dev nginx-full neofetch cec-utils ca-certificates curl gnupg"


# Introduction
clear
echo "This script will create a magic mirror instance on this server but first"
echo "we will install dependencies"
sleep 2
sudo apt update
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

# installs nvm (Node Version Manager)
clear
echo "We will now install NodeJS Version Manager"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
sleep 2
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
sleep 2
clear
echo "A reboot is required to continue"
echo "After reboot run mm-setup2.sh"
echo "Press Enter to reboot"
read junk
sudo reboot now &
exit


# Install node.js
# download and install Node.js (you may need to restart the terminal)
clear
echo "We will now install NodeJS"
nvm install 22

# Install npm
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
npm run install-mm
clear
echo "MagicMirror has been installed"
sleep 2


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
npm install pm2@latest -g
sleep 2
cmd=$(pm2 startup | grep sudo)
echo $cmd | bash



# Setup will now delete the install files and exit
clear
echo "Setup is complete, setup files will be deleted"
echo
sleep 2
cd ~
pm2 start mm.sh
pm2 info mm
pm2 save
rm -rf magic-mirror-setup &
sleep 2
pm2 stop mm
clear
echo 'MagicMirror is located at http://your-server-ip:8080'
echo
sleep 2
echo 'System will reboot in 10 seconds.  Press ctrl+c to stop'
sleep 10
sudo reboot now &
exit
