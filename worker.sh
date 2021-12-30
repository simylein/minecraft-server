#!/bin/bash
# minecraft server worker script

# read server files
source server.settings
source server.functions

# safety checks
RootSafety
ScriptSafety

# parse arguments
ParseArgs "$@"

# debug
Debug "executing $0"

# change to server directory
ChangeServerDirectory

# check if server is running
CheckScreen

# run various functions every second until server exits
counter=0
while true; do
	lineBuffer=$(tail -1 "${screenLog}")
	if [[ ! ${lineBuffer} == ${lastLineBuffer} ]]; then
		if [[ ${enableWelcomeMessage} == true ]]; then
			size=${#welcome[@]}
			index=$((${RANDOM} % ${size}))
			timeStamp=$(date +"%H:%M:%S")
			if tail -1 screen.log | grep -q "joined the game"; then
				welcomeMessage=${welcome[$index]}
				player=$(tail -1 screen.log | grep -oP '.*?(?=joined the game)' | cut -d ' ' -f 4- | sed 's/.$//')
				TellrawScript "${welcomeMessage} ${player}" "player ${player} joined at ${timeStamp}"
			fi
		fi

		Help
		ListTasks
		ListBackups
		if [[ ${enablePerformBackup} == true ]]; then
			PerformBackup
		fi
		if [[ ${enablePerformRestart} == true ]]; then
			PerformRestart
		fi
		if [[ ${enablePerformUpdate} == true ]]; then
			PerformUpdate
		fi
		if [[ ${enablePerformReset} == true ]]; then
			PerformReset
		fi
	fi

	if [[ ${enableBackupsWatchdog} == true ]]; then
		if [[ ${counter} -eq 120 ]]; then
			source server.settings
			timeStamp=$(date +"%H:%M:%S")
			lastTimeStamp=$(date -d -"2 minute" +"%H:%M:%S")
			if [[ ${worldSizeBytes} -lt $((${lastWorldSizeBytes} - 65536)) ]]; then
				Log "warn" "your world-size is getting smaller - this may result in a corrupted world" "${backupLog}"
				Log "info" "world-size at ${lastTimeStamp} was ${lastWorldSizeBytes} bytes, world-size at ${timeStamp} is ${worldSizeBytes} bytes" "${backupLog}"
				TellrawScript "warn: your world-size is getting smaller - this may result in a corrupted world" "world-size at ${lastTimeStamp} was ${lastWorldSizeBytes} bytes, world-size at ${timeStamp} is ${worldSizeBytes} bytes"
			fi
			if [[ ${backupSizeBytes} -lt $((${lastBackupSizeBytes} - 65536)) ]]; then
				Log "warn" "your backup-size is getting smaller - this may result in corrupted backups" "${backupLog}"
				Log "info" "backup-size at ${lastTimeStamp} was ${lastBackupSizeBytes} bytes, backup-size at ${timeStamp} is ${backupSizeBytes} bytes" "${backupLog}"
				TellrawScript "warn: your backup-size is getting smaller - this may result in corrupted backups" "backup-size at ${lastTimeStamp} was ${lastBackupSizeBytes} bytes, backup-size at ${timeStamp} is ${backupSizeBytes} bytes"
			fi
			lastWorldSizeBytes=${worldSizeBytes}
			lastBackupSizeBytes=${backupSizeBytes}
			counter=0
		fi
	fi

	if ! screen -list | grep -q "\.${serverName}"; then
		Debug "executed $0 script"
		exit 0
	fi

	lastLineBuffer="${lineBuffer}"
	counter++
	sleep 1s
done
