#! /bin/bash


# This script is used with find command to move files into subdirectories
# based on their file names.

# Assume file names start with year and month (YYYYMM) like this "20200530.jpg"

# Usage: 1. cd to the directory where the files to group are located.
#        2. find . -iname '*?.?*' -type f -exec /path/to/this/script.sh {} +
# Note that '*?.?*' is for avoid matching files like .bashrc and blah.

for i
do
    FILENAME="${i##*/}"
    YEAR="${FILENAME:0:4}" # first 4 chars
    MONTH="${FILENAME:4:2}" # chars 5 to 6
    NEWDIR="$YEAR/$MONTH"
    NEWDIRPATH="$PWD/$NEWDIR"
    echo "mkdir -p \"$NEWDIRPATH\""
    mkdir -p "$NEWDIRPATH"
    echo "mv --target-directory=\"$NEWDIRPATH\" \"$i\""
    mv --target-directory="$NEWDIRPATH" "$i"
done

