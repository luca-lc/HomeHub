#!/bin/bash

if [[ "$EUID" = 0 ]]; then
	apt update
	apt-get full-upgrade -y -q
	apt autoremove -y
	apt autoclean
	apt purge
	if [[ -f "/var/run/reboot-required" ]]; then
		reboot
	fi
else
	echo -e "It must be run as sudo"
fi