#!/bin/bash
# minecraft server update script

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# read server.functions file with error checking
if [[ -f "server.functions" ]]; then
	. ./server.functions
else
	echo "$(date) fatal: server.functions is missing" >> fatalerror.log
	echo "fatal: server.functions is missing"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "$(date) fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
	exit 1
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "$(date) fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "$(date) fatal: serverdirectory is missing" >> fatalerror.log
	echo "fatal: serverdirectory is missing"
	exit 1
fi

# parsing script arguments
ParseScriptArguments "$@"

# write date to logfile
echo "${date} executing update script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then

	# remove all older safety backups
	if [[ -s "${backupdirectory}/cached/update-"* ]]; then
		rm ${backupdirectory}/cached/update-*
	fi

	# create backup
	CheckVerbose "${blue}backing up...${nocolor}"
	tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/cached/update-${newdaily}.tar.gz

	# check if safety backup exists
	if ! [[ -s "${backupdirectory}/cached/update-${newdaily}.tar.gz" ]]; then
		echo "${red}warning: safety backup failed - proceeding to server update${nocolor}"
		echo "warning: safety backup failed - proceeding to server update" >> ${screenlog}
	else
		echo "created ${backupdirectory}/cached/update-${newdaily}.tar.gz as a safety backup" >> ${backuplog}
		echo "" >> ${backuplog}
	fi

	# Test internet connectivity and update on success
	wget --spider --quiet https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
	if [ "$?" != 0 ]; then
		echo "${red}Warning: Unable to connect to Mojang API. Skipping update...${nocolor}"
		echo "Warning: Unable to connect to Mojang API. Skipping update..." >> ${screenlog}
	else
		CheckQuiet "${green}downloading newest server version...${nocolor}"
		echo "downloading newest server version..." >> ${screenlog}
		# check if already on newest version
		if [[ "${serverfile}" = *"minecraft-server.1.16.5.jar" ]]; then
			CheckVerbose "You are running the newest server version - skipping update"
			echo "You are running the newest server version - skipping update" >> ${screenlog}
		else
			wget -q -O minecraft-server.1.16.5.jar https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
			# update serverfile variable in server.settings
			newserverfile="${serverdirectory}/minecraft-server.1.16.5.jar"
			# if new serverfile exists remove oldserverfile
			if [ -f "${newserverfile}" ]; then
				CheckVerbose "${green}Success: updating server.settings for startup with new server version 1.16.5${nocolor}"
				sed -i "s|${serverfile}|${newserverfile}|g" server.settings
				# remove old serverfile if it exists
				if [ -f "${serverfile}" ]; then
					rm ${serverfile}
				fi
			else
				echo "${yellow}Warning: could not remove old serverfile ${serverfile} because new serverfile ${newserverfile} is missing${nocolor}"
				echo "Server will startup with old serverfile ${serverfile}"
			fi
		fi
	fi

	# Test internet connectivity and update on success
	wget --spider --quiet https://raw.githubusercontent.com/Simylein/MinecraftServer/master/LICENSE
	if [ "$?" != 0 ]; then
		echo "${red}Warning: Unable to connect to GitHub API. Skipping update...${nocolor}"
		echo "Warning: Unable to connect to GitHub API. Skipping update..." >> ${screenlog}
	else
		echo "${green}downloading newest scripts version...${nocolor}"
		echo "downloading newest scripts version..." >> ${screenlog}
		# remove all scripts then download all the scripts then make the scripts executable
		rm LICENSE && wget -q -O LICENSE https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/LICENSE
		rm README.md && wget -q -O README.md https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/README.md
		rm start.sh && wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/start.sh && chmod +x start.sh
		rm restore.sh && wget -q -O restore.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/restore.sh && chmod +x restore.sh
		rm reset.sh && wget -q -O reset.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/reset.sh && chmod +x reset.sh
		rm restart.sh && wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/restart.sh && chmod +x restart.sh
		rm stop.sh && wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/stop.sh && chmod +x stop.sh
		rm backup.sh && wget -q -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/backup.sh && chmod +x backup.sh
		rm update.sh && wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/update.sh && chmod +x update.sh
		rm maintenance.sh && wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/maintenance.sh && chmod +x maintenance.sh
		rm prerender.sh && wget -q -O prerender.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/prerender.sh && chmod +x prerender.sh
		rm watchdog.sh && wget -q -O watchdog.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/watchdog.sh && chmod +x watchdog.sh
		rm welcome.sh && wget -q -O welcome.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/welcome.sh && chmod +x welcome.sh
		rm vent.sh && wget -q -O vent.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/vent.sh
	fi

	# restart the server
	CheckQuiet "${green}restarting server...${nocolor}"
	./start.sh "$@"
	exit 0
fi

