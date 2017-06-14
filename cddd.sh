#!/bin/bash

## Variables
bold=$(tput bold)
normal=$(tput sgr0)
red='\033[0;31m'
blue='\033[0;34m'
orange='\033[0;33m'
white='\033[0;37m'
yellow='\033[1;33m'
nc='\033[0m' # No Color
datemark='`date +\%d.\%m.\%Y--\%H.\%M.\%S`'

## Logo & description
printf "${orange}
    _   _   _ _____ ___  ____  _______     _______ _     ___  
   / \ | | | |_   _/ _ \|  _ \| ____\ \   / / ____| |   / _ \ 
  / _ \| | | | | || | | | | | |  _|  \ \ / /|  _| | |  | | | |
 / ___ \ |_| | | || |_| | |_| | |___  \ V / | |___| |__| |_| |
/_/   \_\___/  |_| \___/|____/|_____|  \_/  |_____|_____\___/ 
                                                              ${nc}"
                                    
printf "\n\n${orange}
#############################################################
# This script will help you to properly set up cron job for #
# dumping databases from running MySQL Docker container and #
# send them to the dropbox folder. Plese read prerequisites #
#############################################################
\n\n${nc}"


## Check if cron is installed
printf "${orange}###### Checking if cron is installed ######\n\n${nc}"
sleep 1
if [ -z `which cron` ]; then
    printf "${red}ERROR: You don't have installed cron :-( !${nc}\n"
    printf "${red}Please install cron as 'apt-get install cron' and run this script again.${nc}\n\n" 
    exit
else
	printf "${bold}SUCCESS:${normal} You have cron installed :-) !\n\n\n\n"
fi

## Check if docker is installed
printf "${orange}###### Checking if docker is installed #######\n\n${nc}"
sleep 1
if [ -z `which docker` ]; then
    printf "${red}ERROR: You don't have docker installed :-( !${nc}\n"
    printf "${red}Please install docker as 'apt-get install docker' or whatever and run this script again.${nc}\n\n"  
    exit
else
	printf "${bold}SUCCESS:${normal} You have docker installed :-) !\n\n\n\n"
fi

## Get docker id for mysql container
printf "${orange}###### Getting docker id for running MySQL container #######\n\n${nc}"
printf "Please enter ID of desired MySQL docker container: " 
read -r docker_id
if [ ! "$docker_id" ]; then
	printf "${red}ERROR: Please enter at least 3 chars of your container ID!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} ID of the MySQL container = ${red}$docker_id${nc}"	
fi
printf "\n\n\n\n"

## Get mysql database name
printf "${orange}###### Getting MySQL database name #######\n\n${nc}"
printf "Please enter MySQL database name: " 
read -r database
if [ ! "$database" ]; then
	printf "${red}ERROR: Please enter your MySQL database name!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} your MySQL database name = ${red}$database${nc}"	
fi
printf "\n\n\n\n"

## Get mysql user
printf "${orange}###### Getting MySQL user #######\n\n${nc}"
printf "Please enter MySQL user: " 
read -r user
if [ ! "$user" ]; then
	printf "${red}ERROR: Please enter your MySQL user!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} your MySQL user = ${red}$user${nc}"	
fi
printf "\n\n\n\n"

## Get MySQL password
printf "${orange}###### Getting MySQL password for user $user #######\n\n${nc}"
printf "Please enter MySQL password for user $user: " 
read -r pass
if [ ! "$pass" ]; then
	printf "${red}ERROR: Please enter your MySQL password for user $user!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} your MySQL password = ${red}$pass${nc}"	
fi
printf "\n\n\n\n"

## Get MySQL dump path
printf "${orange}###### Getting MySQL dump path #######\n\n${nc}"
printf "Please enter desired path for storing dump (e.g. /mnt/dumps/): " 
read -r dump_path
if [ ! "$dump_path" ]; then
	printf "${red}ERROR: Please enter your path for storing dumps!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} your path for storing dumps = ${red}$dump_path${nc}"	
fi
printf "\n\n\n\n"

## Get dropbox token
printf "${orange}###### Getting dropbox oAuth token #######\n\n${nc}"
printf "Please enter dropbox oAuth token: " 
read -r token
if [ ! "$token" ]; then
	printf "${red}ERROR: Please enter your dropbox oAuth token!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} your dropbox oAuth token = ${red}$token${nc}"	
fi
printf "\n\n\n\n"

