# Accountable2You
These are my Ubuntu tweaks for the accountability software Accountable2You

## Accountable2YouFocal.sh
This allows accountable2you to work on Ubuntu 20.04. Ubuntu 20.04 uses python3.8, and accountable2you is compiled with python3.7. The only way to get this currently is by compiling from the source. This file downloads all the dependencies needed, and can work from a fresh install of Ubuntu 20.04. 

### Installation Instructions
```
$ wget https://github.com/chillhumanoid/UbuntuTweaks/blob/master/Accountable2You/Accountable2YouFocal.sh
$ chmod +x Accountable2YouFocal.sh
$ sudo ./Accountable2YouFocal.sh
```
Allow for 30-40 minutes to compile python

## Global Install
It's very easy to make a new user and circumvent Accountable2You. I created 2 scripts that stop that from happening. 

Unfortunately, there is still a little bit of added work to make it work. 

First, download both a2yback.sh and OnLogin.sh

```
$ wget https://github.com/chillhumanoid/UbuntuTweaks/blob/master/Accountable2You/a2yback.sh
$ wget https://github.com/chillhumanoid/UbuntuTweaks/blob/master/Accountable2You/OnLogin.sh
$ chmod +x a2yback.sh
$ chmod +x OnLogin.sh
```

To make it so that OnLogin runs every time an user logs in, run the following:

```
$ sudo ln -s OnLogin.sh /etc/profile.d/OnLogin.sh
```

And to run the backup every minute edit the root crontab by using ```sudo crontab -e``` and then adding this line at the bottom

```
* * * * * /path/to/a2yback.sh >> /opt/Accountable2You/cron.log 2>&1
```

Every minute is best so that there's no issues with the database. 

Finally, to make it so that whenever a user logs out, it backs up the accountable2you local files, add the following three lines to ```/etc/gdm3/PostSession``` so that it looks like

```bash
#!/bin/bash
SUSER=$(last | grep "logged in")
SUSER=$( echo $SUSER | cut -d ' ' -f 1)
cp -R /home/$USER/.config/accountable2you/* /opt/Accountable2You/accountable2you
exit 0
```

this way if you log out before the minute is up, there's no worry. 
