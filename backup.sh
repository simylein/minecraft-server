#!/bin/bash
# minecraft server backup script

# this script is meant to be executed every hour by crontab
# 0 * * * * cd ${serverdirectory} ./backup.sh --quiet

# if you want you can change the time of day on which
# daily backups are made as an example in server.settings, but please beware:

# for the sake of integrity of your backups,
# I would strongly recommend not to mess with this file.
# if you really know what you are doing feel free to go ahead ;^)

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

# test if all categories for backups exists if not create them
CheckBackupDirectoryIntegrity


# check if hourly backups are anabled
if [ ${dohourly} = true ]; then

	# write date and execute into logfiles
	echo "${date} executing backup-hourly script" >> ${screenlog}
	echo "${date} executing backup-hourly script" >> ${backuplog}
	CheckDebug "executing backup-hourly script"
	
	# start milliseconds timer
	before=$(date +%s%3N)

	# checks for the existence of a screen terminal
	if ! screen -list | grep -q "\.${servername}"; then
		echo "${yellow}server is not currently running!${nocolor}"
		echo "info: server is not currently running!" >> ${screenlog}
		echo "info: server is not currently running!" >> ${backuplog}
		echo "" >> ${backuplog}
		exit 1
	fi

	# check if world is bigger than diskspace
	if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
		# ingame, terminal and logfile error output
		PrintToScreenNotEnoughtDiskSpace "${newhourly}" "${oldhourly}"
		PrintToLogNotEnoughDiskSpace "hourly"
		PrintToTerminalNotEnoughDiskSpace "hourly"
		CheckDebug "backup script reports not enough disk-space while performing backup-hourly"
		exit 1
	fi

	# check if disk space is getting low
	if (( (${absoluteworldsize} + ${diskspacewarning}) > ${absolutediskspace} )); then
		PrintToScreenDiskSpaceWarning "${newhourly}" "${oldhourly}"
		PrintToLogDiskSpaceWarning
		PrintToTerminalDiskSpaceWarning
		CheckDebug "backup script reports low disk-space while performing backup-hourly"
	fi

	# check if there is no backup from the current hour
	if ! [[ -s "${backupdirectory}/hourly/${servername}-${newhourly}.tar.gz" ]]; then
		if [[ -s "world.tar.gz" ]]; then
			rm world.tar.gz
		fi
		PrintToScreen "save-off"
		tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/hourly/${servername}-${newhourly}.tar.gz
		PrintToScreen "save-on"
	else
		PrintToScreenBackupAlreadyExists "${newhourly}" "${oldhourly}"
		PrintToLogBackupAlreadyExists "hourly"
		PrintToTerminalBackupAlreadyExists "hourly"
		CheckDebug "backup script reports backup already exists while performing backup-hourly"
		exit 1
	fi

	# check if there is a new backup
	if [[ -s "${backupdirectory}/hourly/${servername}-${newhourly}.tar.gz" ]]; then
		# check if an old backup exists an remove it
		if [[ -s "${backupdirectory}/hourly/${servername}-${oldhourly}.tar.gz" ]]; then
			rm ${backupdirectory}/hourly/${servername}-${oldhourly}.tar.gz
		fi
		# stop milliseconds timer
		after=$(date +%s%3N)
		# calculate time spent on backup process
		timespent=$((${after}-${before}))
		# get compressed backup size
		compressedbackup=$(du -sh ${backupdirectory}/hourly/${servername}-${newhourly}.tar.gz | cut -f1)
		# read server.settings file again
		. ./server.settings
		# ingame and logfile success output
		PrintToScreenBackupSuccess "${newhourly}" "${oldhourly}"
		PrintToLogBackupSuccess "${newhourly}" "${oldhourly}"
		PrintToTerminalBackupSuccess "${newhourly}" "${oldhourly}"
		CheckDebug "backup script reports backup success while performing backup-hourly"
	else
		# ingame and logfile error output
		PrintToScreenBackupError "${newhourly}" "${oldhourly}"
		PrintToLogBackupError
		PrintToTerminalBackupError
		CheckDebug "backup script reports backup error while performing backup-hourly"
	fi

