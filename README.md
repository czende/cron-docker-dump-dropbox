# CRON - DOCKER - DUMP - DROPBOX

## Why?
Just because I needed it.

## Prerequisites:
- ubuntu or debian
- curl
- cron installed
- docker installed
- MySQL docker container ID (you can check it by 'docker ps')
- your dropbox oAuth token

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
