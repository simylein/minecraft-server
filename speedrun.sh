#!/bin/bash
# minecraft server speedrun script

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
start="confirm challange start"
screenlog="screenlog.0"
while true; do
	if [[ ! -z $(grep "$start" "$screenlog") ]]; then
		break
	fi
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

# timer sequence
dragondeath="Free the End"
screenlog="screenlog.0"
counter="0"
while [ ${counter} -lt 12000 ]; do # while under 3 hours and 20 minutes do loop
		if [[ ! -z $(grep "$dragondeath" "$screenlog") ]]; then # if dragon is killed output time and reset server
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
			echo "Challange has been completed in ${hours}:${minutes}:${seconds}" # command line time output
			screen -Rd ${servername} -X stuff "say Challange has been completed in ${hours}:${minutes}:${seconds}$(printf '\r')" # ingame time output
			screen -Rd ${servername} -X stuff "gamemode spectator @a$(printf '\r')"
			./reset.sh # execution of the reset script
			break
		fi
    if [ $((counter%240)) -eq 0 ]; then # output time every 4 minutes
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
            echo "Time elapsed: ${hours}:${minutes}:${seconds}" # command line time output
            screen -Rd ${servername} -X stuff "say Time elapsed: ${hours}:${minutes}:${seconds}$(printf '\r')" # ingame time output
      fi
counter=$((counter+1))
sleep 1s
done
