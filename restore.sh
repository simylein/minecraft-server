#!/bin/bash
# minecraft server restore script

# read server files
source server.settings
source server.functions

# safety checks
RootSafety
ScriptSafety

# parse arguments
ParseArgs "$@"

# debug
Debug "executing $0 script"

# change to server directory
ChangeServerDirectory

# check for existance of executable
CheckExecutable

# look if server is running
CheckScreen

# prints countdown to screen
Countdown "restoring a backup"

# server stop
Stop

# awaits server stop
AwaitStop

# force quit server if not stopped
ForceQuit

# output confirmed stop
Log "ok" "server successfully stopped" "${screenLog}"
Print "ok" "server successfully stopped"

# create backup
CachedBackup "restore"

# create arrays with backupdirectorys
Print "info" "scanning backup directory..."
cd ${backupDirectory}
backups=($(ls))
cd hourly
backupsHourly=($(ls))
cd ${backupDirectory}
cd daily
backupsDaily=($(ls))
cd ${backupDirectory}
cd weekly
backupsWeekly=($(ls))
cd ${backupDirectory}
cd monthly
backupsMonthly=($(ls))
cd ${backupDirectory}
cd cached
backupsCached=($(ls))
cd ${backupDirectory}

# ask for daily or hourly backup to restore
PS3="$(date +"%H:%M:%S") prompt: would you like to restore a ${backups[0]}, ${backups[1]}, ${backups[2]}, ${backups[3]}, ${backups[4]} backup? "
select cachedDailyHourlyWeeklyMonthly in "${backups[@]}"; do
	Print "info" "you chose: ${cachedDailyHourlyWeeklyMonthly}"
	break
done

# select specific backup out of daily, hourly, monthly, weekly or a special backup
if [[ "${cachedDailyHourlyWeeklyMonthly}" == "${backups[0]}" ]]; then
	# ask for cached backup
	PS3="$(date +"%H:%M:%S") prompt: which ${backups[4]} backup would you like to restore?"
	select backup in "${backupsCached[@]}"; do
		Print "info" "you chose: ${backup}"
		break
	done
elif [[ "${cachedDailyHourlyWeeklyMonthly}" == "${backups[1]}" ]]; then
	# ask for daily backup
	PS3="$(date +"%H:%M:%S") prompt: which ${backups[0]} backup would you like to restore? "
	select backup in "${backupsDaily[@]}"; do
		Print "info" "you chose: ${backup}"
		break
	done
elif [[ "${cachedDailyHourlyWeeklyMonthly}" == "${backups[2]}" ]]; then
	# ask for hourly backup
	PS3="$(date +"%H:%M:%S") prompt: which ${backups[1]} backup would you like to restore? "
	select backup in "${backupsHourly[@]}"; do
		Print "info" "you chose: ${backup}"
		break
	done
elif [[ "${cachedDailyHourlyWeeklyMonthly}" == "${backups[3]}" ]]; then
	# ask for monthly backup
	PS3="$(date +"%H:%M:%S") prompt: which ${backups[2]} backup would you like to restore? "
	select backup in "${backupsMonthly[@]}"; do
		Print "info" "you chose: ${backup}"
		break
	done
elif [[ "${cachedDailyHourlyWeeklyMonthly}" == "${backups[4]}" ]]; then
	# ask for weekly backup
	PS3="$(date +"%H:%M:%S") prompt: which ${backups[3]} backup would you like to restore? "
	select backup in "${backupsWeekly[@]}"; do
		Print "info" "you chose: ${backup}"
		break
	done
fi

# ask for permission to proceed
Print "info" "i will now delete the current world-directory and replace it with your chosen backup"
Print "info" "you have chosen: ${backupDirectory}/${cachedDailyHourlyWeeklyMonthly}/${backup} as a backup to restore"
read -p "$(date +"%H:%M:%S") prompt: continue? (y/n): "

# if user replys yes perform restore
regex="^(Y|y|N|n)$"
while [[ ! ${REPLY} =~ ${regex} ]]; do
	read -p "$(date +"%H:%M:%S") prompt: please press y or n: " REPLY
done
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
	cd "${serverDirectory}"
	Print "action" "restoring backup..."
	nice -n 19 mv "${serverDirectory}/world" "${serverDirectory}/old-world"
	nice -n 19 cp "${backupDirectory}/${cachedDailyHourlyWeeklyMonthly}/${backup}" "${serverDirectory}"
	nice -n 19 mv "${backup}" "world.tar.gz"
	nice -n 19 tar -xf "world.tar.gz"
	nice -n 19 mv "tmp" "world"
	nice -n 19 rm "world.tar.gz"
	if [ -d "world" ]; then
		Log "the backup ${backupDirectory}/${cachedDailyHourlyWeeklyMonthly}/${backup} has been restored" "${screenLog}"
		Print "ok" "restore successful"
		Print "action" "restarting server with restored backup..."
		nice -n 19 rm -r "${serverDirectory}/old-world"
	else
		Log "error" "something went wrong - could not restore backup" "${screenLog}"
		Log "action" "reverting changes..." "${screenLog}"
		Print "error" "something went wrong - could not restore backup"
		Print "action" "reverting changes..."
		nice -n 19 mv "${serverDirectory}/old-world" "${serverDirectory}/world"
	fi
	./start.sh "$@"
# if user replys no cancel and restart server
else
	cd ${serverDirectory}
	Print "warn" "backup restore has been canceled"
	Print "info" "resuming to current live world"
	Print "action" "restarting server..."
	Log "info" "backup restore has been canceled" "${screenLog}"
	Log "info" "resuming to current live world" "${screenLog}"
	./start.sh "$@"
fi

# log to debug if true
Debug "executed $0 script"

# exit with code 0
exit 0
