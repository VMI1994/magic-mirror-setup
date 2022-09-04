#!/bin/bash
clear
neofetch
sleep 1
echo; echo
load1=$(uptime | cut -d " " -f12 | cut -d "," -f1)
load5=$(uptime | cut -d " " -f13 | cut -d "," -f1)
load15=$(uptime | cut -d " " -f14 | cut -d "," -f1)
load1=$(echo $load1*100 | bc -l) 
load1=$(echo $load1/4 | bc -l | cut -d "." -f1)
load5=$(echo $load5*100 | bc -l)
load5=$(echo $load5/4 | bc -l | cut -d "." -f1)
load15=$(echo $load15*100 | bc -l)
load15=$(echo $load15/4 | bc -l | cut -d "." -f1)
echo "1 min load is $load1 %"
echo
echo "5 min load is $load5 %"
echo
echo "15 min load is $load15 %"
sleep 1
echo; echo
temp_c="$(vcgencmd measure_temp | cut -d"=" -f2 | cut -d "'" -f1)"
echo "CPU Temp is $temp_c Celsius"
echo; echo
temp_f=$(echo "($temp_c*(9/5)+32)" | bc -l)
temp_f=$(printf %.1f $temp_f)
echo "CPU Temp is $temp_f Farenheit"
exit

