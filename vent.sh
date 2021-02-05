#!/bin/bash
# minecraft server selft-destruct script

# WARNING do not execute unless you want to delete your server

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!"
	exit 1
fi

# read server.functions file with error checking
if [[ -f "server.functions" ]]; then
	. ./server.functions
else
	echo "fatal: server.functions is missing" >> fatalerror.log
	echo "fatal: server.functions is missing"
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "fatal: serverdirectory is missing" >> fatalerror.log
	echo "fatal: serverdirectory is missing"
	exit 1
fi

# write date to logfile
echo "${date} executing self-destruct script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo -e "${yellow}server is not currently running!${nocolor}"
	counter="10"
	while [ ${counter} -gt 0 ]; do
		if [[ "${counter}" =~ ^(10|9|8|7|6|5|4|3|2|1)$ ]]; then
			echo -e "${blue}[Script]${nocolor} ${red}server is self-destructing in ${counter} seconds${nocolor}"
		fi
		counter=$((counter-1))
		sleep 1s
	done
	cd ../
	# remove crontab
	crontab -r
	# remove serverdirectory
	rm -r ${servername}
	# check if vent was successful
	if ! [ -d "${serverdirectory}" ]; then
		# game over terminal screen
		echo -e "${red}                                            ${nocolor}"
		echo -e "${red}  .@@^^^@.  .@@^^^@@.  .@@^@.@^@@.  @@^^^^  ${nocolor}"
		echo -e "${red}  @@    @@  @@     @@  @@   @   @@  @@      ${nocolor}"
		echo -e "${red}  @@  ....  @@.....@@  @@   ^   @@  @@^^^^  ${nocolor}"
		echo -e "${red}  @@    @@  @@     @@  @@       @@  @@      ${nocolor}"
		echo -e "${red}  ^@@...@^  @@     @@  @@       @@  @@....  ${nocolor}"
		echo -e "${red}                                            ${nocolor}"
		echo -e "${red}   .@@^^^@@.  @@@  @@r  @@^^^^  @@^^^^@@.   ${nocolor}"
		echo -e "${red}   @@     @@   @@  @@   @@      @@     @@   ${nocolor}"
		echo -e "${red}   @@     @@   @@  @@   @@^^^^  @@.....^^   ${nocolor}"
		echo -e "${red}   @@     @@   @@  @r   @@      @@     @@   ${nocolor}"
		echo -e "${red}   ^@@...@@^    &@r     @@....  @@     @@.  ${nocolor}"
		echo -e "${red}                                            ${nocolor}"
		exit 1
	else
		# error if serverdirectory still exists
		echo -e "${red}venting failed!${nocolor}"
		exit 1
	fi
fi

# warning
echo -e "${blue}[Script]${nocolor} ${red}WARNING: venting startet!${nocolor}"
screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"WARNING: venting startet!\",\"color\":\"red\"}]$(printf '\r')"

# sleep for 2 seconds
sleep 2s

# countdown
counter="120"
while [ ${counter} -gt 0 ]; do
	if [[ "${counter}" =~ ^(120|60|40|20|10|5|4|3|2|1)$ ]]; then
		echo -e "${blue}[Script]${nocolor} ${red}server is self-destructing in ${counter} seconds${nocolor}"
		screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"server is self-destructing in ${counter} seconds\",\"color\":\"red\"}]$(printf '\r')"
	fi
	counter=$((counter-1))
	sleep 1s
done

# game over
echo -e "${blue}[Script]${nocolor} ${red}GAME OVER${nocolor}"
screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"GAME OVER\",\"color\":\"red\"}]$(printf '\r')"

# sleep 2 seconds
sleep 2s

# stop command
echo "stopping server..."
screen -Rd ${servername} -X stuff "say deleting server...$(printf '\r')"
screen -Rd ${servername} -X stuff "stop$(printf '\r')"

# check if server stopped
stopchecks="0"
while [ $stopchecks -lt 30 ]; do
	if ! screen -list | grep -q "\.${servername}"; then
		break
	fi
	stopchecks=$((stopchecks+1))
	sleep 1;
done

# force quit server if not stopped
if screen -list | grep -q "${servername}"; then
	echo -e "${yellow}minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
	screen -S ${servername} -X quit
fi

# sleep 2 seconds
sleep 2s

cd ../
# remove crontab
crontab -r
# remove serverdirectory
echo "deleting server..."
rm -r ${servername}
# check if vent was successful
if ! [ -d "${serverdirectory}" ]; then
	# game over terminal screen
	echo -e "${red}                                            ${nocolor}"
	echo -e "${red}  .@@^^^@.  .@@^^^@@.  .@@^@.@^@@.  @@^^^^  ${nocolor}"
	echo -e "${red}  @@    @@  @@     @@  @@   @   @@  @@      ${nocolor}"
	echo -e "${red}  @@  ....  @@.....@@  @@   ^   @@  @@^^^^  ${nocolor}"
	echo -e "${red}  @@    @@  @@     @@  @@       @@  @@      ${nocolor}"
	echo -e "${red}  ^@@...@^  @@     @@  @@       @@  @@....  ${nocolor}"
	echo -e "${red}                                            ${nocolor}"
	echo -e "${red}   .@@^^^@@.  @@@  @@r  @@^^^^  @@^^^^@@.   ${nocolor}"
	echo -e "${red}   @@     @@   @@  @@   @@      @@     @@   ${nocolor}"
	echo -e "${red}   @@     @@   @@  @@   @@^^^^  @@.....^^   ${nocolor}"
	echo -e "${red}   @@     @@   @@  @r   @@      @@     @@   ${nocolor}"
	echo -e "${red}   ^@@...@@^    &@r     @@....  @@     @@.  ${nocolor}"
	echo -e "${red}                                            ${nocolor}"
	exit 1
else
	# error if serverdirectory still exists
	echo -e "${red}venting failed!${nocolor}"
	exit 1
fi
