# SEA-ME_Instrument-Cluster
Build a vehicle instrument cluster using QT and CAN communication

**Rasberry pi config**

**using command to connect Rasberry pi**

dmesg | grep -i spi # check can hat
sudo ip link set can1 up type can bitrate 500000 #ready to communicate can1
candump can1 # recieve signals
sudo ip link set can1 down # turn off can1

to enter virtual environment
source ~/env_tf1/bin/activate # active
deactivate #exit


Arduino code

Qt framework
