#!/bin/bash

MASK="$1"
DAYS="$2"
ARCHIVE_NAME="$3.tar.gz"

find . -mtime -"$DAYS" -name "$MASK" | xargs tar -zcvf "$ARCHIVE_NAME"