#!/bin/sh
for f in /etc/X11/xinit/xinitrc.d/*
do
    [ -x $f ] && . "$f"
done
unset f

case "$1" in
    xmonad)
        # Set up GTK paths
        export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
        # display background
        if [ -e ~/.background ]; then
            display -antialias -backdrop -window root ~/.background
        else
            xsetroot -gray
        fi
        # Get rid of the beeping
        amixer -c 0 set Beep mute
        # start screensaver
        xscreensaver -nosplash &
        # Setup keybindings
        xmodmap ~/.Xmodmap
        # Yay sound
        pulseaudio --start
        # Trayer will show GUI taskbar items
        trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --heighttype pixel --height 17 --transparent true --tint 0x000000 &
        # dropbox waits for network
        ~/bin/dropbox_wait.sh &
        # volume indicator
        volumeicon &
        # turn off touchpad
        synclient TouchpadOff=1
        # set cursor
        xsetroot -cursor_name left_ptr
        # sleep after 15 minutes idle on battery
        xautolock -time 15 -locker "/home/azakus/bin/idlelock" -detectsleep &
        exec xmonad
        ;;
esac
