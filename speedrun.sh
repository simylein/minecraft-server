#!/bin/bash
# minecraft server speedrun script
# WARNING
# this script is broken

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}Server is not currently running!${nocolor}"
	exit 1
fi

# wait for ingame start command
echo "waiting for ingame start command..."
start="confirm speedrun start"
while true; do
tail -n1 ${screenlog} >> ${tmpscreenlog}
	if [[ ! -z $(grep "$start" "$tmpscreenlog") ]]; then
		break
	fi
rm ${tmpscreenlog}
sleep 1s
done

# create ingame scoreboard
echo "creating scoreboard..."
screen -Rd ${servername} -X stuff "scoreboard objectives add health health$(printf '\r')"
screen -Rd ${servername} -X stuff "scoreboard objectives setdisplay list health$(printf '\r')"

# apply effects
echo "applying effects..."
screen -Rd ${servername} -X stuff "gamemode adventure @a$(printf '\r')"
screen -Rd ${servername} -X stuff "effect give @a minecraft:slowness 100 2$(printf '\r')"
screen -Rd ${servername} -X stuff "time set night$(printf '\r')"
screen -Rd ${servername} -X stuff "difficulty peaceful$(printf '\r')"

# welcome message
echo "Welcome to Minecraft Speedrun Server"
screen -Rd ${servername} -X stuff "say Welcome to Minecraft Speedrun Server$(printf '\r')"
echo "starting countdown..."

# countdown
counter="60"
while [ ${counter} -gt 0 ]; do
	if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
		echo "Speedrun Challange starts in ${counter} seconds!"
		screen -Rd ${servername} -X stuff "say Speedrun Challange starts in ${counter} seconds!$(printf '\r')"
	fi
counter=$((counter-1))
sleep 1s
done

# remove effects
echo "removing effects..."
screen -Rd ${servername} -X stuff "effect clear @a$(printf '\r')"
screen -Rd ${servername} -X stuff "gamemode survival @a$(printf '\r')"
screen -Rd ${servername} -X stuff "effect give @a minecraft:saturation$(printf '\r')"
screen -Rd ${servername} -X stuff "time set day$(printf '\r')"
screen -Rd ${servername} -X stuff "difficulty hard$(printf '\r')"

# challange start
echo "Speedrun Challange has started"
screen -Rd ${servername} -X stuff "say Speedrun Challange has startet$(printf '\r')"
screen -Rd ${servername} -X stuff "say God Luck and Have Fun :PogChamp:,:ZickZackSmiley:$(printf '\r')"

# timer sequence and main scanning sequenze
reset="confirm speedrun reset"
nether="We Need to Go Deeper"
theend="The End?"
dragondeath="Free the End"
time="speedrun time"
counter="0"
while [ ${counter} -lt 12000 ]; do
tail -n1 ${screenlog} >> ${tmpscreenlog}
	let "hours=counter/3600"
		if (( ${hours} < 10 )); then
					hours=0${hours}
		fi
	let "minutes=(counter%3600)/60"
		if (( ${minutes} < 10 )); then
					minutes=0${minutes}
		fi
	let "seconds=(counter%3600)%60"
		if (( ${seconds} < 10 )); then
					seconds=0${seconds}
		fi
	if [ $((counter%480)) -eq 0 ]; then # output time every 8 minutes
		echo "Time elapsed: ${hours}:${minutes}:${seconds}"
		screen -Rd ${servername} -X stuff "say Time elapsed: ${hours}:${minutes}:${seconds}$(printf '\r')"
	fi
	if [[ ! -z $(grep "${time}" "${tmpscreenlog}") ]]; then
		echo "Time elapsed: ${hours}:${minutes}:${seconds}"
		screen -Rd ${servername} -X stuff "say Time elapsed: ${hours}:${minutes}:${seconds}$(printf '\r')"
	fi
	if [[ ! -z $(grep "${nether}" "${tmpscreenlog}") ]]; then
		echo "Time elapsed: ${hours}:${minutes}:${seconds}"
		screen -Rd ${servername} -X stuff "You reached the Nether!$(printf '\r')"
		screen -Rd ${servername} -X stuff "say Time elapsed: ${hours}:${minutes}:${seconds}$(printf '\r')"
	fi
	if [[ ! -z $(grep "${theend}" "${tmpscreenlog}") ]]; then
		echo "Time elapsed: ${hours}:${minutes}:${seconds}"
		screen -Rd ${servername} -X stuff "You reached the End!$(printf '\r')"
		screen -Rd ${servername} -X stuff "say Time elapsed: ${hours}:${minutes}:${seconds}$(printf '\r')"
	fi
	if [[ ! -z $(grep "${deaths[*]}" "${tmpscreenlog}") ]]; then # if a player dies output time and reset server
		echo "You died! Challange stopped at ${hours}:${minutes}:${seconds}!"
		screen -Rd ${servername} -X stuff "say You died! Challange stopped at ${hours}:${minutes}:${seconds}!$(printf '\r')"
		screen -Rd ${servername} -X stuff "gamemode spectator @a$(printf '\r')"
		./reset.sh
		break
	fi
	if [[ ! -z $(grep "${reset}" "${tmpscreenlog}") ]]; then
		echo "A server reset has been requested"
		screen -Rd ${servername} -X stuff "say A server reset has been requested$(printf '\r')"
		echo "Challange stopped at ${hours}:${minutes}:${seconds}"
		screen -Rd ${servername} -X stuff "say Challange stopped at ${hours}:${minutes}:${seconds}$(printf '\r')"
		screen -Rd ${servername} -X stuff "gamemode spectator @a$(printf '\r')"
		./reset.sh
		break
	fi
	if [[ ! -z $(grep "${dragondeath}" "${tmpscreenlog}") ]]; then
		echo "Challange has been completed in ${hours}:${minutes}:${seconds}"
		screen -Rd ${servername} -X stuff "say Challange has been completed in ${hours}:${minutes}:${seconds}$(printf '\r')"
		echo "Congratulations! You did it!"
		screen -Rd ${servername} -X stuff "say Congratulations! You did it!$(printf '\r')"
		screen -Rd ${servername} -X stuff "gamemode spectator @a$(printf '\r')"
		./reset.sh
		break
	fi
counter=$((counter+1))
rm ${tmpscreenlog}
sleep 1s
done
