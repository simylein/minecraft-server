#!/bin/bash
# Minecraft Server start script

. ./settings.sh

cd ${serverdirectory}

echo "I will prerender your minecraft world by teleporting a selcted player through it"
echo "I will scan so to speak in a grid with the spacing of 256 blocks"
read -p "Please enter a playername: " playername
echo "The player will be ${playername}"

echo "I would like to know how fast you want to scan your world"
echo "I would recommend an interval of 30 or 60 secounds"
read -p "Please enter an interval in secounds. Example: sleep 60s" interval
echo "The selected interval will be ${interval}"

echo "I will now start to teleport the selected player through he world"
echo "Continue?"
read -p "[Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo "starting prerender..."
	else echo "exiting..."
		exit 1
fi

# grid settings

x='128'

a='2048'
b='1792'
c='1536'
d='1280'
e='1024'
f='0768'
g='0512'
h='0256'
i='0000'
j='-0256'
k='-0512'
l='-0768'
m='-1024'
n='-1280'
o='-1536'
p='-1792'
q='-2048'

# teleporting sequence

echo "Setting player into spectator mode"
screen -Rd ${servername} -X stuff "gamemode ${playername} spectator$(printf '\r')"

echo "Prerendering started"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} 2048 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 1792 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 1536 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 1280 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 1024 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 0768 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 0512 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 0256 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} 0000 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -0256 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -0512 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -0768 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -1024 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -1280 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -1536 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -1792 128 2048$(printf '\r')"
echo "Progress: 00.00%"

screen -Rd ${servername} -X stuff "tp ${playername} -2048 128 2048$(printf '\r')"


