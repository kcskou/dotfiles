#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="vimrc gitignore_global gitconfig vim"    # list of files/folders to symlink in homedir

########## Functions

windows() { [[ -n "$WINDIR" ]]; }

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
            # Windows needs to be told if it's a directory or not. Infer that.
            # Also: note that we convert `/` to `\`. In this case it's necessary.
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
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo -n "Moving any existing .$file to $olddir ..."
    mv ~/.$file ~/dotfiles_old/
    echo "done"
    echo -n "Creating symlink to $file in $HOME ..."
    link ~/.$file $dir/$file
    echo "done"
done
