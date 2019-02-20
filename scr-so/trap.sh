#!/bin/sh

trap 'echo SIGHUP!' 1
trap 'echo SIGINT!' 2
trap 'echo SIGQUIT' 3
trap 'echo SIGILL' 4
trap 'echo SIGTRAP' 5
trap 'echo SIGABRT' 6
trap 'echo SIGBUS' 7
trap 'echo SIGFPE' 8
trap 'echo SIGKILL' 9
trap 'echo SIGBUS' 10
trap 'echo SIGSEGV' 11
trap 'echo SIGSYS' 12
trap 'echo SIGPIPE' 13
trap 'echo SIGALRM' 14
trap 'echo SIGTERM' 15

while true; do
        date
        sleep 3
done