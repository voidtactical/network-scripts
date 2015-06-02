# first connect to the device
# connect to it's access point from your laptop
# then connect with ssh to get shell access
ssh root@172.16.42.1

# show status of wireless interfaces
iwconfig

# bring wlan1 up
ifconfig wlan1 up

# check status of the link
# will report 'Not Connected'
iw dev wlan1 link

# scan for networks
iw dev wlan1 scan | less

# choose an SSID from scan output
# and connect to it
# replace [SSID] with your SSID
iw dev wlan1 connect -w [SSID]

# now get an IP address on wlan1
dhcpcd -k wlan1
dhcpcd wlan1

# you can check for an IP address with ifconfig
ifconfig wlan1

# now add the default gateway for internet access
# you may need to replace the ip 10.0.0.1 with the correct gateway
# you can figure out the gateway using the ifconfig wlan1 command
# the gateway is the ip address of the access point are connected to
route add default gw 10.0.0.1

# and now set up ip forwarwarding
iptables -X
iptables -F
iptables -A FORWARD -i wlan1 -o wlan0 -s 172.16.42.0/24 -m state --state NEW -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -j MASQUERADE


# we should be online
# test by pinging the gateway
# remember that 10.0.0.1 might not be the gateway for a given access point
ping 10.0.0.1

# test by pinging the internet
ping winterroot.net

# and finally
# open a new terminal on your laptop
# and ping winterroot.net

# you are online if that works!

