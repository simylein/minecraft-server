#!/bin/bash
# mincraft server prerender script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}Server is not currently running!${nocolor}"
	exit 1
fi

# explain to user
echo -e "${blue}I will prerender your minecraft world by teleporting a selcted player through it${nocolor}"
echo -e "${blue}I will scan so to speak in a grid with the spacing of 256 blocks${nocolor}"

# ask for playername
read -p "Please enter a playername: " playername
echo -e "The player will be ${green}${playername}${nocolor}"

# ask for interval in seconds
echo "I would like to know how fast you want to scan your world"
echo "I would recommend an interval of 30 to 60 secounds"
echo "Please enter an interval in secounds. Example: ${yellow}60${nocolor}"
read -p "interval:" interval
interval="sleep ${interval}s"
echo -e "The selected interval will be ${green}${interval}${nocolor}"

echo "I will now start to teleport the selected player through the world"
read -p "Continue? [Y/N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then echo -e "${green}starting prerenderer...${nocolor}"
	else echo -e "${red}exiting...${nocolor}"
		exit 1
fi

# prerender start
echo "Prerendering started"
echo "Progress: [000/000]"
sleep 2s

# teleport script with progress
progress="1"
counter="1"
y="128"
for x in "${cords[@]}"; do
		for z in "${cords[@]}"; do
			echo "tp ${playername} ${x} ${y} ${z}"
			let "progress=counter"
			if (( ${progress} < 10 )); then
				progress=00${progress}
			elif (( ${progress} > 99 )); then
				progress=${progress}
			else
				progress=0${progress}
			fi
			counter=$((counter+1))
			echo "Progress: [${progress}/289]"
			${interval}
		done
	${interval}
done

# command line finished message
screen -Rd ${servername} -X stuff "Prerendering of your world has finished$(printf '\r')"
echo -e "${green}Prerendering of your world has finished${nocolor}"
screen -Rd ${servername} -X stuff "Rendered 4096 blocks of area$(printf '\r')"
echo -e "${green}Rendered 16777216 [4096 times 4096] blocks of area${nocolor}"

# kick player with finished message
screen -Rd ${servername} -X stuff "kick ${playername} prerendering of your world has finished$(printf '\r')"
