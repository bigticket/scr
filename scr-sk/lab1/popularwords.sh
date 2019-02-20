#!/usr/bin/env bash

# this script prints 3 most popular words for every file given as call argument

for i in $@ ; do
    echo "$i :"
    cat $i | tr -s ' ' '\n' | sort | uniq -c | sort -r | head -n 3
    echo -e "\n"
done
