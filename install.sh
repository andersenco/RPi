#!/bin/bash

# Update allmost all
sudo apt-get --yes --force-yes update
#sudo apt-get --yes --force-yes dist-upgrade

# Add screen settings and power usage
if grep -c "max_usb_current=1" /boot/config.txt; then
    echo YES
else
    sudo sh -c "sudo echo hdmi_force_hotplug=1 >> /boot/config.txt"
    sudo sh -c "sudo echo hdmi_group=2 >> /boot/config.txt"
    sudo sh -c "sudo echo hdmi_mode=1 >> /boot/config.txt"
    sudo sh -c "sudo echo hdmi_mode=87 >> /boot/config.txt"
    sudo sh -c "sudo echo hdmi_cvt 800 480 60 6 0 0 0 >> /boot/config.txt"
    sudo sh -c "sudo echo max_usb_current=1 >> /boot/config.txt"
    sudo sh -c "sudo echo  >> /boot/config.txt"
fi

# free some space
sudo apt-get --yes --force-yes remove --purge minecraft-pi 
sudo apt-get --yes --force-yes remove --purge scratch
sudo apt-get --yes --force-yes remove --purge wolfram-engine
sudo apt-get --yes --force-yes remove --purge debian-reference-*
sudo apt-get --yes --force-yes remove --purge epiphany-browser*
sudo apt-get --yes --force-yes remove --purge sonic-pi 
sudo apt-get --yes --force-yes remove --purge supercollider*
sudo apt-get --yes --force-yes remove --purge xpdf
sudo apt-get --yes --force-yes remove --purge xarchiver
sudo apt-get --yes --force-yes clean
rm -r /home/pi/python_games/

# install Kodi dependencies
sudo apt-get --yes --force-yes install libssh-4
sudo apt-get --yes --force-yes install libmicrohttpd10
sudo apt-get --yes --force-yes install libtinyxml2.6.2
sudo apt-get --yes --force-yes install libyajl2
sudo apt-get --yes --force-yes install libmysqlclient18 
sudo apt-get --yes --force-yes install liblzo2-2
sudo apt-get --yes --force-yes install libpcrecpp0
sudo apt-get --yes --force-yes install libmysqlclient-dev

# Initialize the radio module
#sudo apt-get --yes --force-yes install python-smbus

# Send click events to X windows
sudo apt-get --yes --force-yes install xdotool

# gpsd and tools
sudo apt-get --yes --force-yes install gpsd gpsd-clients

#sudo apt-get --yes --force-yes install espeak

sudo rm -f /home/pi/Desktop/debian-reference-common.desktop
sudo rm -f /home/pi/Desktop/epiphany-browser.desktop
sudo rm -f /home/pi/Desktop/minecraft-pi.desktop
sudo rm -f /home/pi/Desktop/pistore.desktop
sudo rm -f /home/pi/Desktop/python-games.desktop
sudo rm -f /home/pi/Desktop/scratch.desktop
sudo rm -f /home/pi/Desktop/sonic-pi.desktop
sudo rm -f /home/pi/Desktop/wolfram-language.desktop
#sudo rm -f rm -f /home/pi/Desktop/wolfram-mathematica.desktop
sudo rm -f /home/pi/.Mathematica

# Install programs needed
sudo apt-get --yes --force-yes install kodi navit

# Get maps needed
sudo mkdir /usr/share/navit/maps
#wget http://maps6.navit-project.org/api/map/?bbox=-17.6,34.5,42.9,70.9 -O /usr/share/navit/maps/western_europe.bin
wget http://maps6.navit-project.org/api/map/?bbox=7.65,54.32,15.58,58.07 -O /usr/share/navit/maps/denmark.bin

# Get Navit skin
wget http://ftp.architektur.tu-darmstadt.de/debian/pool/main/n/navit-skin-neo-cs/navit-skin-neo-cs_1.0.tar.gz -O /home/pi/navit-skin-neo-cs_1.0.tar.gz
sudo mkdir /usr/share/navit/skins/neo-cs
sudo tar -zxvf /home/pi/navit-skin-neo-cs_1.0.tar.gz -C /usr/share/navit/skins/neo-cs
# Config: http://wiki.navit-project.org/index.php/OSD_Layouts#Download

#./rpi-carpc.sh update all

#sudo insserv /etc/init.d/splashscreen

####################
# GPS settings
####################

# Settings in /boot/cmdline.txt
# remove console=ttyAMA0,115200 and if there, kgdboc=ttyAMA0,115200
sudo sh -c "sudo sed -i 's/console=ttyAMA0,115200 //' /boot/cmdline.txt"
sudo sh -c "sudo sed -i 's/kgdboc=ttyAMA0,115200 //' /boot/cmdline.txt"

# Settings in /etc/inittab
# add a # to the beginning of T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100
sudo sh -c "sudo sed -i 's|T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|#T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|' /etc/inittab"

# Start daemon
sudo gpsd /dev/ttyAMA0 -F /var/run/gpsd.sock

####################
# Navit configuration
####################

# Use all map binfiles and not only map1.bin
# <maps type="binfile" enabled="yes" data="$NAVIT_SHAREDIR/maps/*.bin"/>

# Perhaps includes can be used. Insert before </navit>
# <xi:include href="$HOME/.navit/xml/gui.xml"/>

sudo cp /etc/navit/navit.xml ~/.navit/navit.xml

