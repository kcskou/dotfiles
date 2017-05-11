#!/bin/bash
############################
# This script creates symlinks from the home directory to all dotfiles
# in ~/dotfiles. In order for this to work on Windows, 
# run this script on Git Bash (Run as administrator).
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

########## Functions

# Return true if OS is Windows
windows() { [[ -n "$WINDIR" ]]; }

# Accepts a string, return true if the string contains no '.'
nameHasNoDot() { [[ $(expr index $1 ".") -eq 0 ]]; }

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
if ! pathExists $olddir; then
    printf "Creating $olddir for backup of any existing dotfiles in ~ ..."
    mkdir -p $olddir
    printf "done\n\n"
fi

# move any existing dotfiles in homedir to dotfiles_old directory, then create 
# symlinks from the homedir to any files/dir with no '.' in their basenames
# in the ~/dotfiles directory 
allFiles=$dir/*
for filepath in $allFiles
do
    basename=$(basename $filepath)
    if nameHasNoDot $basename; then
        # Backup existing dotfiles
        if pathExists ~/.$basename; then
            printf "Moving an existing .$basename to $olddir ..."
            mv --backup=numbered ~/.$basename $olddir
            printf "done\n"
        fi
        printf "Creating symlink $HOME/.$basename -> $dir/$basename ..."
        link ~/.$basename $dir/$basename
        printf "done\n\n"
    fi
done

printf "All done.\n"
