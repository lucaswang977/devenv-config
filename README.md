# Development Environment Setup
On the development envrionment setup, my personal needs are:
* They should provide the same development experiences between my computers, which have different hosting operating systems.
* They should have the minimal dependencies on the host operating systems, which means the machine can be powerwashed whenever I want, without any data loss or much effort on environment re-setup.

## Memo of keybindings
*Keep updating*

### NeoVim with LunarVim
* <Space-sk> to show all the commands 
* <Space-Lc> open lunarvim's config file
* <Space-f> find files
* <Space-e> show file explorers
* <Space-Sc> restore the sessions at the last time
* <Space-bj> jump between tabs
* <Space-ts> show all the todolist with telescope
* <C-h/j/k/l> jumping between windows
* <zz> move current line to the center of screen
* <C-g> open neogit for all the git stuff in neovim
* <C-s> open Telescope live_grep

## Machine setup
*I use Ubuntu Linux(22.04 LTS) (as a guest OS) for the default development environment whatever the host OS is.*

- [ChromeOS with Linux support](chromeos-setup.md)
- [MacOSX with Multipass container](macosx-setup.md)

## Development envrionment setup (Ubuntu operating system)

### ZSH & powerlevel10k theme & byobu
```bash
# install zsh
sudo apt update
sudo apt upgrade -y
sudo apt install -y zsh byobu
# install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
# install zsh-vi-mode
git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode
echo 'source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh' >>~/.zshrc
# enable byobu autostart
byobu-enable
```

### Development essentials
```zsh
# software-properties-common is for the command 'apt-add-repository'
sudo apt install software-properties-common exa fd-find fzf bat ripgrep build-essential
mkdir -p ~/.local/bin
ln -s $(which batcat) ~/.local/bin/bat
ln -s $(which fdfind) ~/.local/bin/fd
```

## [GitHub CLI](https://github.com/cli/cli#installation)
```
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

### Aliases and PATH modifications in .zshrc
```zsh
# Reverse search in shell history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups

# Aliases
alias ls='exa'
alias ll='ls -l'
alias lls='ls --sort=size -l'
alias l='ll -a'
alias vi='lvim'

# Executive path setting
export PATH=$PATH:$HOME/.local/bin:$HOME/.npm-global/bin
```

### [NodeJS](https://github.com/nodesource/distributions/blob/master/README.md)
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
npm install -g prettier emmet-ls
```

### [NeoVim stable version](https://github.com/neovim/neovim/wiki/Building-Neovim)
We have to compile the NeoVim manually because:
- At this time, both ubuntu official package source and neovim-ppa source doesn't provide the stable 0.8.x version, we have to compile it manually.
- On Apple Silicon the prebuilt packages do not contain the support for LuaJIT which is quite important to several NeoVim extensions.

```bash
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake pkg-config unzip doxygen
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
cd ..
rm -rf neovim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/local/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 60
sudo update-alternatives --config editor
```

### [LunarVim](https://www.lunarvim.org/docs/installation)
```bash
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
```
- Download config.lua and replace your $HOME/.config/lvim/config.lua with it.
- Comment the autocmd
- Run :PackerSync
- Restart lunarvim and uncomment the autocmd
