#!/usr/bin/python
import os
import gi
gi.require_version("Gtk", "3.0")
gi.require_version("AppIndicator3", "0.1")
gi.require_version("Keybinder", '3.0')
from gi.repository import Gtk as gtk, AppIndicator3 as appindicator, Gdk as gdk
from os.path import expanduser
from gi.repository import Keybinder

indicator = 0
home = expanduser("~")
path = "{}/AudioSwitcher".format(home)

def main():
    icon = "{}/headphones.png".format(path)
    global indicator
    indicator = appindicator.Indicator.new("AudioSwitch", icon,
    appindicator.IndicatorCategory.APPLICATION_STATUS)
    set_icon()
    indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
    indicator.set_menu(menu())

    gtk.main()

def set_icon():
    if os.path.exists("{}/.toggle".format(path)):
        indicator.set_icon("{}/speakers.png".format(path))
        
    else:
        indicator.set_icon("{}/headphones.png".format(path))
def menu():
    menu = gtk.Menu()

    switch_command = gtk.MenuItem.new_with_label('Switch')
    switch_command.connect('activate', switch)
    menu.append(switch_command)

    key = Keybinder
    key.bind("<super>N", switch)
    key.init()

    close_command = gtk.MenuItem.new_with_label("Close Tray")
    close_command.connect('activate', quit)
    menu.append(close_command)

    menu.show_all()
    return menu

def switch(_):
    os.system("AudioSwitcher.sh")
    set_icon()

def quit(_):
    gtk.main_quit()

if __name__ == "__main__":
    main()


