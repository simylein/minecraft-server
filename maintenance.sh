#!/bin/bash
# minecraft server maintenance script

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
echo "${date} executing maintenance script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo -e "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# countdown
counter="60"
while [ ${counter} -gt 0 ]; do
	if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
		echo -e "${blue}[Script]${nocolor} server is going into maintenance in ${counter} seconds"
		screen -Rd ${servername} -X stuff "tellraw @a [\"\",{\"text\":\"[Script] \",\"color\":\"blue\"},{\"text\":\"server is going into maintenance in ${counter} seconds\"}]$(printf '\r')"
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
sleep 1s
done

# force quit server if not stopped
if screen -list | grep -q "${servername}"; then
	echo -e "${yellow}minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
	screen -S ${servername} -X quit
fi

# output confirmed stop
echo -e "${green}server successfully stopped!${nocolor}"

# remove all older safety backups
if [ -d "${backupdirectory}/cached/maintenance-"* ]; then
	rm -r ${backupdirectory}/cached/maintenance-*
fi

# create backup
echo -e "${blue}backing up...${nocolor}"
cp -r ${serverdirectory}/world ${backupdirectory}/cached/maintenance-${newdaily}

# check if safety backup exists
if ! [ -d "${backupdirectory}/cached/maintenance-${newdaily}" ]; then
	echo -e "${red}warning: safety backup failed - proceeding to server maintenance${nocolor}"
	echo "warning: safety backup failed - proceeding to server maintenance" >> ${screenlog}
else
	echo "created ${backupdirectory}/cached/maintenance-${newdaily} as a safety backup" >> ${backuplog}
	echo "" >> ${backuplog}
	echo "have fun with maintenance ;^)"
fi
