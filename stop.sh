#!/bin/bash
# minecraft server stop script

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

# log to debug if true
CheckDebug "executing stop script"

# parsing script arguments
ParseScriptArguments "$@"

# check for script lock
CheckScriptLock

# write date to logfile
PrintToLog "action" "${date} executing stop script" "${screenlog}"

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# prints countdown to screen
PerformCountdown "stopping"

# server stop
PerformServerStop

# awaits server stop
AwaitServerStop

# force quit server if not stopped
ConditionalForceQuit

# output confirmed stop
PrintToLog "ok" "server successfully stopped!" "${screenlog}"
CheckQuiet "ok" "server successfully stopped!"

# log to debug if true
CheckDebug "executed stop script"

# exit with code 0
exit 0
