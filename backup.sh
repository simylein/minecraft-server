#!/bin/bash
# minecraft server backup script

# this script is meant to be executed every hour by crontab

# for the sake of integrety of your backups,
# I would recommend not ot mess with this file.
# if you know what you are doing feel free to go ahead ;^)

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


# performs backup hourly every hour

# check if hourly backups are anabled
if [ ${dohourly} = true ]; then

	# write date and execute into logfiles
	echo "${date} executing backup-hourly script" >> ${screenlog}
	echo "${date} executing backup-hourly script" >> ${backuplog}

	# checks for the existence of a screen terminal
	if ! screen -list | grep -q "\.${servername}"; then
		echo -e "${yellow}server is not currently running!${nocolor}"
		echo "server is not currently running!" >> ${screenlog}
		echo "server is not currently running!" >> ${backuplog}
		echo "" >> ${backuplog}
		exit 1
	fi

	# check if world is bigger than diskspace
	if (( (${absoluteworldsize} + 65536) > ${absolutediskspace} )); then
		echo -e "${red}fatal: not enough disk-space to perform backup-hourly${nocolor}"
		echo "fatal: not enough disk-space to perform backup-hourly" >> ${backuplog}
		echo "" >> ${backuplog}
		# ingame logfile error output
		PrintToScreenNotEnoughtDiskSpace "${newhourly}" "${oldhourly}"
		exit 1
	fi

	# check if there is no backup from the current hour
	if ! [ -d "${backupdirectory}/hourly/${servername}-${newhourly}" ]; then
		cp -r ${serverdirectory}/world ${backupdirectory}/hourly/${servername}-${newhourly}
	else
		echo "warning: backup already exists!" >> ${backuplog}
		echo "" >> ${backuplog}
		exit 1
	fi

	# read server.settings file again with error checking
	if [[ -f "server.settings" ]]; then
		. ./server.settings
	else
		echo "fatal: server.settings is missing" >> fatalerror.log
		echo "fatal: server.settings is missing"
		exit 1
	fi

	# check if there is a new backup
	if [ -d "${backupdirectory}/hourly/${servername}-${newhourly}" ]; then
		# check if an old backup exists an remove it
		if [ -d "${backupdirectory}/hourly/${servername}-${oldhourly}" ]; then
			rm -r ${backupdirectory}/hourly/${servername}-${oldhourly}
		fi
		# ingame and logfile success output
		PrintToScreenBackupSuccess "${newhourly}" "${oldhourly}"
		echo "newest backup has been successfully created!" >> ${backuplog}
		echo "added ${backupdirectory}/hourly/${servername}-${newhourly}" >> ${backuplog}
		echo "oldest backup has been successfully removed!" >> ${backuplog}
		echo "removed ${backupdirectory}/hourly/${servername}-${oldhourly}" >> ${backuplog}
		echo "current world size: ${worldsize}, current backup size: ${backupsize}, current disk space: ${diskspace}" >> ${backuplog}
		echo "" >> ${backuplog}
	else
		# ingame and logfile error output
		PrintToScreenBackupError "${newhourly}" "${oldhourly}"
		echo "warning: cannot remove old backup because new backup is missing" >> ${backuplog}
		echo "warning: could not remove old backup!" >> ${backuplog}
		echo "fatal: could not backup world!" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
else
	# write date and execute into logfiles
	echo "${date} executing backup-hourly script" >> ${screenlog}
	echo "${date} executing backup-hourly script" >> ${backuplog}
	
	# write to logfiles that it's disabled
	echo "backup-hourly is disabled" >> ${backuplog}
	echo "" >> ${backuplog}
fi


# performs backup daily if it is 22:??

