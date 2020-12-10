#!/bin/bash
# minecraft server varo script

# WARNING this script is broken

# read the settings
. ./server.settings

# array of possible death messages
deaths=(
	"was shot by"
	"was pummeled by"
	"was pricked to death"
	"walked into a cactus whilst trying to escape"
	"drowned"
	"experienced kinetic energy"
	"blew up"
	"was blown up by"
	"was killed by"
	"hit the ground too hard"
	"fell from a high place"
	"fell off"
	"fell while climbing"
	"was squashed by a falling"
	"went up in flames"
	"walked into fire"
	"burned to death"
	"was burnt to a crisp"
	"went off with a bang"
	"tried to swim in lava"
	"was struck by lightning"
	"discovered the floor was lava"
	"walked into danger zone"
	"was killed by"
	"was slain by"
	"was fireballed by"
	"was stung to death"
	"starved to death"
	"suffocated in a wall"
	"was squished too much"
	"was squashed by"
	"was poked to death by a sweet berry bush"
	"was killed trying to hurt"
	"was impaled by"
	"fell out of the world"
	"didn't want to live in the same world as"
	"withered away"
)

# all participating playernames
playername01="player01"
playername02="player02"
playername03="player03"
playername04="player04"
playername05="player05"
playername06="player06"
playername07="player07"
playername08="player08"
playername09="player09"
playername10="player10"
playername11="player11"

# change to server directory
cd ${serverdirectory}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}Server is not currently running!{nocolor}"
	exit 1
fi

# ask for playerinput
echo "Would you like to put in the players yourself or read them from server.settings?"
read -p "Put in yourself [Y] Read from server.settings [N]:"
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		# collect all playernames
		echo "Please put in all participating Varo Players"
		read -p "playername01:" player01
		read -p "playername02:" player02
		read -p "playername03:" player03
		read -p "playername04:" player04
		read -p "playername05:" player05
		read -p "playername06:" player06
		read -p "playername07:" player07
		read -p "playername08:" player08
		read -p "playername09:" player09
		read -p "playername10:" player10
		read -p "playername11:" player11
		read -p "playername12:" player12
		read -p "playername13:" player13
		read -p "playername14:" player14
		read -p "playername15:" player15
		read -p "playername16:" player16

		# list all participating players
		echo "All participating Varo Players:"
		echo "${player01}, ${player02}, ${player03}, ${player04}, ${player05}, ${player06}, ${player07}, ${player08}, ${player09}, ${player10}, ${player11}, ${player12}, ${player13}, ${player14}, ${player15}, ${player16}"
fi

# wait for ingame start command
echo "waiting for ingame start command..."
start="confirm varo start"
while true; do
tail -n1 ${screenlog} >> ${tmpscreenlog}
	if [[ ! -z $(grep "$start" "$tmpscreenlog") ]]; then
		break
	fi
rm ${tmpscreenlog}
sleep 1s
done

# welcome message
screen -Rd ${servername} -X stuff "say Welcome to Minecraft Varo$(printf '\r')"
echo "Welcome to Minecraft Varo"
sleep 5s

# countdown to varo
counter="240"
while [ ${counter} -gt 0 ]; do
        if [[ "${counter}" =~ ^(240|180|120|60|40|20|10|5|4|3|2|1)$ ]];then
                echo "Minecraft Varo is starting in ${counter} seconds!"
                screen -Rd ${servername} -X stuff "gamemode adventure @a$(printf '\r')"
                screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in ${counter} seconds!$(printf '\r')"
        fi
counter=$((counter-1))
sleep 1s
done

# start of varo
screen -Rd ${servername} -X stuff "gamemode survival @a$(printf '\r')"
screen -Rd ${servername} -X stuff "say Minecraft Varo has started$(printf '\r')"
screen -Rd ${servername} -X stuff "say Good Luck and have fun to all Teams$(printf '\r')"

# death checking sequenze
while true; do
tail -n1 ${screenlog} >> ${tmpscreenlog}
	if [[ ! -z $(grep "${player01} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player01} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player01} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player01} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player02} ${deaths[*]}" "$tmpscreenlog") ]]; then
		screen -Rd ${servername} -X stuff "say ${player02} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player02} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player02} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player03} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player03} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player03} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player03} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player04} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player04} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player04} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player04} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player05} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player05} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player05} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player05} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player06} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player06} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player06} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player06} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player07} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player07} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player07} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player07} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player08} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player08} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player08} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player08} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player09} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player09} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player09} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player09} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player10} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player10} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player10} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player10} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player11} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player11} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player11} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player11} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player12} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player12} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player12} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player12} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player13} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player13} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player13} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player13} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player14} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player14} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player14} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player14} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player15} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player15} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player15} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player15} died!${nocolor}"
	fi
	if [[ ! -z $(grep "${player16} ${deaths[*]}" "${tmpscreenlog}") ]]; then
		screen -Rd ${servername} -X stuff "say ${player16} has left varo due to death$(printf '\r')"
		screen -Rd ${servername} -X stuff "ban ${player16} You died! Thank you for participating in Varo$(printf '\r')"
		echo -e "${red}${player16} died!${nocolor}"
	fi
rm ${tmpscreenlog}
sleep 1s
done
