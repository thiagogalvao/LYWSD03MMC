# LYWSD03MMC
This script was made using typical Linux applications to get Temperature and Humidify data from Xiaomi Mijia Bluetooth Temperature humidity version 2 a.k.a. **LYWSD03MMC**

This script is a modification from the original version with support to use mosquitto_pub to send data over MQTT to a broker.
Thanks to the author.

Reference: http://www.d0wn.com/using-bash-and-gatttool-to-get-readings-from-xiaomi-mijia-lywsd03mmc-temperature-humidity-sensor/

This version works fine in a Raspberry Pi 3+.

Use crontab to scheduler an execution every minute.

# Dependences (often resolved with apt install):
  - gatttool (to work with BLE)
  - awk
  - bc
  - mosquitto_pub


# Configuration
Use the command below to find the device mac address 

```
sudo hcitool lescan
```

# Installation

Grant execution permissions
```
chmod +x readSensor.sh
``` 
running..
```
./readSensor.sh
```


![Xiaomi Mijia Bluetooth Temperature humidity version 2](https://raw.githubusercontent.com/thiagogalvao/LYWSD03MMC/master/LYWSD03MMC-Device.jpg)


# Troubleshoot
Sometimes the devices get blocked. Try to reset the Bluetooth interface with the following commands:
```
sudo hciconfig hci0 down

sudo hciconfig hci0 up
```
