#!/bin/bash
# mincraft server prerender script

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

# check if server is running
if ! screen -list | grep -q "\.${servername}"; then
	echo "${yellow}Server is not currently running!${nocolor}"
	exit 1
fi

# let user chose between online and offline prerendering
echo "Would you like to startup online or offline prerendering?"
PS3="Your choice: "
method=("online" "offline")
select method in "${method[@]}"; do
	case $method in
		"online")
			echo "${magenta}starting online prerenderer...${nocolor}"

			# explain to user
			echo "${blue}I will prerender your minecraft world by teleporting a selected player through it${nocolor}"
			echo "${blue}I will scan so to speak in a grid with the spacing of 256 blocks${nocolor}"

			# ask for playername
			read -p "Please enter a playername: " playername
			echo "The player will be ${green}${playername}${nocolor}"

			# ask for cords
			PS3="Which radius would you like to prerender? "
			grid=("1024*1024" "2048*2048" "4096*4096" "8192*8192")
			select grid in "${grid[@]}"; do
				case $grid in
					"1024*1024")
						cords=( 1024 768 512 256 0 -256 -512 -768 -1024 )
						area="1024 times 1024"
						totalblocks=$((2048 * 2048))
						amount="9"
						break
					;;
					"2048*2048")
						cords=( 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 )
						area="2048 times 2048"
						totalblocks=$((4096 * 4096))
						amount="17"
						break
					;;
					"4096*4096")
						cords=( 4096 3840 3584 3328 3072 2816 2560 2304 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -2304 -2560 -2816 -3072 -3328 -3584 -3840 -4096 )
						area="4096 times 4096"
						totalblocks=$((8192 * 8192))
						amount="33"
						break
					;;
					"8192*8192")
						cords=( 8192 7936 7680 7414 7168 6912 6656 6400 6144 5888 5632 5376 5120 4864 4608 4352 4096 3840 3584 3328 3072 2816 2560 2304 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -2304 -2560 -2816 -3072 -3328 -3584 -3840 -4096 -4352 -4608 -4864 -5120 -5376 -5632 -5888 -6144 -6400 -6656 -6912 -7168 -7414 -7680 -7936 -8192 )
						area="8192 times 8192"
						totalblocks=$((16384 * 16384))
						amount="65"
						break
					;;
					*) echo "Please choose an option from the list: " ;;
				esac
			done

			# ask for interval in seconds
			echo "I would like to know how fast you want to scan your world"
			echo "I would recommend an interval of 20 to 80 seconds depending on your server recources"
			echo "Please enter an interval in seconds. Example: ${yellow}60${nocolor}"
			read -p "interval: " interval
			regex="^([8-9]|[1-9][0-9]|1[0-2][0-8])$"
			while [[ ! ${interval} =~ ${regex} ]]; do
				read -p "Please enter an interval between 8 and 128 seconds: " interval
			done

			# calculate some internal intervals
			between=$((${interval} / 4))
			between="sleep ${between}s"
			estimated=$((${interval} * ${amount} * ${amount}))
			interval="sleep ${interval}s"
			echo "The selected grid will be ${green}${area}${nocolor}"
			echo "The selected interval will be ${green}${interval}${nocolor}"
			echo "The selected between will be ${green}${between}${nocolor}"

			# ask for permission to proceed
			echo "I will now start to teleport the selected player through the world"
			echo "It will take about ${estimated} seconds to finish prerendering"
			read -p "Continue? [Y/N]: "
			regex="^(Y|y|N|n)$"
			while [[ ! ${REPLY} =~ ${regex} ]]; do
				read -p "Please press Y or N: " REPLY
			done
			if [[ ${REPLY} =~ ^[Yy]$ ]]
				then echo "${green}starting prerenderer...${nocolor}"
				else echo "${red}exiting...${nocolor}"
					exit 1
			fi

			# prerender start
			echo "Prerendering started"
			echo "Progress: [0/$((${amount} * ${amount}))]"
			sleep 2s

			# teleport script with progress
			progress="1"
			counter="1"
			y="120"
			for x in "${cords[@]}"; do
				for z in "${cords[@]}"; do
					let "progress=counter"
					# progress counter
					echo "${blue}[Script]${nocolor} Progress: [${progress}/$((${amount} * ${amount}))]"
					# teleporting with facing directions
					PrintToScreen "tp ${playername} ${x} ${y} ${z} 0 0"
					${between}
					PrintToScreen "tp ${playername} ${x} ${y} ${z} 90 0"
					${between}
					PrintToScreen "tp ${playername} ${x} ${y} ${z} 180 0"
					${between}
					PrintToScreen "tp ${playername} ${x} ${y} ${z} 270 0"
					${between}
					counter=$((counter+1))
				done
			done

			# command line finished message
			PrintToScreen "say Prerendering of your world has finished"
			echo "${blue}[Script]${nocolor} ${green}Prerendering of your world has finished${nocolor}"

			echo "${blue}[Script]${nocolor} ${green}Rendered ${totalblocks} [${area}] blocks of area${nocolor}"

			# kick player with finished message
			screen -Rd ${servername} -X stuff "kick ${playername} prerendering of your world has finished$(printf '\r')"

		;;
		"offline")
			echo "${magenta}starting offline prerenderer...${nocolor}"

			# explain to user
			echo "${blue}I will prerender your minecraft world by setting the worldspawn to various cordinates and then restarting the server over and over${nocolor}"
			echo "${blue}I will scan so to speak in a grid with the spacing of 256 blocks${nocolor}"

			# ask for cords
			PS3="Which radius would you like to prerender? "
			grid=("1024*1024" "2048*2048" "4096*4096" "8192*8192")
			select grid in "${grid[@]}"; do
				case $grid in
					"1024*1024")
						cords=( 1024 768 512 256 0 -256 -512 -768 -1024 )
						area="1024 times 1024"
						totalblocks=$((2048 * 2048))
						amount="9"
						break
					;;
					"2048*2048")
						cords=( 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 )
						area="2048 times 2048"
						totalblocks=$((4096 * 4096))
						amount="17"
						break
					;;
					"4096*4096")
						cords=( 4096 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -4096 )
						area="4096 times 4096"
						totalblocks=$((8192 * 8192))
						amount="33"
						break
					;;
					"8192*8192")
						cords=( 8192 6144 4096 2048 1792 1536 1280 1024 768 512 256 0 -256 -512 -768 -1024 -1280 -1536 -1792 -2048 -4096 -6144 -8192 )
						area="8192 times 8192"
						totalblocks=$((16384 * 16384))
						amount="65"
						break
					;;
					*) echo "Please choose an option from the list: " ;;
				esac
			done

			# ask for interval in seconds
			echo "I would like to know how fast you want to scan your world"
			echo "I would recommend an interval of 20 to 80 seconds depending on your server recources"
			echo "Please enter an interval in seconds. Example: ${yellow}60${nocolor}"
			read -p "interval: " interval
			regex="^([8-9]|[1-9][0-9]|1[0-2][0-8])$"
			while [[ ! ${interval} =~ ${regex} ]]; do
				read -p "Please enter an interval between 8 and 128 seconds: " interval
			done
			interval="sleep ${interval}s"

			# ask for permission to proceed
			echo "I will now start to prerender your world using worldspawns and server restart"
			read -p "Continue? [Y/N]: "
			regex="^(Y|y|N|n)$"
			while [[ ! ${REPLY} =~ ${regex} ]]; do
				read -p "Please press Y or N: " REPLY
			done
			if [[ ${REPLY} =~ ^[Yy]$ ]]
				then echo "${green}starting prerenderer...${nocolor}"
				else echo "${red}exiting...${nocolor}"
					exit 1
			fi

			# prerender start
			echo "Prerendering started"
			echo "Progress: [0/$((${amount} * ${amount}))]"
			sleep 2s

			# teleport script with progress
			progress="1"
			counting="1"
			y="120"
			for x in "${cords[@]}"; do
				for z in "${cords[@]}"; do
					let "progress=counting"
					# progress counter
					echo "${blue}[Script]${nocolor} Progress: [${progress}/$((${amount} * ${amount}))]"
					# setworldspawn to x y z
					PrintToScreen "setworldspawn ${x} ${y} ${z}"
					# server stop
					screen -Rd ${servername} -X stuff "say stopping server...$(printf '\r')"
					screen -Rd ${servername} -X stuff "stop$(printf '\r')"
					# check if server stopped
					stopchecks="0"
					while [ $stopchecks -lt 10 ]; do
						if ! screen -list | grep -q "\.${servername}"; then
							break
						fi
						stopchecks=$((stopchecks+1))
						sleep 1s
					done
					# force quit server if not stopped
					if screen -list | grep -q "${servername}"; then
						screen -S ${servername} -X quit
					fi
					${interval}
					# main start commmand
					${screen} -dmSL ${servername} -Logfile ${screenlog} ${java} -server ${mems} ${memx} ${threadcount} -jar ${serverfile}
					${screen} -r ${servername} -X colon "logfile flush 1^M"
					# check if screenlog contains start comfirmation
					count="0"
					counter="0"
					startupchecks="0"
					while [ ${startupchecks} -lt 120 ]; do
						if tail ${screenlog} | grep -q "Query running on"; then
							break
						fi
						if ! screen -list | grep -q "${servername}"; then
							echo "Fatal: something went wrong - server appears to have crashed!" >> ${screenlog}
							echo "${red}Fatal: something went wrong - server appears to have crashed!${nocolor}"
							exit 1
						fi
						if tail ${screenlog} | grep -q "Preparing spawn area"; then
							counter=$((counter+1))
						fi
						if tail ${screenlog} | grep -q "Environment"; then
							count=$((count+1))
						fi
						if tail ${screenlog} | grep -q "Reloading ResourceManager"; then
							count=$((count+1))
						fi
						if tail ${screenlog} | grep -q "Starting minecraft server"; then
							count=$((count+1))
						fi
						if [ ${counter} -ge 10 ]; then
							counter="0"
						fi
						if [ ${count} -eq 0 ] && [ ${startupchecks} -eq 20 ]; then
							echo "Warning: the server could be crashed" >> ${screenlog}
							echo "${yellow}Warning: the server could be crashed${nocolor}"
							exit 1
						fi
						startupchecks=$((startupchecks+1))
						sleep 1s
					done
					counting=$((counting+1))
					${interval}
				done
			done

			# reset spawnpoint
			PrintToScreen "setworldspawn 0 100 0"

			# command line info
			echo "${green}Prerendering of your world has finished${nocolor}"

		;;
			*) echo "Please choose an option from the list: " ;;
	esac
done
