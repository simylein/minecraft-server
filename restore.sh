#!/bin/bash
# minecraft server restore script

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
echo "${date} executing restore script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# check if immediatly is specified
if ! [[ ${immediatly} == true ]]; then
	# countdown
	counter="60"
	while [ ${counter} -gt 0 ]; do
		if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
			CheckQuiet "${blue}[Script]${nocolor} server is restoring a backup in ${counter} seconds"
			screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\",\"italic\":false},{\"text\":\"server is restoring a backup in ${counter} seconds\"}]$(printf '\r')"
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

# output confirmed stop
echo "${green}server successfully stopped!${nocolor}"

# remove all older safety backups
if [[ -s "${backupdirectory}/cached/restore-"* ]]; then
	rm ${backupdirectory}/cached/restore-*
fi

# create backup
echo "${blue}backing up...${nocolor}"
tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/cached/restore-${newdaily}.tar.gz

# check if safety backup exists
if ! [[ -s "${backupdirectory}/cached/restore-${newdaily}.tar.gz" ]]; then
	echo "${yellow}warning: safety backup failed - proceeding to server restore${nocolor}"
	echo "warning: safety backup failed - proceeding to server restore" >> ${screenlog}
else
	echo "created ${backupdirectory}/cached/restore-${newdaily}.tar.gz as a safety backup" >> ${backuplog}
	echo "" >> ${backuplog}
fi

# create arrays with backupdirectorys
CheckVerbose "scanning backup directory..."
cd ${backupdirectory}
backups=($(ls))
cd hourly
backupshourly=($(ls))
cd ${backupdirectory}
cd daily
backupsdaily=($(ls))
cd ${backupdirectory}
cd weekly
backupsweekly=($(ls))
cd ${backupdirectory}
cd monthly
backupsmonthly=($(ls))
cd ${backupdirectory}
cd cached
backupscached=($(ls))
cd ${backupdirectory}

# ask for daily or hourly backup to restore
PS3="Would you like to restore a ${backups[0]}, ${backups[1]}, ${backups[2]}, ${backups[3]}, ${backups[4]}? "
select dailyhourlyweeklymonthly in "${backups[@]}"
do
	echo "You chose: ${dailyhourlyweeklymonthly}"
	break
done

# select specific backup out of daily, hourly, monthly, weekly or a special backup
if [[ "${dailyhourlyweeklymonthly}" == "${backups[0]}" ]]
then
	# ask for cached backup
	PS3="Which ${backups[4]} backup would you like to restore?"
	select backup in "${backupscached[@]}"
	do
		echo "You chose: ${backup}"
		break
	done
elif [[ "${dailyhourlyweeklymonthly}" == "${backups[1]}" ]]
then
	# ask for daily backup
	PS3="Which ${backups[0]} backup would you like to restore? "
	select backup in "${backupsdaily[@]}"
	do 
		echo "You chose: ${backup}"
		break
	done
elif [[ "${dailyhourlyweeklymonthly}" == "${backups[2]}" ]]
then
	# ask for hourly backup
	PS3="Which ${backups[1]} backup would you like to restore? "
	select backup in "${backupshourly[@]}"
	do
		echo "You chose: ${backup}"
		break
	done
elif [[ "${dailyhourlyweeklymonthly}" == "${backups[3]}" ]]
then
	# ask for monthly backup
	PS3="Which ${backups[2]} backup would you like to restore? "
	select backup in "${backupsmonthly[@]}"
	do
		echo "You chose: ${backup}"
		break
	done
elif [[ "${dailyhourlyweeklymonthly}" == "${backups[4]}" ]]
then
	# ask for weekly backup
	PS3="Which ${backups[3]} backup would you like to restore? "
	select backup in "${backupsweekly[@]}"
	do
		echo "You chose: ${backup}"
		break
	done
fi

# echo selected backup
echo "selected backup to restore: ${backupdirectory}/${dailyhourlyweeklymonthly}/${backup}"

# ask for permission to proceed
echo "I will now delete the current world-directory and replace it with your chosen backup"
echo "You have chosen: ${backupdirectory}/${dailyhourlyweeklymonthly}/${backup} as a backup to restore"
read -p "Continue? [Y/N]: "

# if user replys yes perform restore
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	cd ${serverdirectory}
	echo "${cyan}restoring backup...${nocolor}"
	mv ${serverdirectory}/world ${serverdirectory}/old-world
	cp ${backupdirectory}/${dailyhourlyweeklymonthly}/${backup} ${serverdirectory}
	mv ${backup} world.tar.gz
	tar -xf world.tar.gz
	rm world.tar.gz
	if [ -d "world" ]; then
		echo "${green}restore successful${nocolor}"
		echo "${cyan}restarting server with restored backup...${nocolor}"
		echo "${date} the backup ${backupdirectory}/${dailyhourlyweeklymonthly}/${backup} has been restored" >> ${screenlog}
		rm -r ${serverdirectory}/old-world
	else
		echo "${red}fatal: something went wrong - could not restore backup${nocolor}"
		echo "fatal: something went wrong - could not restore backup" >> ${screenlog}
		mv ${serverdirectory}/old-world ${serverdirectory}/world
	fi
	./start.sh "$@"
# if user replys no cancel and restart server
else cd ${serverdirectory}
	echo "${yellow}canceling backup restore...${nocolor}"
	echo "${cyan}restarting server...${nocolor}"
	echo "info: backup restore has been canceled" >> ${screenlog}
	echo "info: resuming to current live world" >> ${screenlog}
	./start.sh "$@"
fi

# exit with code 0
exit 0
