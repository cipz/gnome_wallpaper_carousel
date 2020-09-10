# Linux automatic wallpaper changer
This simple program is being developed with the idea of making a daemon that could chage the wallpaper automatically.

Note that it's still a work in progress.

## Usage

### Configuration

The main file in this repo is `wallpaper_changer.sh`

The repository is composed by two files:
1. `config.json`: this file contains the configuration for the tool (directory of the wallpaper images, current wallpaper, etc.);
2. `wallpaper_changer.sh`: this script actually changes the wallpaper on the computer.

### `crontab`

In order to make this script run automatically a `cron` job must be set up.

There are a lot tutorials online, but in a nutshell:

1. Run `crontab -e -u your_username`
2. Add a new rule like `*/10 * * * * export DISPLAY=:0 && /path/to/repo/wallpaper_changer.sh`
3. Save and exit

This rule executes the script once every 10 minutes.
For more detailed information about crontab timing go check out [this (amazing and simple) website](https://crontab.guru/).

Clone the repo in the `bin` folder or in the folders you keep for custom scripts so that you don't have it laying around.

In [this stackoverflow answer](https://askubuntu.com/questions/140305/cron-not-able-to-succesfully-change-background) it's explained why `gsettings` does not play well with `cron` and `crontab`.