## Get dropbox path
printf "${orange}###### Getting Dropbox path #######\n\n${nc}"
printf "Please enter desired Dropbox path for sending dumps (e.g. /mydumps/): " 
read -r drop_path
if [ ! "$drop_path" ]; then
	printf "${red}ERROR: Please enter your Dropbox path for sending dumps!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} your Dropbox path for sending dumps = ${red}$drop_path${nc}"	
fi
printf "\n\n\n\n"

## Get scheduling for dumping
printf "${orange}###### Getting time scheduling for dumping #######\n\n${nc}"
printf "Please enter desired cron time schedule for dumping database (e.g. 0 */4 * * *): " 
read -r dump_cron
if [ ! "$dump_cron" ]; then
	printf "${red}ERROR: Please enter desired cron time schedule for dumping database!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} cron time schedule for dumping database = ${red}$dump_cron${nc}"	
fi
printf "\n\n\n\n"

## Get scheduling for sending
printf "${orange}###### Getting time scheduling for sending #######\n\n${nc}"
printf "Please enter desired cron time schedule for sending dumps to the Dropbox (e.g. 0 */5 * * *): " 
read -r dump_send
if [ ! "$dump_send" ]; then
	printf "${red}ERROR: Please enter desired cron time schedule for sending dumps to the Dropbox!${nc}\n"
	exit
else 
	printf "\n"
	printf "${bold}SUCCESS:${normal} cron time schedule for dumping database = ${red}$dump_send${nc}"	
fi
printf "\n\n\n\n"

## Get answer to remove dumps
printf "${orange}###### Getting settings for removing dumps #######\n\n${nc}"
printf "Do you want to trigger removing dumps from host after sending? (y/n): " 
read -r dump_remove
if [ "$dump_remove" == "n" ]; then
	printf "\n"
	printf "OK, removing dumps from host will not be performed"
	printf "\n\n\n\n"
fi
if [ "$dump_remove" == "y" ]; then 
	## Get scheduling for removing
	printf "\n\n\n\n"
	printf "${orange}###### Getting time scheduling for removing #######\n\n${nc}"
	printf "Please enter desired cron time schedule for removing dumps from host (e.g. 30 */5 * * *): " 
	read -r dump_remove_cron
	if [ ! "$dump_remove_cron" ]; then
		printf "${red}ERROR: Please enter desired cron time schedule for removing dumps!${nc}\n"
		exit
	else 
		printf "\n"
		printf "${bold}SUCCESS:${normal} cron time schedule for removing dumps = ${red}$dump_remove_cron${nc}"	
		printf "\n\n\n\n"
	fi
fi

## Download dropbox uploader
printf "${orange}###### Downloading dropbox uploader #######\n\n${nc}"
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
printf "\n\n"
printf "${bold}SUCCESS:${normal} dropbox uploader downloaded!"
printf "\n\n\n\n"

## Configure dropbox uploader
printf "${orange}###### Configuring dropbox uploader #######\n\n${nc}"
chmod +x dropbox_uploader.sh
touch .dropbox_uploader
echo "OAUTH_ACCESS_TOKEN=${token}" >> .dropbox_uploader
printf "${bold}SUCCESS:${normal} dropbox uploader configured!"
printf "\n\n\n\n"

## Configure crontab
printf "${orange}###### Configuring crontab #######\n\n${nc}"
rm -rf crontab
touch crontab
echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> crontab
echo "SHELL=/bin/bash" >> crontab
echo " " >> crontab
echo "${dump_cron} docker exec ${docker_id} mysqldump -u ${user} -p'${pass}' --databases ${database} | gzip > ${dump_path}${database}_${datemark}.sql.gz" >> crontab
echo "${dump_send} /root/dropbox_uploader.sh -s upload ${dump_path}*.gz ${drop_path}" >> crontab
if [ "$dump_remove" == "y" ]; then
	echo "${dump_remove_cron} rm -rf ${dump_path}*.gz" >> crontab
fi
crontab crontab
service cron start
printf "${bold}SUCCESS:${normal} crontab configured!"
printf "\n\n\n"


printf "${white}
***************************************************
*     _    _     _       ____   ___  _   _ _____  *
*    / \  | |   | |     |  _ \ / _ \| \ | | ____| *
*   / _ \ | |   | |     | | | | | | |  \| |  _|   *
*  / ___ \| |___| |___  | |_| | |_| | |\  | |___  *
* /_/   \_\_____|_____| |____/ \___/|_| \_|_____| *
*                                                 *
***************************************************
${nc}"

printf "\n\n"
