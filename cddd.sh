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


## Check if Docker is installed
printf "${orange}###### Checking if cron is installed ######\n\n${nc}"
sleep 1
if [ -z `which cron` ]; then
    printf "${red}ERROR: You don't have installed cron :-( !${nc}\n"
    printf "${red}Please install cron as 'apt-get install cron' and run this script again.${nc}\n\n" 
    exit
else
	printf "${bold}SUCCESS:${normal} You have cron installed :-) !\n\n\n\n"
fi

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
datemark='`date +\%Y-\%m-\%d:\%H:\%M:\%S`'
echo "0 */4 * * * docker exec -it ${docker_id} mysqldump -u ${user} -p'${pass}' --databases ${database} | gzip > /mnt/autodevelo-${database}/db/dumps/${database}_${datemark}.sql.gz" >> crontab
echo "0 */5 * * * /root/dropbox_uploader.sh -s upload /mnt/autodevelo-${database}/db/dumps/*.gz /autodevelo-${database}/db-dumps" >> crontab
echo "30 */5 * * * rm -rf /mnt/autodevelo-${database}/db/dumps/*.gz" >> crontab
crontab crontab
service cron start
printf "${bold}SUCCESS:${normal} crontab configured!"
printf "\n\n\n\n"


printf "${white}
    _    _     _       ____   ___  _   _ _____ 
   / \  | |   | |     |  _ \ / _ \| \ | | ____|
  / _ \ | |   | |     | | | | | | |  \| |  _|  
 / ___ \| |___| |___  | |_| | |_| | |\  | |___ 
/_/   \_\_____|_____| |____/ \___/|_| \_|_____|${nc}"

printf "\n\n"
