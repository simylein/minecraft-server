#!/bin/bash
# minecraft server restore script

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
	exit 1
fi

# read server.properties file with error checking
if ! [[ -f "server.properties" ]]; then
	echo "fatal: server.properties is missing" >> fatalerror.log
	echo "fatal: server.properties is missing"
	exit 1
fi

# read server.settings file with error checking
if [[ -f "server.settings" ]]; then
	. ./server.settings
else
	echo "fatal: server.settings is missing" >> fatalerror.log
	echo "fatal: server.settings is missing"
	exit 1
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
echo "${date} executing restore script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo -e "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# countdown
counter="60"
while [ ${counter} -gt 0 ]; do
	if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
		echo -e "${blue}[Script]${nocolor} server is restoring a backup in ${counter} seconds"
		screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\",\"italic\":false},{\"text\":\"server is restoring a backup in ${counter} seconds\"}]$(printf '\r')"
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

# output confirmed stop
echo -e "${green}server successfully stopped!${nocolor}"

# remove all older safety backups
if [[ -s "${backupdirectory}/cached/restore-"* ]]; then
	rm ${backupdirectory}/cached/restore-*
fi

# create backup
echo -e "${blue}backing up...${nocolor}"
tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/cached/restore-${newdaily}.tar.gz

# check if safety backup exists
if ! [[ -s "${backupdirectory}/cached/restore-${newdaily}.tar.gz" ]]; then
	echo -e "${red}warning: safety backup failed - proceeding to server restore${nocolor}"
	echo "warning: safety backup failed - proceeding to server restore" >> ${screenlog}
else
	echo "created ${backupdirectory}/cached/restore-${newdaily}.tar.gz as a safety backup" >> ${backuplog}
	echo "" >> ${backuplog}
fi

# create arrays with backupdirectorys
cd ${backupdirectory}
backups=($(ls))
cd hourly
backupshourly=($(ls))
cd ../
cd daily
backupsdaily=($(ls))
cd ../
cd weekly
backupsweekly=($(ls))
cd ../
cd monthly
backupsmonthly=($(ls))
cd ../
cd cached
backupscached=($(ls))
cd ../

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
	echo -e "${green}restoring backup...${nocolor}"
	mv ${serverdirectory}/world ${serverdirectory}/old-world
	cp ${backupdirectory}/${dailyhourlyweeklymonthly}/${backup} ${serverdirectory}
	mv ${backup} world.tar.gz
	tar -xf world.tar.gz
	rm world.tar.gz
	if [ -d "world" ]; then
		echo -e "${green}restore successful${nocolor}"
		echo -e "${blue}restarting server with restored backup...${nocolor}"
		echo "${date} the backup ${backupdirectory}/${dailyhourlyweeklymonthly}/${backup} has been restored" >> ${screenlog}
		rm -r ${serverdirectory}/old-world
	else
		echo -e "${red}something went wrong - could not restore backup${nocolor}"
		echo "something went wrong - could not restore backup" >> ${screenlog}
		mv ${serverdirectory}/old-world ${serverdirectory}/world
	fi
	./start.sh
# if user replys no cancel and restart server
else cd ${serverdirectory}
	echo -e "${yellow}canceling backup restore...${nocolor}"
	echo -e "${blue}restarting server...${nocolor}"
	echo "backup restore has been canceled" >> ${screenlog}
	echo "resuming to current live world" >> ${screenlog}
	./start.sh
fi
