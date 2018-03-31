#!/usr/bin/env bash

# 1) find the files modified in last 5 minutes in directory
#    given as first call argument
# 2) search the string given as second call argument in found files
# 3) print the line with the wanted string from the processed file


find $1/. -mmin -5 | grep -i -R -n -H $2 
