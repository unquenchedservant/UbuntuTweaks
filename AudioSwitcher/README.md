# AudioSwitcher
I have speakers and headphones that i got tired of unplugging and switching.
So I've started setting up this script to have a hotkey that switches the audiofeed

## Considerations
assumes card name is generic
assumes that only 3 possible options for card ID

## To Use:
Download all files into "AudioSwitcher" folder located in your $HOME folder
move AudioSwitcher.sh to /usr/local/bin/AudioSwitcher.sh

chmod +X AudioSwitcher.sh

Utilizes SUPER + n for it's keybinding, so make sure that is available
or change the keybinding located under menu() in tray.py

Add "nohup python3 /home/{user}/AudioSwitcher/tray.py &" to your startup applications

done. :) 
