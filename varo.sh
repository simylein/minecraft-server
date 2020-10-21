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

# collect all playernames
echo "Please put in all participating Varo Players"
read -p "playername1:" player1
read -p "playername2:" player2
read -p "playername3:" player3
read -p "playername4:" player4
read -p "playername5:" player5
read -p "playername6:" player6
read -p "playername7:" player7
read -p "playername8:" player8

# list all participating players
echo "All participating Varo Players:"
echo "${player1}"
echo "${player2}"
echo "${player3}"
echo "${player4}"
echo "${player5}"
echo "${player6}"
echo "${player7}"
echo "${player8}"

# wait for ingame start command
echo "waiting for ingame start command..."
start="confirm varo start"
screenlog="screenlog.0"
while true; do
	if [[ ! -z $(grep "$start" "$screenlog") ]]; then
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
while true; do
screen ${servername} -X hardcopy "tmplog"
tail -n1 tmplog >> tmploglastline
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmp-log-last-line") ]]; then
                if [[ ! -z $(grep "$player1" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player1}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player1} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player1} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player2" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player2}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player2} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player2} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player3" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player3}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player3} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player3} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player4" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player4}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player4} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player4} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player5" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player5}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player5} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player5} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player6" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player6}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player6} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player6} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player7" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player7}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player7} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player7} died!"
                fi
        fi
        if [[ ! -z $(grep -E "$death01|$death02|$death03|$death04|$death05|$death06|$death07|$death08|$death09|$death10|$death11|$death12|$death13|$death14|$death15|$death16|$death17|$death18|$death19|$death20|$death21|$death22|$death23|$death24|$death25|$death26|$death27|$death28|$death29|$death30|$death31|$death32|$death33|$death34|$death35|$death36|$death37" "$tmploglastline") ]]; then
                if [[ ! -z $(grep "$player8" "$tmploglastline") ]]; then
                        screen -Rd ${servername} -X stuff "gamemode 3 ${player8}$(printf '\r')"
                        screen -Rd ${servername} -X stuff "ban ${player8} You died! Thank you for participating in Varo$(printf '\r')"
                        echo -e "${red}${player8} died!"
                fi
        fi
sleep 0.2s
done