else
	# write to logfiles that it's disabled
	CheckDebug "info: backup-hourly is disabled"
	echo "info: backup-hourly is disabled" >> ${backuplog}
	echo "" >> ${backuplog}
fi


# check if it is the right time
if [ ${hours} -eq ${dailybackuptime} ]; then

	# write date and execute into logfiles
	echo "${date} executing backup-daily script" >> ${screenlog}
	echo "${date} executing backup-daily script" >> ${backuplog}
	CheckDebug "executing backup-daily script"

	# check if daily backups are anabled
	if [ ${dodaily} = true ]; then

		# start milliseconds timer
		before=$(date +%s%3N)

		# checks for the existence of a screen terminal
		if ! screen -list | grep -q "\.${servername}"; then
			echo "${yellow}server is not currently running!${nocolor}"
			echo "info: server is not currently running!" >> ${screenlog}
			echo "info: server is not currently running!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi

		# check if world is bigger than diskspace
		if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
			# ingame, terminal and logfile error output
			PrintToScreenNotEnoughtDiskSpace "${newdaily}" "${olddaily}"
			PrintToLogNotEnoughDiskSpace "daily"
			PrintToTerminalNotEnoughDiskSpace "daily"
			CheckDebug "backup script reports not enough disk-space while performing backup-daily"
			exit 1
		fi

		# check if disk space is getting low
		if (( (${absoluteworldsize} + ${diskspacewarning}) > ${absolutediskspace} )); then
			PrintToScreenDiskSpaceWarning "${newdaily}" "${olddaily}"
			PrintToLogDiskSpaceWarning
			PrintToTerminalDiskSpaceWarning
			CheckDebug "backup script reports low disk-space while performing backup-daily"
		fi

		# check if there is no backup from the current day
		if ! [[ -s "${backupdirectory}/daily/${servername}-${newdaily}.tar.gz" ]]; then
			if [[ -s "world.tar.gz" ]]; then
				rm world.tar.gz
			fi
			PrintToScreen "save-off"
			tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/daily/${servername}-${newdaily}.tar.gz
			PrintToScreen "save-on"
		else
			PrintToScreenBackupAlreadyExists "${newdaily}" "${olddaily}"
			PrintToLogBackupAlreadyExists "daily"
			PrintToTerminalBackupAlreadyExists "daily"
			CheckDebug "backup script reports backup already exists while performing backup-daily"
			exit 1
		fi

		# check if there is a new backup
		if [[ -s "${backupdirectory}/daily/${servername}-${newdaily}.tar.gz" ]]; then
			# check if an old backup exists an remove it
			if [[ -s "${backupdirectory}/daily/${servername}-${olddaily}.tar.gz" ]]; then
				rm ${backupdirectory}/daily/${servername}-${olddaily}.tar.gz
			fi
			# stop milliseconds timer
			after=$(date +%s%3N)
			# calculate time spent on backup process
			timespent=$((${after}-${before}))
			# get compressed backup size
			compressedbackup=$(du -sh ${backupdirectory}/daily/${servername}-${newdaily}.tar.gz | cut -f1)
			# read server.settings file again
			. ./server.settings
			# ingame and logfile success output
			PrintToScreenBackupSuccess "${newdaily}" "${olddaily}"
			PrintToLogBackupSuccess "${newdaily}" "${olddaily}"
			PrintToTerminalBackupSuccess "${newdaily}" "${olddaily}"
			CheckDebug "backup script reports backup success while performing backup-daily"
		else
			# ingame and logfile error output
			PrintToScreenBackupError "${newdaily}" "${olddaily}"
			PrintToLogBackupError
			PrintToTerminalBackupError
			CheckDebug "backup script reports backup error while performing backup-daily"
		fi

	else
		# write to logfiles that it's disabled
		CheckDebug "info: backup-daily is disabled"
		echo "info: backup-daily is disabled" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
