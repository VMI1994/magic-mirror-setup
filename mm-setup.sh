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
apps="npm python3 python3-pip libffi-dev nginx-full neofetch cec-utils ca-certificates curl gnupg"


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
echo "After reboot login and type 'nvm install 22' "
echo "After NodeJS installs, run mm-setup2.sh"
echo "Press Enter to reboot"
read junk
sudo reboot now &
exit
