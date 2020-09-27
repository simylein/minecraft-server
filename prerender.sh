#!/bin/bash
# Minecraft Server start script

. ./settings.sh

cd ${serverdirectory}

echo "I will prerender your minecraft world by teleporting a selcted player through it"
echo "I will scan so to speak in a grid with the spacing of 256 blocks"
read -p "Please enter a playername: " playername
echo "The player will be ${playername}"

echo "I would like to know how fast you want to scan your world"
echo "I would recommend an interval of 30 to 60 secounds"
echo "Please enter an interval in secounds. Example: sleep 60s"
read -p "interval:" interval
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
screen -Rd ${servername} -X stuff "gamemode spectator ${playername}$(printf '\r')"

echo "Prerendering started"
sleep 20s
echo "Progress: 00.00%"

# Sequence A
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${a}$(printf '\r')"
echo "Progress: 00.35%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${a}$(printf '\r')"
echo "Progress: 00.69%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${a}$(printf '\r')"
echo "Progress: 01.04%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${a}$(printf '\r')"
echo "Progress: 01.38%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${a}$(printf '\r')"
echo "Progress: 01.74%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${a}$(printf '\r')"
echo "Progress: 02.07%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${a}$(printf '\r')"
echo "Progress: 02.42%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${a}$(printf '\r')"
echo "Progress: 02.77%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${a}$(printf '\r')"
echo "Progress: 03.11%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${a}$(printf '\r')"
echo "Progress: 03.46%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${a}$(printf '\r')"
echo "Progress: 03.80%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${a}$(printf '\r')"
echo "Progress: 04.15%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${a}$(printf '\r')"
echo "Progress: 04.49%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${a}$(printf '\r')"
echo "Progress: 04.84%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${a}$(printf '\r')"
echo "Progress: 05.19%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${a}$(printf '\r')"
echo "Progress: 05.54%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${a}$(printf '\r')"
echo "Progress: 05.88%"
${interval}

# Sequence B
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${b}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${b}$(printf '\r')"
echo "Progress: 11.76%"
${interval}

# Sequence C
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${c}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${c}$(printf '\r')"
echo "Progress: 17.65%"
${interval}

# Sequence D
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${d}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${d}$(printf '\r')"
echo "Progress: 23.53%"
${interval}

# Sequence E
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${e}$(printf '\r')"
echo "Progress: 00.00%"
${interval}

# Sequence F
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${f}$(printf '\r')"
echo "Progress: 00.00%"
${interval}

# Sequence G
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${g}$(printf '\r')"
echo "Progress: 00.00%"
${interval}

# Sequence H
screen -Rd ${servername} -X stuff "tp ${playername} ${a} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${b} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${c} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${d} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${e} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${f} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${g} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${h} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${i} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${j} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${k} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${l} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${m} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${n} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${o} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${p} ${x} ${h}$(printf '\r')"
echo "Progress: 00.00%"
${interval}
screen -Rd ${servername} -X stuff "tp ${playername} ${q} ${x} ${h}$(printf '\r')"
echo "Progress: 47.06%"
${interval}

screen -Rd ${servername} -X stuff "Prerendering of your world has finished$(printf '\r')"
echo "Prerendering of your world has finished"
screen -Rd ${servername} -X stuff "Rendered 4096 blocks of area$(printf '\r')"
echo "Rendered 4096 blocks of area"

screen -Rd ${servername} -X stuff "kick ${playername}$(printf '\r')"
echo "script is done"
