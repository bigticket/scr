#!/usr/bin/env bash

# this script sorts the data from every file given as call argument

for i in $@ ; do
    echo "$i :"
    sort -n $i
    echo -e "\n"
done
