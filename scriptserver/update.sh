#!/bin/bash
clear
echo "stopping MagicMirror"
~/stop.sh
clear
echo "starting update"
sudo apt update
clear
echo "starting upgrade"
sudo apt upgrade -y
clear
echo "restarting MagicMirror"
~/start.sh
exit

