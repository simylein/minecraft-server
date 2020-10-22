#!/bin/bash
# minecraft server varo script

# read the settings
. ./server.settings

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
		read -p "playername1:" player01
		read -p "playername2:" player02
		read -p "playername3:" player03
		read -p "playername4:" player04
		read -p "playername5:" player05
		read -p "playername6:" player06
		read -p "playername7:" player07
		read -p "playername8:" player08
		read -p "playername1:" player09
		read -p "playername2:" player10
		read -p "playername3:" player11
		read -p "playername4:" player12
		read -p "playername5:" player13
		read -p "playername6:" player14
		read -p "playername7:" player15
		read -p "playername8:" player16

		# list all participating players
		echo "All participating Varo Players:"
		echo "${player01}, ${player02}, ${player03}, ${player04}, ${player05}, ${player06}, ${player07}, ${player08}, ${player09}, ${player10}, ${player11}, ${player12}, ${player13}, ${player14}, ${player15}, ${player16}"
fi

# wait for ingame start command
echo "waiting for ingame start command..."
start="confirm varo start"
screenlog="screenlog.0"
while true; do
tail -n1 ${screenlog} >> tmploglastline
	if [[ ! -z $(grep "$start" "tmploglastline") ]]; then
		break
	fi
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
                screen -Rd ${servername} -X stuff "gamemode 2 @a$(printf '\r')"
                screen -Rd ${servername} -X stuff "say Minecraft Varo is starting in ${counter} seconds!$(printf '\r')"
        fi
counter=$((counter-1))
sleep 1s
done

# start of varo
screen -Rd ${servername} -X stuff "gamemode 0 @a$(printf '\r')"
screen -Rd ${servername} -X stuff "say Minecraft Varo has started$(printf '\r')"
screen -Rd ${servername} -X stuff "say Good Luck and have fun to all Teams$(printf '\r')"

# death checking sequenze
screenlog="screenlog.0"
while true; do
tail -n1 ${screenlog} >> tmploglastline
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player01" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player01} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player01} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player01} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player02" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player02} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player02} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player02} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player03" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player03} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player03} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player03} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player04" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player04} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player04} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player04} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player05" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player05} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player05} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player05} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player06" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player06} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player06} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player06} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player07" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player07} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player07} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player07} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
		if [[ ! -z $(grep "$player08" "tmploglastline") ]]; then
			screen -Rd ${servername} -X stuff "say ${player08} has left varo due to death$(printf '\r')"
			screen -Rd ${servername} -X stuff "ban ${player08} You died! Thank you for participating in Varo$(printf '\r')"
			echo -e "${red}${player08} died!"
		fi
	fi
	if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player09" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player09} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player09} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player09} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player10" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player10} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player10} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player10} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player11" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player11} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player11} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player11} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player12" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player12} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player12} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player12} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player13" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player13} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player13} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player13} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player14" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player14} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player14} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player14} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player15" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player15} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player15} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player15} died!"
			fi
		fi
		if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "tmploglastline") ]]; then
			if [[ ! -z $(grep "$player08" "tmploglastline") ]]; then
				screen -Rd ${servername} -X stuff "say ${player08} has left varo due to death$(printf '\r')"
				screen -Rd ${servername} -X stuff "ban ${player08} You died! Thank you for participating in Varo$(printf '\r')"
				echo -e "${red}${player08} died!"
			fi
		fi
rm tmploglastline
sleep 1s
done
