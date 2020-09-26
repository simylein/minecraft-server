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
sleep 20s
echo "Progress: 00.00%"
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${a}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
