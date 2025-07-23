# SEA-ME_Instrument-Cluster
Build a vehicle instrument cluster using QT and CAN communication

**Rasberry pi config**

**using command to connect Rasberry pi**

dmesg | grep -i spi # check can hat> This is a blockqute
sudo ip link set can1 up type can bitrate 500000 #ready to communicate can1> This is a blockqute
candump can1 # recieve signals> This is a blockqute
sudo ip link set can1 down # turn off can1> This is a blockqute

to enter virtual environment> This is a blockqute
source ~/env_tf1/bin/activate # active> This is a blockqute
deactivate #exit> This is a blockqute


Arduino code

Qt framework
