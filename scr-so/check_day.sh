#!/bin/bash

export LC_ALL=C

var=`date`
echo -e "\nCurrent date is: ${var}\n\nLet's check what does it mean...\n"

if [[ ${var} =~ ^[Mon|Tue|Wed|Thu|Fri] ]]; then
        echo "Today is working day..."
elif [[ ${var} =~ ^[Sat|Sun] ]]; then
        echo "Today is day off!"
else
        echo "Bad data format!"
fi