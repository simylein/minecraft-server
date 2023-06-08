#!/bin/bash
# minecraft server start script

# read server files
source server.settings
source server.functions

# parse arguments
ParseArgs "$@"
ArgHelp

# safety checks
RootSafety
ScriptSafety

# debug
Debug "executing $0 script"

# change to server directory
ChangeServerDirectory

# check for existence of executable
CheckExecutable

# look if server is running
LookForScreen

# check if private network is online
CheckPrivate

# check if public network is online
CheckPublic

# user information
Print "info" "starting minecraft server. to view window type screen -r ${serverName}."
Print "info" "to minimise the window and let the server run in the background, press ctrl+a then ctrl+d"

# main start command
Start

# check if screen is available
AwaitStart

# if no screen output error
if ! screen -list | grep -q "${serverName}"; then
	Log "fatal" "something went wrong - server failed to start!" "${screenLog}"
	Print "fatal" "something went wrong - server failed to start!"
	Print "info" "crash dump - last 10 lines of ${screenLog}"
	tail -10 "${screenLog}"
	exit 1
fi

# successful start sequence
Log "ok" "server is on startup..." "${screenLog}"
Print "ok" "server is on startup..."

# check if screen log contains start confirmation
count="0"
counter="0"
startupChecks="0"
while [ ${startupChecks} -lt 120 ]; do
	if tail "${screenLog}" | grep -q "Time elapsed:"; then
		Log "ok" "server startup successful - up and running" "${screenLog}"
		Print "ok" "server startup successful - up and running"
		break
	fi
	if tail -20 "${screenLog}" | grep -q "FAILED TO BIND TO PORT"; then
		Log "error" "server port is already in use - please change to another port" "${screenLog}"
		Print "error" "server port is already in use - please change to another port"
		exit 1
	fi
	if tail -20 "${screenLog}" | grep -q "Address already in use"; then
		Log "error" "server address is already in use - please change to another port" "${screenLog}"
		Print "error" "server address is already in use - please change to another port"
		exit 1
	fi
	if tail -20 "${screenLog}" | grep -q "session.lock: already locked"; then
		Log "error" "session is locked - is the world in use by another instance?" "${screenLog}"
		Print "error" "session is locked - is the world in use by another instance?"
		exit 1
	fi
	if ! screen -list | grep -q "${serverName}"; then
		Log "fatal" "something went wrong - server appears to have crashed!" "${screenLog}"
		Print "fatal" "something went wrong - server appears to have crashed!"
		Print "info" "crash dump - last 10 lines of ${screenLog}"
		tail -10 "${screenLog}"
		exit 1
	fi
	if tail "${screenLog}" | grep -q "Preparing spawn area"; then
		counter=$((counter + 1))
	fi
	if tail "${screenLog}" | grep -q "Environment"; then
		if [ ${count} -eq 0 ]; then
			Print "info" "server is loading the environment..."
		fi
		count=$((count + 1))
	fi
	if tail "${screenLog}" | grep -q "Reloading ResourceManager"; then
		count=$((count + 1))
	fi
	if tail "${screenLog}" | grep -q "Starting minecraft server"; then
		count=$((count + 1))
	fi
	if [ ${counter} -ge 10 ]; then
		Print "info" "server is preparing spawn area..."
		counter="0"
	fi
	if [ ${count} -eq 0 ] && [ ${startupChecks} -eq 20 ]; then
		Log "warn" "the server could be crashed" "${screenLog}"
		Print "warn" "the server could be crashed"
		exit 1
	fi
	startupChecks=$((startupChecks + 1))
	sleep 1s
done

# check if screen log does not contain startup confirmation
if ! tail "${screenLog}" | grep -q "Time elapsed:"; then
	Log "warn" "server startup unsuccessful" "${screenLog}"
	Print "warn" "server startup unsuccessful"
	Print "info" "crash dump - last 10 lines of ${screenLog}"
	tail -10 "${screenLog}"
fi

# enable worker script
nice -n 19 ./worker.sh &

if [[ "${enableBackupsWatchdog}" == true ]]; then
	Print "info" "activating backups watchdog..."
fi
if [[ "${enableWelcomeMessage}" == true ]]; then
	Print "info" "activating welcome messages..."
fi
if [[ "${enableAutoStartOnCrash}" == true ]]; then
	Print "info" "activating auto start on crash..."
fi
if [[ "${changeToConsole}" == true ]]; then
	Print "info" "changing to server console..."
	screen -r "${serverName}"
fi

Print "info" "if you would like to change to server console - type screen -r ${serverName}"

Debug "executed $0 script"

exit 0
