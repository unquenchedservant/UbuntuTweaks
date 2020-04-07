#!/bin/bash

# function to get the id of the sound card
get_id() {
    x = 1
    while read line; do
        # the if block is needed to make sure you only get the first line
        if [[ "$x" -eq '1' ]]; then
            # cut -c1-2 takes the first character of the first line which
            # is the ID of the soundcard
            id=$(echo $line | cut -c1-2)
        fi
        x=$x+1
    done
}

# check to see if amixer is setup
command -v amixer >/dev/null 2>&1 || { echo >&2 "amixer not installed"; exit 1}

# so i realized that if you can get the card ID using cat /proc/asound/cards
# then I could probably utilize that to automate it each time. 
# Generic is the name of my sound card, may vary depending

get_id < <(cat /proc/asound/cards | grep Generic)

# this should make it so that the start of the commands use the right -cN

START="amixer -c$id "

# if auto-mute is enabled, when switching from headphones to speakers
# it keeps the speakers muted no matter what.

AMUTE="sset 'Auto-Mute Mode' Disabled > /dev/null"

eval ${START} ${AMUTE}

# Toggle file to see if speakers or headphones are enabled
TOGGLE=$HOME/.toggle

HEAD="set Headphone "
FRNT="set Front "
END="% > /dev/null"
MUTE="0"
ON="100"
# if the toggle file doesn't exist
if [ ! -e $TOGGLE ]; then
    touch $TOGGLE # create the toggle file
    eval ${START} ${HEAD} ${MUTE} ${END}
    eval ${START} ${FRNT} ${ON} ${END}
else
    rm $TOGGLE # remove the toggle file
    eval ${START} ${HEAD} ${ON} ${END}
    eval ${START} ${FRNT} ${MUTE} ${END}
fi
#
# TO DO LIST 
#
# TODO: save the audio levels when switching, so when switching back
#       it isn't super loud
#
# TODO: Add an appindicator icon for easier switching.
# How to use:
# save to /usr/local/bin/speakers.sh
#
# create keyboard shortcut to keybinding of your choice to and
# set command as speakers.sh

