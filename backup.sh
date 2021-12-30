#!/bin/bash
# minecraft server backup script

# for the sake of integrity of your backups,
# I would strongly recommend not to mess with this file.
# if you really know what you are doing feel free to go ahead ;^)

# read server files
source server.settings
source server.functions

# safety checks
RootSafety
ScriptSafety

# parse backup category
ParseCategory "$@"

# shift args
shift

# parse arguments
ParseArgs "$@"

# debug
Debug "executing $0 script"

# change to server directory
ChangeServerDirectory

# check if server is running
CheckScreen

# test all categories
BackupDirectoryIntegrity

# main backup function
function RunBackup {
	Debug "executing backup-${1} script"
	if (((${worldSizeBytes} + ${diskSpaceError}) > ${diskSpaceBytes})); then
		OutputDiskSpaceError "${1}" "${2}" "${3}"
		Debug "backup script reports not enough disk-space while performing backup-${1}"
		exit 1
	fi
	if (((${worldSizeBytes} + ${diskSpaceWarning}) > ${diskSpaceBytes})); then
		OutputDiskSpaceWarning
		Debug "backup script reports low disk-space while performing backup-${1}"
	fi
	if ! [[ -s "${backupDirectory}/${1}/${serverName}-${2}.tar.gz" ]]; then
		Screen "save-off"
		sleep 1s
		before=$(date +%s%3N)
		nice -n 19 cp -r "world" "tmp"
		nice -n 19 tar -czf "world.tar.gz" "tmp"
		if [ $? != 0 ]; then
			OutputBackupTarError "${2}" "${3}"
			Debug "backup script reports tar error while performing backup-${1}"
		fi
		nice -n 19 mv "${serverDirectory}/world.tar.gz" "${backupDirectory}/${1}/${serverName}-${2}.tar.gz"
		nice -n 19 rm -r "tmp"
		after=$(date +%s%3N)
		Screen "save-on"
		sleep 1s
		timeSpent=$((${after} - ${before}))
	else
		OutputBackupAlreadyExists "${1}" "${2}" "${3}"
		Debug "backup script reports backup already exists while performing backup-${1}"
		exit 1
	fi
	if [[ -s "${backupDirectory}/${1}/${serverName}-${2}.tar.gz" ]]; then
		if [[ -s "${backupDirectory}/${1}/${serverName}-${3}.tar.gz" ]]; then
			nice -n 19 rm "${backupDirectory}/${1}/${serverName}-${3}.tar.gz"
		fi
		compressedBackupSize=$(du -sh ${backupDirectory}/${1}/${serverName}-${2}.tar.gz | cut -f1)
		source server.settings
		OutputBackupSuccess "${1}" "${2}" "${3}"
		Debug "backup script reports backup success while performing backup-${1}"
	else
		OutputBackupGenericError "${2}" "${3}"
		Debug "backup script reports backup error while performing backup-${1}"
	fi
	Debug "executed backup-${1} script"
}

# hourly backup
if [ ${isHourly} == true ]; then
	if [ ${doHourly} == true ]; then
		# run backup
		RunBackup "hourly" "${newHourly}" "${oldHourly}"
	else
		Log "info" "backup-hourly is disabled" "${backupLog}"
		Print "info" "backup-hourly is disabled"
	fi
fi

# daily backup
if [ ${isDaily} == true ]; then
	if [ ${doDaily} == true ]; then
		# run backup
		RunBackup "daily" "${newDaily}" "${oldDaily}"
	else
		Log "info" "backup-daily is disabled" "${backupLog}"
		Print "info" "backup-daily is disabled"
	fi
fi

# weekly backup
if [ ${isWeekly} == true ]; then
	if [ ${doWeekly} == true ]; then
		# run backup
		RunBackup "weekly" "${newWeekly}" "${oldWeekly}"
	else
		Log "info" "backup-weekly is disabled" "${backupLog}"
		Print "info" "backup-weekly is disabled"
	fi
fi

# monthly backup
if [ ${isMonthly} == true ]; then
	if [ ${doMonthly} == true ]; then
		# run backup
		RunBackup "monthly" "${newMonthly}" "${oldMonthly}"
	else
		Log "info" "backup-monthly is disabled" "${backupLog}"
		Print "info" "backup-monthly is disabled"
	fi
fi

# debug
Debug "executed $0 script"

# exit with code 0
exit 0