fi


# check if it is the right time and weekday
if [ ${hours} -eq ${dailybackuptime} ] && [ ${weekday} -eq ${weeklybackupday} ]; then

	# write date and execute into logfiles
	echo "${date} executing backup-weekly script" >> ${screenlog}
	echo "${date} executing backup-weekly script" >> ${backuplog}
	CheckDebug "executing backup-weekly script"

	# check if weekly backups are enabled
	if [ ${doweekly} = true ]; then

		# start milliseconds timer
		before=$(date +%s%3N)

		# checks for the existence of a screen terminal
		if ! screen -list | grep -q "\.${servername}"; then
			echo "${yellow}server is not currently running!${nocolor}"
			echo "info: server is not currently running!" >> ${screenlog}
			echo "info: server is not currently running!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi

		# check if world is bigger than diskspace
		if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
			# ingame, terminal  and logfile error output
			PrintToScreenNotEnoughtDiskSpace "${newweekly}" "${oldweekly}"
			PrintToLogNotEnoughDiskSpace "weekly"
			PrintToTerminalNotEnoughDiskSpace "weekly"
			CheckDebug "backup script reports not enough disk-space while performing backup-weekly"
			exit 1
		fi

		# check if disk space is getting low
		if (( (${absoluteworldsize} + ${diskspacewarning}) > ${absolutediskspace} )); then
			PrintToScreenDiskSpaceWarning "${newweekly}" "${oldweekly}"
			PrintToLogDiskSpaceWarning
			PrintToTerminalDiskSpaceWarning
			CheckDebug "backup script reports low disk-space while performing backup-weekly"
		fi

		# check if there is no backup from the current week
		if ! [[ -s "${backupdirectory}/weekly/${servername}-${newweekly}.tar.gz" ]]; then
			if [[ -s "world.tar.gz" ]]; then
				rm world.tar.gz
			fi
			PrintToScreen "save-off"
			tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/weekly/${servername}-${newweekly}.tar.gz
			PrintToScreen "save-on"
		else
			PrintToScreenBackupAlreadyExists "${newweekly}" "${oldweekly}"
			PrintToLogBackupAlreadyExists "weekly"
			PrintToTerminalBackupAlreadyExists "weekly"
			CheckDebug "backup script reports backup already exists while performing backup-weekly"
			exit 1
		fi

		# check if there is a new backup
		if [[ -s "${backupdirectory}/weekly/${servername}-${newweekly}.tar.gz" ]]; then
			# check if an old backup exists an remove it
			if [[ -s "${backupdirectory}/weekly/${servername}-${oldweekly}.tar.gz" ]]; then
				rm ${backupdirectory}/weekly/${servername}-${oldweekly}.tar.gz
			fi
			# stop milliseconds timer
			after=$(date +%s%3N)
			# calculate time spent on backup process
			timespent=$((${after}-${before}))
			# get compressed backup size
			compressedbackup=$(du -sh ${backupdirectory}/weekly/${servername}-${newweekly}.tar.gz | cut -f1)
			# read server.settings file again
			. ./server.settings
			# ingame and logfile success output
			PrintToScreenBackupSuccess "${newweekly}" "${oldweekly}"
			PrintToLogBackupSuccess "${newweekly}" "${oldweekly}"
			PrintToTerminalBackupSuccess "${newweekly}" "${oldweekly}"
			CheckDebug "backup script reports backup success while performing backup-weekly"
		else
			# ingame and logfile error output
			PrintToScreenBackupError "${newweekly}" "${oldweekly}"
			PrintToLogBackupError
			PrintToTerminalBackupError
			CheckDebug "backup script reports backup error while performing backup-weekly"
		fi

	else
		# write to logfiles that it's disabled
		CheckDebug "info: backup-weekly is disabled"
		echo "info: backup-weekly is disabled" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
fi


