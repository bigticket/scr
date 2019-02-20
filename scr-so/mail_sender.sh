#!/bin/bash

dest="/home/jmacek/scr18-19/lab2/spec/*"
attachment=""
subject="offer"

for file in ${dest}
do
        [ -f "$file" ] && attachment="$attachment -a $file"
done

echo -e "Sending e-mails has been started...\n"

while read address
do
        mailx -s ${subject} ${attachment} ${address} < body.txt
        echo "Message has been successfully sent to ${address}..."
done < adresses.txt
