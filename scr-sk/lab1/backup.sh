#!/usr/bin/env bash

# this script makes a gzip archive backup for given folder in special format
# "backup_<folder_name>_<year-month-day_hour-minute-sec>.tar.gz" 

# $1 - folder name
# $2 - path to the folder

DATE=`date +%Y-%m-%d_%H-%M-%S`
FILENAME="backup_$1_$DATE.tar.gz"

tar -P -cpzf $FILENAME $2
