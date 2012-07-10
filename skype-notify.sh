#!/bin/bash

# Initialization

# Names of "precious" users
MATCH_USERS=()
# Messages to match (phony text)
MATCH_MESSAGE=()

NOTICE_TITLE=$1
SKYPE_USER=$2
NOTICE_MSG=$3

DO_NOTIFY=0

NOTIFY_ICON="skype"
NOTIFY_SCRIPT="notify-send"

# Configuration
# Add your desired names/message options here

MATCH_USERS=("${MATCH_USERS[@]}" "[Aa]ust[ėe]")

MATCH_MESSAGE=("${MATCH_MESSAGE[@]}" "@[Jj]ustas")
MATCH_MESSAGE=("${MATCH_MESSAGE[@]}" "@"$USER)

# Actual checking

for userMatchIdx in $(seq 0 $((${#MATCH_USERS[@]} - 1)))
do
    if [[ $SKYPE_USER =~ ${MATCH_USERS[$userMatchIdx]} ]]
    then
        echo "User name "$SKYPE_USER" matches '"${MATCH_USERS[$userMatchIdx]}"'."
        DO_NOTIFY=1
        break
    fi
done

if [[ $DO_NOTIFY == 0 ]]
then
    for messageMatchIdx in $(seq 0 $((${#MATCH_MESSAGE[@]} - 1)))
    do
        if [[ $NOTICE_MSG =~ ${MATCH_MESSAGE[$messageMatchIdx]} ]]
        then
            echo "Notification message "$NOTICE_MSG" matches '"${MATCH_MESSAGE[$messageMatchIdx]}"'."
            DO_NOTIFY=1
            break
        fi
    done
fi

if [[ $DO_NOTIFY == 0 ]]
then
    echo "Failed to match notification '"$NOTICE_MSG"' from '"$SKYPE_USER"'."
    exit 1
fi

$NOTIFY_SCRIPT "[$SKYPE_USER] $NOTICE_TITLE" "$NOTICE_MSG" --icon=$NOTIFY_ICON
exit 0
