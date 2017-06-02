# CRON - DOCKER - DUMP - DROPBOX

## Why?
Just because I needed it.

## Prerequisites:
- ubuntu or debian
- curl installed
- cron installed
- docker installed
- running MySQL docker image with some database
- gzip installed
- MySQL docker container ID (you can retrieve it by 'docker ps')
- your dropbox oAuth token

## Description
This simple script will just set up cron to perform:
- mysqldump from running database
- store dump on your host
- send it to the dropbox folder
- remove dumps from your host


You will be prompted to enter:
- MySQL container ID
- MySQL database name
- MySQL user
- MySQL password
- dropbox oauth token 
- path for storing dumps on host
- path for sending dumps to the Dropbox
- cron scheduling for dumping
- cron scheduling for sending
- cron scheduling for removing (optional)

## Getting started

Download the script using this command:
```bash
curl "https://raw.githubusercontent.com/Czende/cron-docker-dump-dropbox/master/cddd.sh" -o cddd.sh
```
Then give the execution permission to the script and run it:
```bash
chmod +x cddd.sh
./cddd.sh
```


### Thanks to this excelent [https://github.com/andreafabrizi/Dropbox-Uploader](Dropbox Uploader)


