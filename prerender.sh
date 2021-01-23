#!/bin/bash
# mincraft server prerender script

# read server.functions file with error checking
if [[ -f "server.functions" ]]; then
	. ./server.functions
else
	echo "fatal: server.functions is missing" >> fatalerror.log
	echo "fatal: server.functions is missing"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
	exit 1
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "fatal: serverdirectory is missing" >> fatalerror.log
	echo "fatal: serverdirectory is missing"
	exit 1
fi

cords=( 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048)

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}Server is not currently running!${nocolor}"
	exit 1
fi

# explain to user
echo -e "${blue}I will prerender your minecraft world by teleporting a selected player through it${nocolor}"
echo -e "${blue}I will scan so to speak in a grid with the spacing of 256 blocks${nocolor}"

# ask for playername
read -p "Please enter a playername: " playername
echo -e "The player will be ${green}${playername}${nocolor}"

# ask for interval in seconds
echo "I would like to know how fast you want to scan your world"
echo "I would recommend an interval of 30 to 60 seconds"
echo "Please enter an interval in seconds. Example: ${yellow}60${nocolor}"
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
