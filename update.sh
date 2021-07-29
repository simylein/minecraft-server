#!/bin/bash
# minecraft server update script

# root safety check
if [ $(id -u) = 0 ]; then
	echo "$(tput bold)$(tput setaf 1)please do not run me as root :( - this is dangerous!$(tput sgr0)"
	exit 1
fi

# read server.functions file with error checking
if [[ -s "server.functions" ]]; then
	. ./server.functions
else
	echo "$(date) fatal: server.functions is missing" >> fatalerror.log
	echo "$(tput setaf 1)fatal: server.functions is missing$(tput sgr0)"
	exit 1
fi

# read server.properties file with error checking
if ! [[ -s "server.properties" ]]; then
	echo "$(date) fatal: server.properties is missing" >> fatalerror.log
	echo "$(tput setaf 1)fatal: server.properties is missing$(tput sgr0)"
	exit 1
fi

# read server.settings file with error checking
if [[ -s "server.settings" ]]; then
	. ./server.settings
else
	echo "$(date) fatal: server.settings is missing" >> fatalerror.log
	echo "$(tput setaf 1)fatal: server.settings is missing$(tput sgr0)"
	exit 1
fi

# change to server directory with error checking
if [ -d "${serverdirectory}" ]; then
	cd ${serverdirectory}
else
	echo "$(date) fatal: serverdirectory is missing" >> fatalerror.log
	echo "${red}fatal: serverdirectory is missing${nocolor}"
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
		echo "${yellow}warning: safety backup failed - proceeding to server update${nocolor}"
		echo "warning: safety backup failed - proceeding to server update" >> ${screenlog}
	else
		echo "created ${backupdirectory}/cached/update-${newdaily}.tar.gz as a safety backup" >> ${backuplog}
		echo "" >> ${backuplog}
	fi

	# Test internet connectivity and update on success
	wget --spider --quiet https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
	if [ "$?" != 0 ]; then
		echo "${yellow}warning: Unable to connect to Mojang API. Skipping update...${nocolor}"
		echo "warning: Unable to connect to Mojang API. Skipping update..." >> ${screenlog}
	else
		CheckQuiet "${green}downloading newest server version...${nocolor}"
		echo "downloading newest server version..." >> ${screenlog}
		# check if already on newest version
		if [[ "${serverfile}" = *"minecraft-server.1.17.1.jar" ]]; then
			CheckVerbose "You are running the newest server version - skipping update"
			echo "You are running the newest server version - skipping update" >> ${screenlog}
		else
			wget -q -O minecraft-server.1.17.1.jar https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
			# update serverfile variable in server.settings
			newserverfile="${serverdirectory}/minecraft-server.1.17.1.jar"
			# if new serverfile exists remove oldserverfile
			if [ -f "${newserverfile}" ]; then
				CheckVerbose "${green}ok: updating server.settings for startup with new server version 1.17.1${nocolor}"
				sed -i "s|${serverfile}|${newserverfile}|g" server.settings
				# remove old serverfile if it exists
				if [ -f "${serverfile}" ]; then
					rm ${serverfile}
				fi
			else
				echo "${yellow}warning: could not remove old serverfile ${serverfile} because new serverfile ${newserverfile} is missing${nocolor}"
				echo "Server will startup with old serverfile ${serverfile}"
			fi
		fi
	fi

	# remove scripts from serverdirectory
	RemoveScriptsFromServerDirectory

	# downloading scripts from github
	DownloadScriptsFromGitHub

	# make selected scripts executable
	MakeScriptsExecutable

	# restart the server
	CheckQuiet "${cyan}restarting server...${nocolor}"
	./start.sh "$@"
	exit 0
fi

# check if immediately is specified
if ! [[ ${immediately} == true ]]; then
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
	echo "${yellow}warning: safety backup failed - proceeding to server update${nocolor}"
	echo "warning: safety backup failed - proceeding to server update" >> ${screenlog}
else
	echo "created ${backupdirectory}/cached/update-${newdaily}.tar.gz as a safety backup" >> ${backuplog}
	echo "" >> ${backuplog}
fi

# Test internet connectivity and update on success
wget --spider --quiet https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
if [ "$?" != 0 ]; then
	echo "${yellow}warning: Unable to connect to Mojang API. Skipping update...${nocolor}"
	echo "warning: Unable to connect to Mojang API. Skipping update..." >> ${screenlog}
else
	CheckQuiet "${green}downloading newest server version...${nocolor}"
	echo "downloading newest server version..." >> ${screenlog}
	# check if already on newest version
	if [[ "${serverfile}" = *"minecraft-server.1.17.1.jar" ]]; then
		CheckVerbose "You are running the newest server version - skipping update"
		echo "You are running the newest server version - skipping update" >> ${screenlog}
	else
		wget -q -O minecraft-server.1.17.1.jar https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
		# update serverfile variable in server.settings
		newserverfile="${serverdirectory}/minecraft-server.1.17.1.jar"
		# if new serverfile exists remove oldserverfile
		if [ -f "${newserverfile}" ]; then
			CheckVerbose "${green}ok: updating server.settings for startup with new server version 1.17.1${nocolor}"
			sed -i "s|${serverfile}|${newserverfile}|g" server.settings
			# remove old serverfile if it exists
			if [ -f "${serverfile}" ]; then
				rm ${serverfile}
			fi
		else
			echo "${yellow}warning: could not remove old serverfile ${serverfile} because new serverfile ${newserverfile} is missing${nocolor}"
			echo "Server will startup with old serverfile ${serverfile}"
		fi
	fi
fi

# remove scripts from serverdirectory
RemoveScriptsFromServerDirectory

# downloading scripts from github
DownloadScriptsFromGitHub

# make selected scripts executable
MakeScriptsExecutable

# restart the server
CheckQuiet "${cyan}restarting server...${nocolor}"
./start.sh "$@"

# exit with code 0
exit 0
