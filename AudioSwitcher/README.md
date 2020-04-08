# AudioSwitcher
I have speakers and headphones that i got tired of unplugging and switching.
So I've started setting up this script to have a hotkey that switches the audiofeed

## Considerations
assumes card name is generic
assumes that only 3 possible options for card ID

## Dependencies
Need a few things to make the python script work

[First, install based on your system following these instructions](https://pygobject.readthedocs.io/en/latest/getting_started.html)

> For what it's worth, using Ubuntu 20.04, I didn't need to install using the above instructions, but I needed to install keybinder and appindicator using the below instructions

Then you may need to run these two commands to get Keybinder and AppIndicator

```sudo apt install gir1.2-keybinder```

```sudo apt install gir1.2-appindicator3-0.1```

## To Use:
Download all files into `/home/user/AudioSwitcher`

```
$ cd ~/AudioSwitcher
$ chmod +X AudioSwitcher.sh
$ sudo ln -s AudioSwitcher.sh /usr/local/bin/AudioSwitcher.sh
```

Utilizes SUPER + n for it's keybinding, so make sure that is available
or change the keybinding located under menu() in tray.py (currently line 40 of tray.py)

Finally:

Add ```nohup python3 /home/{user}/AudioSwitcher/tray.py &``` to your startup applications

