#!/bin/bash
# Minecraft Server start script

. ./settings.sh

cd ${serverdirectory}

echo "I will prerender your minecraft world by teleporting a selcted player through it"
read -p "Please enter a playername: " playername
echo "The player will be ${playername}"

echo "I will now start to teleport the selected pleyer through he world"
echo "Continue?"
read -p "[Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo "starting prerender..."
	else echo "exiting..."
		exit 1
fi
