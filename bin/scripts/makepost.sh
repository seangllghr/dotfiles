#!/bin/bash

if [ $# -eq 0 ]; then
    echo 'Error: Supply a markdown source.'
elif [ $# -eq 1 ]; then
    if [ $(echo $1 | cut -d'.' -f 2) == 'md' ]; then
        pandoc --to=html --wrap=preserve $1 | xsel -ip
        echo 'Post copied to PRIMARY'
    else
        echo 'Error: expected Markdown source.'
    fi
elif [ $# -eq 2 ]; then
    if [ $(echo ${@: -1} | cut -d'.' -f 2) == 'md' ]; then
       case $1 in
           '-w') : ;&
           '--watch')
               inotifywait -e close_write,moved_to,create -m $2 |
                   while read -r directory events filename; do
                       pandoc --to=html --wrap=preserve $2 | xsel -ip
                       echo 'Post copied to Primary'
                   done
               ;;
       esac
    else
        echo 'Error: expected Markdown source.'
    fi
else
    echo 'Error: too many arguments.'
fi
