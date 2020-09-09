# Linux automatic wallpaper changer
This simple program is being developed with the idea of making a daemon that could chage the wallpaper.

Note that it's still a work in progress.

## Usage

In order to make this script run automatically a `cron` job must be set up.

There are a lot tutorials online, but in a nutshell:

1. Run `crontab -e -u your_username`
2. Add a new rule like `*/10 * * * * export DISPLAY=:0 && /path/to/repo/wallpaper_changer.sh`
3. Save and exit

This rule executes the script once every 10 minutes.
For more detailed information about crontab timing go check out [this (amazing and simple) website](https://crontab.guru/).