# check if it is 22:??
hours=$(date +"%H")
if [ ${hours} -eq 22 ]; then
	
	# check if daily backups are anabled
	if [ ${dodaily} = true ]; then

		# write date and execute into logfiles
		echo "${date} executing backup-daily script" >> ${screenlog}
		echo "${date} executing backup-daily script" >> ${backuplog}
		
		# checks for the existence of a screen terminal
		if ! screen -list | grep -q "\.${servername}"; then
			echo -e "${yellow}server is not currently running!${nocolor}"
			echo "server is not currently running!" >> ${screenlog}
			echo "server is not currently running!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi
		
		# check if world is bigger than diskspace
		if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
			echo -e "${red}fatal: not enough disk-space to perform backup-daily${nocolor}"
			echo "fatal: not enough disk-space to perform backup-daily" >> ${backuplog}
			echo "" >> ${backuplog}
			# ingame logfile error output
			PrintToScreenNotEnoughtDiskSpace "${newdaily}" "${olddaily}"
			exit 1
		fi
		
		# check if there is no backup from the current day
		if ! [ -d "${backupdirectory}/daily/${servername}-${newdaily}" ]; then
			cp -r ${serverdirectory}/world ${backupdirectory}/daily/${servername}-${newdaily}
		else
			echo "warning: backup already exists!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi
		
		# read server.settings file again with error checking
		if [[ -f "server.settings" ]]; then
			. ./server.settings
		else
			echo "fatal: server.settings is missing" >> fatalerror.log
			echo "fatal: server.settings is missing"
			exit 1
		fi
		
		# check if there is a new backup
		if [ -d "${backupdirectory}/daily/${servername}-${newdaily}" ]; then
			# check if an old backup exists an remove it
			if [ -d "${backupdirectory}/daily/${servername}-${olddaily}" ]; then
				rm -r ${backupdirectory}/daily/${servername}-${olddaily}
			fi
			# ingame and logfile success output
			PrintToScreenBackupSuccess "${newdaily}" "${olddaily}"
			echo "newest backup has been successfully created!" >> ${backuplog}
			echo "added ${backupdirectory}/daily/${servername}-${newdaily}" >> ${backuplog}
			echo "oldest backup has been successfully removed!" >> ${backuplog}
			echo "removed ${backupdirectory}/daily/${servername}-${olddaily}" >> ${backuplog}
			echo "current world size: ${worldsize}, current backup size: ${backupsize}, current disk space: ${diskspace}" >> ${backuplog}
			echo "" >> ${backuplog}
		else
			# ingame and logfile error output
			PrintToScreenBackupError "${newdaily}" "${olddaily}"
			echo "warning: cannot remove old backup because new backup is missing" >> ${backuplog}
			echo "warning: could not remove old backup!" >> ${backuplog}
			echo "fatal: could not backup world!" >> ${backuplog}
			echo "" >> ${backuplog}
		fi

	else
		# write date and execute into logfiles
		echo "${date} executing backup-daily script" >> ${screenlog}
		echo "${date} executing backup-daily script" >> ${backuplog}

		# write to logfiles that it's disabled
		echo "backup-daily is disabled" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
fi


# performs backup weekly if it is 22:?? and Sunday

# check if it is 22:?? and Sunday
hours=$(date +"%H")
weekday=$(date +"%u")
if [ ${hours} -eq 22 ] && [ ${weekday} -eq 7 ]; then
	
	# check if weekly backups are enabled
	if [ ${doweekly} = true ]; then

		# write date and execute into logfiles
		echo "${date} executing backup-weekly script" >> ${screenlog}
		echo "${date} executing backup-weekly script" >> ${backuplog}
		
		# checks for the existence of a screen terminal
		if ! screen -list | grep -q "\.${servername}"; then
			echo -e "${yellow}server is not currently running!${nocolor}"
			echo "server is not currently running!" >> ${screenlog}
			echo "server is not currently running!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi
		
		# check if world is bigger than diskspace
		if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
			echo -e "${red}fatal: not enough disk-space to perform backup-weekly${nocolor}"
			echo "fatal: not enough disk-space to perform backup-weekly" >> ${backuplog}
			echo "" >> ${backuplog}
			# ingame logfile error output
			PrintToScreenNotEnoughtDiskSpace "${newweekly}" "${oldweekly}"
			exit 1
		fi
		
		# check if there is no backup from the current week
		if ! [ -d "${backupdirectory}/weekly/${servername}-${newweekly}" ]; then
			cp -r ${serverdirectory}/world ${backupdirectory}/weekly/${servername}-${newweekly}
		else
			echo "warning: backup already exists!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi
		
		# read server.settings file again with error checking
		if [[ -f "server.settings" ]]; then
			. ./server.settings
		else
			echo "fatal: server.settings is missing" >> fatalerror.log
			echo "fatal: server.settings is missing"
			exit 1
		fi
		
		# check if there is a new backup
		if [ -d "${backupdirectory}/weekly/${servername}-${newweekly}" ]; then
			# check if an old backup exists an remove it
			if [ -d "${backupdirectory}/weekly/${servername}-${oldweekly}" ]; then
				rm -r ${backupdirectory}/weekly/${servername}-${oldweekly}
			fi
			# ingame and logfile success output
			PrintToScreenBackupSuccess "${newweekly}" "${oldweekly}"
			echo "newest backup has been successfully created!" >> ${backuplog}
			echo "added ${backupdirectory}/weekly/${servername}-${newweekly}" >> ${backuplog}
			echo "oldest backup has been successfully removed!" >> ${backuplog}
			echo "removed ${backupdirectory}/weekly/${servername}-${oldweekly}" >> ${backuplog}
			echo "current world size: ${worldsize}, current backup size: ${backupsize}, current disk space: ${diskspace}" >> ${backuplog}
			echo "" >> ${backuplog}
		else
			# ingame and logfile error output
			PrintToScreenBackupError "${newweekly}" "${oldweekly}"
			echo "warning: cannot remove old backup because new backup is missing" >> ${backuplog}
			echo "warning: could not remove old backup!" >> ${backuplog}
			echo "fatal: could not backup world!" >> ${backuplog}
			echo "" >> ${backuplog}
		fi

	else
		# write date and execute into logfiles
		echo "${date} executing backup-weekly script" >> ${screenlog}
		echo "${date} executing backup-weekly script" >> ${backuplog}

		# write to logfiles that it's disabled
		echo "backup-weekly is disabled" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
