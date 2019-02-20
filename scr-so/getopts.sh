#!/bin/bash

set -e

while getopts 'n:m:a:h' OPTION; do
        case "$OPTION" in
                n)
                        DAYS="$OPTARG"
                        ;;
                m)
                        MASK="$OPTARG"
                        ;;
                a)
                        ARCHIVE_NAME="${OPTARG}.tar.gz"
                        ;;
                h)
                        man getopt
                        exit 1
                        ;;
                *)
                        echo "usage: $0 [-n <days>] [-m <mask>] [-a <archive_name>] [-h]"
                        exit 1
                        ;;
        esac
done

if ([ -z "$MASK" ] && [ -n "$SCR_MASK" ]); then
        MASK="$SCR_MASK"
elif ([ -z "$MASK" ] && [ -z "$SCR_MASK" ]); then
        read -r -p "Please provide mask: " mask
        MASK="$mask"
fi

if ([ -z "$DAYS" ] && [ -n "$SCR_DAYS" ]); then
        DAYS="$SCR_DAYS"
elif ([ -z "$DAYS" ] && [ -z "$SCR_DAYS" ]); then
        read -r -p "Please provide number of days: " days
        DAYS="$days"
fi

if ([ -z "$ARCHIVE_NAME" ] && [ -n "$SCR_ARCHIVE_NAME" ]); then
        ARCHIVE_NAME="${SCR_ARCHIVE_NAME}.tar.gz"
elif ([ -z "$ARCHIVE_NAME" ] && [ -z "$SCR_ARCHIVE_NAME" ]); then
        read -r -p "Please provide archive name: " archive_name
        ARCHIVE_NAME="${archive_name}.tar.gz"
fi

if ! ([ -z "$MASK" ] || [ -z "$DAYS" ] || [ -z "$ARCHIVE_NAME" ]); then
        echo "Files are being archived..."
        find . -name "$MASK" -mtime -"$DAYS" | xargs tar -zcvf $ARCHIVE_NAME
else
        echo "usage: $0 [- <days>] [-m <mask>] [-a <archive_name>] [-h]"
fi  