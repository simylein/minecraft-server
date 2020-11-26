#!/bin/bash
# minecraft server restore script

# read the settings
. ./server.settings

# change to server directory
cd ${serverdirectory}

# write date to logfile
echo "${date} executing restore script" >> ${screenlog}

# check if server is running
if ! screen -list | grep -q "${servername}"; then
	echo "server is not currently running!" >> ${screenlog}
	echo -e "${yellow}server is not currently running!${nocolor}"
	exit 1
fi

# countdown
counter="60"
while [ ${counter} -gt 0 ]; do
	if [[ "${counter}" =~ ^(60|40|20|10|5|4|3|2|1)$ ]];then
		echo "server is restoring a backup in ${counter} seconds!"
		screen -Rd ${servername} -X stuff "say server is restoring a backup in ${counter} seconds!$(printf '\r')"
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
	sleep 1;
done

# force quit server if not stopped
if screen -list | grep -q "${servername}"; then
	echo -e "${yellow}Minecraft server still hasn't closed after 30 seconds, closing screen manually${nocolor}"
	screen -S ${servername} -X quit
fi

# create arrays with backupdirectorys
cd ${backupdirectory}
backups=($(ls))
cd hourly
backupshourly=($(ls))
cd ../
cd daily
backupsdaily=($(ls))
cd ../

# ask user which backup shall be restored
PS3="Would you like to restore a daily or hourly backup? "
select opt in "${backups[@]}"
do
	case $opt in
		"${backups[0]}")
			echo "you chose ${backups[0]}"
			
			# if user chose daily ask for which daily backup
			PS3="Which ${backups[0]} backup would you like to restore? "
			select opt in "${backupsdaily[@]}"
			do
				case $opt in
					"${backupsdaily[0]}")
						echo "you chose ${backupsdaily[0]}"
						break
					;;
					"${backupsdaily[1]}")
						echo "you chose ${backupsdaily[1]}"
						break
					;;
					"${backupsdaily[2]}")
						echo "you chose ${backupsdaily[2]}"
						break
					;;
					"${backupsdaily[3]}")
						echo "you chose ${backupsdaily[3]}"
						break
					;;
					*) 
						echo "invalid answer - please chose from the list"
					;;
				esac
			done
					
			break
		;;
		"${backups[1]}")
			echo "you chose ${backups[1]}"
				
			# if user chose hourly ask for which daily backup
			PS3="Which ${backups[1]} backup would you like to restore? "
			select opt in "${backupshourly[@]}"
			do
				case $opt in
					"${backupshourly[0]}")
						echo "you chose ${backupshourly[0]}"
						break
					;;
					"${backupshourly[1]}")
						echo "you chose ${backupshourly[1]}"
						break
					;;
					"${backupshourly[2]}")
						echo "you chose ${backupshourly[2]}"
						break
					;;
					"${backupshourly[3]}")
						echo "you chose ${backupshourly[3]}"
						break
					;;
					*) 
						echo "invalid answer - please chose from the list"
					;;
				esac
			done
			
			break
		;;
		*) 
			echo "invalid answer - please chose from the list"
		;;
	esac
done