fi


# performs backup monthly if it is 22:?? and the first day of a month

# check if it is 22:?? and the first day of month
hours=$(date +"%H")
dayofmonth=$(date +"%d")
if [ ${hours} -eq 22 ] && [ ${dayofmonth} -eq 1 ]; then
	
	# check if monthly backups are enabled
	if [ ${domonthly} = true ]; then

		# write date and execute into logfiles
		echo "${date} executing backup-monthly script" >> ${screenlog}
		echo "${date} executing backup-monthly script" >> ${backuplog}
		
		# checks for the existence of a screen terminal
		if ! screen -list | grep -q "\.${servername}"; then
			echo -e "${yellow}server is not currently running!${nocolor}"
			echo "server is not currently running!" >> ${screenlog}
			echo "server is not currently running!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi
		
		# check if world is bigger than diskspace
		if (( (${absoluteworldsize} + ${diskspacepadding}) > ${absolutediskspace} )); then
			echo -e "${red}fatal: not enough disk-space to perform backup-monthly${nocolor}"
			echo "fatal: not enough disk-space to perform backup-monthly" >> ${backuplog}
			echo "" >> ${backuplog}
			# ingame logfile error output
			PrintToScreenNotEnoughtDiskSpace "${newmonthly}" "${oldmonthly}"
			exit 1
		fi
		
		# check if there is no backup from the current month
		if ! [ -d "${backupdirectory}/monthly/${servername}-${newmonthly}" ]; then
			cp -r ${serverdirectory}/world ${backupdirectory}/monthly/${servername}-${newmonthly}
		else
			echo "warning: backup already exists!" >> ${backuplog}
			echo "" >> ${backuplog}
			exit 1
		fi
		
		# read server.settings file again with error checking
		if [[ -f "server.settings" ]]; then
			. ./server.settings
		else
			echo "fatal: server.settings is missing" >> fatalerror.log
			echo "fatal: server.settings is missing"
			exit 1
		fi
		
		# check if there is a new backup
		if [ -d "${backupdirectory}/monthly/${servername}-${newmonthly}" ]; then
			# check if an old backup exists an remove it
			if [ -d "${backupdirectory}/monthly/${servername}-${oldmonthly}" ]; then
				rm -r ${backupdirectory}/monthly/${servername}-${oldmonthly}
			fi
			# ingame and logfile success output
			PrintToScreenBackupSuccess "${newmonthly}" "${oldmonthly}"
			echo "newest backup has been successfully created!" >> ${backuplog}
			echo "added ${backupdirectory}/monthly/${servername}-${newmonthly}" >> ${backuplog}
			echo "oldest backup has been successfully removed!" >> ${backuplog}
			echo "removed ${backupdirectory}/monthly/${servername}-${oldmonthly}" >> ${backuplog}
			echo "current world size: ${worldsize}, current backup size: ${backupsize}, current disk space: ${diskspace}" >> ${backuplog}
			echo "" >> ${backuplog}
		else
			# ingame and logfile error output
			PrintToScreenBackupError "${newmonthly}" "${oldmonthly}"
			echo "warning: cannot remove old backup because new backup is missing" >> ${backuplog}
			echo "warning: could not remove old backup!" >> ${backuplog}
			echo "fatal: could not backup world!" >> ${backuplog}
			echo "" >> ${backuplog}
		fi

	else
		# write date and execute into logfiles
		echo "${date} executing backup-weekly script" >> ${screenlog}
		echo "${date} executing backup-weekly script" >> ${backuplog}

		# write to logfiles that it's disabled
		echo "backup-weekly is disabled" >> ${backuplog}
		echo "" >> ${backuplog}
	fi
fi
