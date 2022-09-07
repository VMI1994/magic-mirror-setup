#!/bin/bash
clear
echo 'Magicmirror status'
pm2 info mm | grep status
echo
echo
echo 'TV Status'
bash ~/tvstatus.sh
exit

