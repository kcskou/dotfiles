# Usage

### Clone this package into home directory
```
cd ~
git clone https://github.com/kcskou/dotfiles.git
```

### Pull submodules
oh-my-zsh custom plugins are checked in as git submodules
```
cd ~/dotfiles
git submodule update --init --recursive
```

### Create symlinks in home directory pointing to the dotfiles
```
~/dotfiles/bin/makesymlinks.sh
```

# To add new oh-my-zsh plugins as git submodules

1. Confirm that .zshrc points to the custom directory: `ZSH_CUSTOM=~/dotfiles/oh-my-zsh/custom/`

2. Go to the plugin directory: `cd ~/dotfiles/oh-my-zsh/custom/plugin`

3. Confirm that the repository of the plugin does not already exist in this directory.

4. Add submodules (zsh-autosuggestions as example): `git submodule add https://github.com/zsh-users/zsh-autosuggestions.git`

5. Go to the cloned repo directory, and confirm that `git status` shows that this is a git repository.

6. Go back to parent repository, and confirm that `git status` shows that the parent repo is aware of the new submodule. Then commit the change as usual.
