#!/bin/bash

# check to see if amixer is setup
command -v amixer >/dev/null 2>&1 || { echo >&2 "amixer not installed"; exit 1}

# if auto-mute is enabled, when switching from headphones to speakers
# it keeps the speakers muted and no audio in the headphones 
# NOTE: -c1 = card 1, so it assumes that the sound card needed is on slot 1
#        so you may need to change that. you can use cat /proc/asound/cards
amixer -c1 sset "Auto-Mute Mode" Disabled > /dev/null

# Toggle file to see if speakers or headphones are enabled
TOGGLE=$HOME/.toggle

# if the toggle file doesn't exist
if [ ! -e $TOGGLE ]; then
    touch $TOGGLE # create the toggle file
    # mute headphones, max front (speakers)
    amixer -c1 set Headphone 0% > /dev/null
    amixer -c1 set Front 100% > /dev/null
else
    rm $TOGGLE # remove the toggle file
    # max headphones, mute front (speakers)
    amixer -c1 set Headphone 100% > /dev/null
    amixer -c1 set Front 0% > /dev/null
fi
#
# TO DO LIST 
#
# TODO: the card number changes when rebooted, need to fix that
# TODO: save the audio levels when switching, so when switching back
#       it isn't super loud
#
# How to use:
# save to /usr/local/bin/speakers.sh
#
# create keyboard shortcut to keybinding of your choice to and 
# set command as speakers.sh

