#!/bin/bash

# minecraft server task script
# can be executed detached with ./task.sh &

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

# write date to logfile
echo "${date} executing task script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# check every second if a player with permission request a task
while true; do
	# check if safety backup is enabled
	if [[ ${enablesafetybackupstring} == true ]]; then
		CheckSafetyBackupString
	fi
	# check if safety backup is enabled
	if [[ ${enableconfirmrestartstring} == true ]]; then
		CheckConfirmRestartString
	fi
	# check if safety backup is enabled
	if [[ ${enableconfirmupdatestring} == true ]]; then
		CheckConfirmUpdateString
	fi
	# check if safety backup is enabled
	if [[ ${enableconfirmresetstring} == true ]]; then
		CheckConfirmResetString
	fi
	# exit check if server is shut down
	if ! screen -list | grep -q "\.${servername}"; then
		exit 0
	fi
	sleep 1s
done
