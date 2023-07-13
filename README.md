# mongodump scripts

## To make this dump repititive in ubuntu/linux

1. open terminal
2. type `crontab -e`
3. if this is your first time writing cronjob in the machine, choose a text editor
4. at the end of the line add `* * * * * /bin/sh $path/scripts/mongodb-backup.sh`

N.B: replace $path with the absolute path to the scripts folder
`* * * * *` - means the script will run every minute to replace with your own cron schedule visit https://crontab-generator.org/ will help you generate a cron schedule
