#!/bin/bash
# minecraft server update script

# read the settings
. ./server.settings

# change to serverdirectory
cd ${serverdirectory}

# write date to logfile
echo "${date} executing update script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
		echo -e "${yellow}Server is not currently running!${nocolor}"
		exit 1
fi

# countdown
counter="60"
while [ ${counter} -gt 0 ]; do
	if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
		echo -e "${blue}[Script]${nocolor} server is updating in ${counter} seconds"
		screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\",\"italic\":false},{\"text\":\"server is updating in ${counter} seconds\"}]$(printf '\r')"
	fi
	counter=$((counter-1))
	sleep 1s
done

# server stop
echo "stopping server..."
screen -Rd ${servername} -X stuff "say stopping server...$(printf '\r')"
screen -Rd ${servername} -X stuff "stop$(printf '\r')"

# check if server stopped
stopchecks="0"
while [ $stopchecks -lt 30 ]; do
		if ! screen -list | grep -q "${servername}"; then
				break
		fi
stopchecks=$((stopchecks+1))
sleep 1;
done

# force quit server if not stopped
if screen -list | grep -q "${servername}"; then
		echo -e "${yellow}Minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
		screen -S ${servername} -X quit
fi

# create backup
echo -e "${blue}backing up...${nocolor}"
cp -r ${serverdirectory}/world ${backupdirectory}/cached/update-${newdaily}

# check if safety backup exists
if ! [ -d "${backupdirectory}/cached/reset-${newdaily}" ]; then
	echo -e "${red}warning: safety backup failed - proceeding to server update${nocolor}"
	echo "warning: safety backup failed - proceeding to server update" >> ${screenlog}
fi

# Test internet connectivity and update on success
wget --spider --quiet https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
if [ "$?" != 0 ]; then
	echo -e "${red}Warning: Unable to connect to Mojang API. Skipping update ...${nocolor}"
	echo "Warning: Unable to connect to Mojang API. Skipping update ..." >> ${screenlog}
	else
	echo -e "${green}downloading newest server version...${nocolor}"
	echo "downloading newest server version..." >> ${screenlog}
		wget -q -O minecraft-server.1.16.4.jar https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar
		# update serverfile variable in server.settings
		newserverfile=${serverdirectory}"/minecraft-server.1.16.4.jar"
		sed -i "s|$serverfile|$newserverfile|g" server.settings
fi

# Test internet connectivity and update on success
wget --spider --quiet https://raw.githubusercontent.com/Simylein/MinecraftServer/master/LICENSE
if [ "$?" != 0 ]; then
	echo -e "${red}Warning: Unable to connect to GitHub API. Skipping update ...${nocolor}"
	echo "Warning: Unable to connect to GitHub API. Skipping update ..." >> ${screenlog}
	else
	echo -e "${green}downloading newest scripts version...${nocolor}"
	echo "downloading newest scripts version..." >> ${screenlog}
		# remove all scripts then download all the scripts then make the scripts executable
		rm LICENSE && wget -q -O LICENSE https://raw.githubusercontent.com/Simylein/MinecraftServer/master/LICENSE
		rm README.md && wget -q -O README.md https://raw.githubusercontent.com/Simylein/MinecraftServer/master/README.md
		rm start.sh && wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/start.sh && chmod +x start.sh
		rm restore.sh && wget -q -O restore.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restore.sh && chmod +x restore.sh
		rm reset.sh && wget -q -O reset.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/reset.sh && chmod +x reset.sh
		rm restart.sh && wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/restart.sh && chmod +x restart.sh
		rm stop.sh && wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/stop.sh && chmod +x stop.sh
		rm backup.sh && wget -q -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/backup.sh && chmod +x backup.sh
		rm update.sh && wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/update.sh && chmod +x update.sh
		rm maintenance.sh && wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/master/maintenance.sh && chmod +x maintenance.sh
fi

# restart the server
echo -e "${green}restarting server...${nocolor}"
./start.sh
