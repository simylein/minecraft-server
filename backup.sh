#!/bin/bash
# minecraft server backup script

# for the sake of integrity of your backups,
# I would strongly recommend not to mess with this file.
# if you really know what you are doing feel free to go ahead ;^)

# read server files
source server.settings
source server.functions

# parse backup category
ParseCategory "$@"

# shift args
shift

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

# check if server is running
CheckScreen

# test all categories
BackupDirectoryIntegrity

# main backup function
function RunBackup {
	Debug "executing backup-${1} script"
	# check if disk space is too low
	if (((${worldSizeBytes} + ${diskSpaceError}) > ${diskSpaceBytes})); then
		OutputDiskSpaceError "${1}" "${2}" "${3}"
		exit 1
	fi
	# check is getting low
	if (((${worldSizeBytes} + ${diskSpaceWarning}) > ${diskSpaceBytes})); then
		OutputDiskSpaceWarning "${1}"
	fi
	# check if backup already exists
	if ! [[ -s "${backupDirectory}/${1}/${serverName}-${2}.tar.gz" ]]; then
		# disable auto save
		Screen "save-off"
		sleep 1s
		before=$(date +%s%3N)
		# copy world
		nice -n 19 cp -r "world" "tmp-${1}"
		if [ $? != 0 ]; then
			OutputBackupCopyError "${1}" "${2}" "${3}"
			rm -r "tmp-${1}"
			exit 1
		fi
		# compress world
		nice -n 19 tar -czf "world-${1}.tar.gz" "tmp-${1}"
		if [ $? != 0 ]; then
			OutputBackupTarError "${1}" "${2}" "${3}"
			rm -r "world-${1}.tar.gz" "tmp-${1}"
			exit 1
		fi
		# mv backup and remove tmp
		nice -n 19 mv "${serverDirectory}/world-${1}.tar.gz" "${backupDirectory}/${1}/${serverName}-${2}.tar.gz"
		nice -n 19 rm -r "tmp-${1}"
		# enable auto save
		after=$(date +%s%3N)
		Screen "save-on"
		sleep 1s
	else
		OutputBackupAlreadyExists "${1}" "${2}" "${3}"
		exit 1
	fi
	if [[ -s "${backupDirectory}/${1}/${serverName}-${2}.tar.gz" ]]; then
		# remove old backup if it exists
		if [[ -s "${backupDirectory}/${1}/${serverName}-${3}.tar.gz" ]]; then
			nice -n 19 rm "${backupDirectory}/${1}/${serverName}-${3}.tar.gz"
		fi
		# calculate time spent and compression
		timeSpent=$((${after} - ${before}))
		compressedBackupSize=$(du -sh ${backupDirectory}/${1}/${serverName}-${2}.tar.gz | cut -f1)
		compressedBackupSizeBytes=$(du -s ${backupDirectory}/${1}/${serverName}-${2}.tar.gz | cut -f1)
		# TODO: fix this buggy mess
		# check if backup size is to small for a real backup
		if ((${compressedBackupSizeBytes} < (${worldSizeBytes} / (100 * ${backupSizeError})))); then
			OutputBackupSizeError "${1}" "${2}" "${3}"
			exit 1
		fi
		# TODO: fix this buggy mess
		# check if backup size is suspiciously small
		if ((${compressedBackupSizeBytes} < (${worldSizeBytes} / (100 * ${backupSizeWarning})))); then
			OutputBackupSizeWarning "${1}" "${2}" "${3}"
		fi
		# read settings and output success
		source server.settings
		OutputBackupSuccess "${1}" "${2}" "${3}"
	else
		OutputBackupGenericError "${1}" "${2}" "${3}"
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