# check if immediatly is specified
if ! [[ ${immediatly} == true ]]; then
	# countdown
	counter="60"
	while [ ${counter} -gt 0 ]; do
		if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
			CheckQuiet "${blue}[Script]${nocolor} server is updating in ${counter} seconds"
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"server is updating in ${counter} seconds\"}]$(printf '\r')"
		fi
		counter=$((counter-1))
		sleep 1s
	done
fi

# server stop
CheckQuiet "stopping server..."
PrintToScreen "say stopping server..."
PrintToScreen "stop"

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
		echo "${yellow}minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
		screen -S ${servername} -X quit
fi

# remove all older safety backups
if [[ -s "${backupdirectory}/cached/update-"* ]]; then
	rm ${backupdirectory}/cached/update-*
fi

# create backup
CheckVerbose "${blue}backing up...${nocolor}"
tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/cached/update-${newdaily}.tar.gz

# check if safety backup exists
if ! [[ -s "${backupdirectory}/cached/update-${newdaily}.tar.gz" ]]; then
	echo "${red}warning: safety backup failed - proceeding to server update${nocolor}"
	echo "warning: safety backup failed - proceeding to server update" >> ${screenlog}
else
	echo "created ${backupdirectory}/cached/update-${newdaily}.tar.gz as a safety backup" >> ${backuplog}
	echo "" >> ${backuplog}
fi

# Test internet connectivity and update on success
wget --spider --quiet https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
if [ "$?" != 0 ]; then
	echo "${red}Warning: Unable to connect to Mojang API. Skipping update...${nocolor}"
	echo "Warning: Unable to connect to Mojang API. Skipping update..." >> ${screenlog}
else
	CheckQuiet "${green}downloading newest server version...${nocolor}"
	echo "downloading newest server version..." >> ${screenlog}
	# check if already on newest version
	if [[ "${serverfile}" = *"minecraft-server.1.16.5.jar" ]]; then
		CheckVerbose "You are running the newest server version - skipping update"
		echo "You are running the newest server version - skipping update" >> ${screenlog}
	else
		wget -q -O minecraft-server.1.16.5.jar https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar
		# update serverfile variable in server.settings
		newserverfile="${serverdirectory}/minecraft-server.1.16.5.jar"
		# if new serverfile exists remove oldserverfile
		if [ -f "${newserverfile}" ]; then
			CheckVerbose "${green}Success: updating server.settings for startup with new server version 1.16.5${nocolor}"
			sed -i "s|${serverfile}|${newserverfile}|g" server.settings
			# remove old serverfile if it exists
			if [ -f "${serverfile}" ]; then
				rm ${serverfile}
			fi
		else
			echo "${yellow}Warning: could not remove old serverfile ${serverfile} because new serverfile ${newserverfile} is missing${nocolor}"
			echo "Server will startup with old serverfile ${serverfile}"
		fi
	fi
fi

# Test internet connectivity and update on success
wget --spider --quiet https://raw.githubusercontent.com/Simylein/MinecraftServer/master/LICENSE
if [ "$?" != 0 ]; then
	echo "${red}Warning: Unable to connect to GitHub API. Skipping update...${nocolor}"
	echo "Warning: Unable to connect to GitHub API. Skipping update..." >> ${screenlog}
else
	echo "${green}downloading newest scripts version...${nocolor}"
	echo "downloading newest scripts version..." >> ${screenlog}
		# remove all scripts then download all the scripts then make the scripts executable
		rm LICENSE && wget -q -O LICENSE https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/LICENSE
		rm README.md && wget -q -O README.md https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/README.md
		rm start.sh && wget -q -O start.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/start.sh && chmod +x start.sh
		rm restore.sh && wget -q -O restore.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/restore.sh && chmod +x restore.sh
		rm reset.sh && wget -q -O reset.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/reset.sh && chmod +x reset.sh
		rm restart.sh && wget -q -O restart.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/restart.sh && chmod +x restart.sh
		rm stop.sh && wget -q -O stop.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/stop.sh && chmod +x stop.sh
		rm backup.sh && wget -q -O backup.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/backup.sh && chmod +x backup.sh
		rm update.sh && wget -q -O update.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/update.sh && chmod +x update.sh
		rm maintenance.sh && wget -q -O maintenance.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/maintenance.sh && chmod +x maintenance.sh
		rm prerender.sh && wget -q -O prerender.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/prerender.sh && chmod +x prerender.sh
		rm watchdog.sh && wget -q -O watchdog.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/watchdog.sh && chmod +x watchdog.sh
		rm welcome.sh && wget -q -O welcome.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/welcome.sh && chmod +x welcome.sh
		rm vent.sh && wget -q -O vent.sh https://raw.githubusercontent.com/Simylein/MinecraftServer/${branch}/vent.sh
fi

# restart the server
CheckQuiet "${green}restarting server...${nocolor}"
./start.sh "$@"
