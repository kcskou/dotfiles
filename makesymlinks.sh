#!/bin/bash
############################
# This script creates symlinks from the home directory to all dotfiles
# in ~/dotfiles. In order for this to work on Windows, 
# run this script on Git Bash (Run as administrator).
############################

########## Variables

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  # https://stackoverflow.com/questions/59895/how-to-get-the-source-directory-of-a-bash-script-from-within-the-script-itself
ROOT_DIR=$(dirname $SCRIPT_DIR)  # root directory of the package is 1 level up wherever this script is located
DOTFILES_DIR=$ROOT_DIR/dotfiles
BACKUP_DIR=~/dotfiles_backup        # old dotfiles backup directory

########## Functions

# Return true if OS is Windows
windows() { [[ -n "$WINDIR" ]]; }

# Given an absolute path to a file or directory, return true if it exists
pathExists() { [[ -f "$1" || -d "$1" ]]; }

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
link() {
    if [[ -z "$2" ]]; then
        # Link-checking mode.
        if windows; then
            fsutil reparsepoint query "$1" > /dev/null
        else
            [[ -h "$1" ]]
        fi
    else
        # Link-creation mode.
        if windows; then
            local slashFlipped1="${1//\//\\}"
	    local slashFlipped2="${2//\//\\}"
	    local winPath1="${slashFlipped1:1:1}:${slashFlipped1:2}"
	    local winPath2="${slashFlipped2:1:1}:${slashFlipped2:2}"
            if [[ -d "$2" ]]; then
                cmd <<< "mklink /D $winPath1 $winPath2" > /dev/null
            else
                cmd <<< "mklink $winPath1 $winPath2" > /dev/null
            fi
        else
            ln -s "$2" "$1"
        fi
    fi
}


########## Script

# create dotfiles_old in homedir
if ! pathExists $BACKUP_DIR; then
    printf "Creating $BACKUP_DIR for backup of any existing dotfiles in ~ ..."
    mkdir -p $BACKUP_DIR
    printf "done\n\n"
fi

# move any existing dotfiles in homedir to dotfiles_backup directory, then create 
# symlinks from the homedir to any files/dir with no '.' in their base filenames
# in the dotfiles directory 
BACKUP_DIR_WITH_TIMESTAMP=$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)

DOTFILES=$DOTFILES_DIR/*
for FILEPATH in $DOTFILES
do
    FILENAME=$(basename $FILEPATH)
    # Backup existing dotfiles
    if pathExists ~/.$FILENAME; then
        mkdir -p $BACKUP_DIR_WITH_TIMESTAMP
        printf "Moving an existing ~/.$FILENAME to $BACKUP_DIR_WITH_TIMESTAMP ... "
        mv ~/.$FILENAME $BACKUP_DIR_WITH_TIMESTAMP
        printf "done\n"
    fi
    printf "Creating symlink $HOME/.$FILENAME -> $DOTFILES_DIR/$FILENAME ... "
    link ~/.$FILENAME $DOTFILES_DIR/$FILENAME
    printf "done\n\n"
done

printf "All done.\n"
