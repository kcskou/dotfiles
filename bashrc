############# Functions
windows() { [[ -n "$WINDIR" ]]; }

############# Script
# Enable 256 color mode for the terminal
export TERM=xterm-256color

# env variables
export JAVA_HOME='/usr/java/jdk1.8.0_91'
export PATH=$JAVA_HOME/bin:$PATH

# alias for windows
if windows; then
    alias gvim='/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe'
    alias gvimdiff='/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe -d'
    alias meteor='cmd //c meteor'
fi


