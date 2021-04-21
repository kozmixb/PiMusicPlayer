#!/bin/bash

clear

echo "####################################"
echo "# 1) Install & Setup MPD, MPC      #"
echo "# 2) Export configuration          #"
echo "# q) Quit                          #"
echo -n "# Select: "
read -n1 opt; echo;
case $opt in
	1)
	echo "Check update & Install services"
        apt-get update && apt-get -y install mpd mpc
        echo "Copy files and sets them up"
	echo "* * 	* * *	root	/usr/bin/diskcp && sleep 20 && /usr/bin/diskcp && sleep 20 && /usr/bin/diskcp" >>/etc/crontab
        # /usr/bin/diskmount
        cp ./diskmount /usr/bin/diskmount
        chmod 755 /usr/bin/diskmount
        # /usr/bin/diskcp
        cp ./diskcp /usr/bin/diskcp
        chmod 755 /usr/bin/diskcp
        #mpd config setup
        cp ./mpd.conf /etc/mpd.conf
        mkdir -p /music/mpd; mkdir /music/mpdlist
        /etc/init.d/mpd restart
        #udev setting
        cp ./10-local.rules /etc/udev/rules.d/10-local.rules
        /etc/init.d/udev restart
	sed -i "$ d" /etc/rc.local
	echo "mpc clear && mpc update " >> /etc/rc.local
	echo "mpc ls |mpc add" >>/etc/rc.local
	echo "mpc shuffle && mpc play" >>/etc/rc.local
	echo "exit 0" >>/etc/rc.local
	echo "The configuration is imported! Ready to use!"
	    ;;
	2)
	echo "Search for external devices"
	if [ -d /mnt/usb ]; then
		DIR="/mnt/usb/MusicSystem($(date +%d-%m-%Y))"
	else
		DIR="./$(date +%d-%m-%Y)SAVE"
	fi
	echo "Export:"
	if [ ! -d $DIR ]; then
		mkdir $DIR
		echo "Folder created: $DIR"
	else
		rm -r $DIR/*
		echo "Folder empty: $DIR"
	fi
	cp /etc/mpd.conf $DIR/
	echo "Export: mpd.conf"
	cp /etc/udev/rules.d/10-local.rules $DIR/
	echo "Export: 10-local.rules"
	cp /usr/bin/diskcp $DIR/
	echo "Export: diskcp"
	cp /usr/bin/diskmount $DIR/
	echo "Export: diskmount"
	cp $SRC/install $DIR/
	echo "Export: install"
	sync
	echo "Exported all files!"
		;;
	*)
	echo "Wrong command, try again!"
esac
