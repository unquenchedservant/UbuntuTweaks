#!/bin/bash
SUSER=$(last | grep "logged in")
SUSER=$( echo $SUSER | cut -d ' ' -f 1)
cp -R /opt/Accountable2You/accountable2you/* /home/$SUSER/.config/accountable2you
chown -R $SUSER:$SUSER /home/$USER/.config/accountable2you

