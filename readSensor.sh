#!/bin/bash
# This script uses common linux applications to get Temperature e Humidify data from Xiaomi LYWSD03MMC sensor.
#
# This script is a modification from original version to use mosquitto_pub to send data over MQTT to a broker.
# Thanks to the author.
#
# Reference: http://www.d0wn.com/using-bash-and-gatttool-to-get-readings-from-xiaomi-mijia-lywsd03mmc-temperature-humidity-sensor/
#
# This version works fine in a Raspberry Pi 3+.
# Use crontab to scheduler an execution every minute.
#
# Dependences (often resolved with apt install):
# - gatttool (to work with BLE)
# - awk
# - bc
# - mosquitto_pub
#
# Use the command below to find the device mac address 
#    sudo hcitool lescan
#
# 

sensor_name="Sensor1"
mac_address="X1:CX:00:BF:9B:99"
mqtt_server="localhost"

bt=$(timeout 15 gatttool -b $mac_address --char-write-req --handle='0x0038' --value="0100" --listen)
if [ -z "$bt" ]
then
    echo "The reading failed"
else
    echo "Got data"
    #echo $bt 
    temphexa=$(echo $bt | awk -F ' ' '{print $12$11}'| tr [:lower:] [:upper:] )
    humhexa=$(echo $bt | awk -F ' ' '{print $13}'| tr [:lower:] [:upper:])
    temperature100=$(echo "ibase=16; $temphexa" | bc)
    humidity=$(echo "ibase=16; $humhexa" | bc)
    temperature=$(echo "scale=2;$temperature100/100"|bc)
    echo $temperature
    echo $humidity

    if [ ! ${#temperature} -ge 6 ] 
    then
       mosquitto_pub -h $mqtt_server -m $temperature -t /LYWSD03MMC/$sensor_name/Temperature -d
    fi

    if [ ! ${#humidity} -ge 6 ] 
    then
       mosquitto_pub -h $mqtt_server -m $humidity -t /LYWSD03MMC/$sensor_name/Humidity -d
    fi
fi