# check if it is the right time and day of the month
if [ ${hours} -eq ${dailybackuptime} ] && [ ${dayofmonth} -eq ${monthlybackupday} ]; then

	# write date and execute into logfiles
	echo "${date} executing backup-monthly script" >> ${screenlog}
	echo "${date} executing backup-monthly script" >> ${backuplog}
	CheckDebug "executing backup-monthly script"

	# check if monthly backups are enabled
	if [ ${domonthly} = true ]; then

		# start milliseconds timer
		before=$(date +%s%3N)

		# checks for the existence of a screen terminal
		if ! screen -list | grep -q "\.${servername}"; then
			echo "${yellow}server is not currently running!${nocolor}"
			echo "info: server is not currently running!" >> ${screenlog}
			echo "info: server is not currently running!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi

		# check if world is bigger than diskspace
		if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
			# ingame, terminal and logfile error output
			PrintToScreenNotEnoughtDiskSpace "${newmonthly}" "${oldmonthly}"
			PrintToLogNotEnoughDiskSpace "monthly"
			PrintToTerminalNotEnoughDiskSpace "monthly"
			CheckDebug "backup script reports not enough disk-space while performing backup-monthly"
			exit 1
		fi

		# check if disk space is getting low
		if (( (${absoluteworldsize} + ${diskspacewarning}) > ${absolutediskspace} )); then
			PrintToScreenDiskSpaceWarning "${newmonthly}" "${oldmonthly}"
			PrintToLogDiskSpaceWarning
			PrintToTerminalDiskSpaceWarning
			CheckDebug "backup script reports low disk-space while performing backup-monthly"
		fi

		# check if there is no backup from the current month
		if ! [[ -s "${backupdirectory}/monthly/${servername}-${newmonthly}.tar.gz" ]]; then
			if [[ -s "world.tar.gz" ]]; then
				rm world.tar.gz
			fi
			PrintToScreen "save-off"
			tar -czf world.tar.gz world && mv ${serverdirectory}/world.tar.gz ${backupdirectory}/monthly/${servername}-${newmonthly}.tar.gz
			PrintToScreen "save-on"
		else
			PrintToScreenBackupAlreadyExists "${newmonthly}" "${oldmonthly}"
			PrintToLogBackupAlreadyExists "monthly"
			PrintToTerminalBackupAlreadyExists "monthly"
			CheckDebug "backup script reports backup already exists while performing backup-monthly"
			exit 1
		fi

		# check if there is a new backup
		if [[ -s "${backupdirectory}/monthly/${servername}-${newmonthly}.tar.gz" ]]; then
			# check if an old backup exists an remove it
			if [[ -s "${backupdirectory}/monthly/${servername}-${oldmonthly}.tar.gz" ]]; then
				rm ${backupdirectory}/monthly/${servername}-${oldmonthly}.tar.gz
			fi
			# stop milliseconds timer
			after=$(date +%s%3N)
			# calculate time spent on backup process
			timespent=$((${after}-${before}))
			# get compressed backup size
			compressedbackup=$(du -sh ${backupdirectory}/monthly/${servername}-${newmonthly}.tar.gz | cut -f1)
			# read server.settings file again
			. ./server.settings
			# ingame and logfile success output
			PrintToScreenBackupSuccess "${newmonthly}" "${oldmonthly}"
			PrintToLogBackupSuccess "${newmonthly}" "${oldmonthly}"
			PrintToTerminalBackupSuccess "${newmonthly}" "${oldmonthly}"
			CheckDebug "backup script reports backup success while performing backup-monthly"
		else
			# ingame and logfile error output
			PrintToScreenBackupError "${newmonthly}" "${oldmonthly}"
			PrintToLogBackupError
			PrintToTerminalBackupError
			CheckDebug "backup script reports backup error while performing backup-monthly"
		fi

	else
		# write to logfiles that it's disabled
		CheckDebug "info: backup-monthly is disabled"
		echo "info: backup-monthly is disabled" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
fi

# exit with code 0
exit 0
