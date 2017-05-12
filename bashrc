############# Functions
windows() { [[ -n "$WINDIR" ]]; }

############# Script
# Enable 256 color mode for the terminal
export TERM=xterm-256color

# JDK
export JAVA_HOME=/usr/java/jdk1.8.0_91
export PATH=$JAVA_HOME/bin:$PATH

# Android Studio
export PATH=/opt/android-studio/bin:$PATH


# Aliases
alias getwebsite='wget --recursive `#breadth-first traversal with a max depth of 5` \
                       --page-requisites `#get all files needed to display the HTML page` \
                       --adjust-extension `#adjust extension for local filenames` \
                       --convert-links `#make links suitable for local viewing` \
                       --no-parent `#download only files under directory of given URL` \
                       -e robots=off `#turn off robot exclusion` '
alias getwebsite-stealthy='getwebsite --wait=10 `#wait 10s between retrievals` \
                                      --random-wait `#wait vary between 0.5 and 1.5 times wait seconds` '

# Aliases just for windows
if windows; then
    alias gvim='/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe'
    alias gvimdiff='/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe -d'
    alias meteor='cmd //c meteor'
    alias wget='~/bin/wget64.exe'
fi
