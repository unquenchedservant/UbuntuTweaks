#!/bin/bash
$SUSER=$(last | grep "logged in")
$SUSER=$( echo $SUSER | cut -d ' ' -f 1)
sudo cp -R /home/$SUSER/.config/accountable2you/* /opt/Accountable2You/accountable2you
echo "$(date) - backed up"
