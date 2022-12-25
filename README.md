# Development Environment Setup
On the development envrionment setup, my personal needs are:
* They should provide the same development experiences between my computers, which have different hosting operating systems.
* They should have the minimal dependencies on the host operating systems, which means the machine can be powerwashed whenever I want, without any data loss or much effort on environment re-setup.

## Memo of keybindings
*Keep updating*

### Zsh with Zellij
* Float a window to execute some commands then hide: ctrl+p w

### NeoVim with LunarVim
* <Space-sk> to show all the commands 
* <Space-f> find files
* <Space-e> show file explorers

## Machine setup
*I use Ubuntu Linux(22.04 LTS) (as a guest OS) for the default development environment whatever the host OS is.*

- [ChromeOS with Linux support](chromeos-setup.md)
- [MacOSX with Multipass container](macosx-setup.md)

## Development envrionment setup (Ubuntu operating system)

### ZSH
```bash
# install zsh
sudo apt update
sudo apt upgrade -y
sudo apt install -y zsh
# install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
alias ls='exa'
export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin
```

### [Zellij - Terminal multiplexer](https://github.com/zellij-org/zellij)
```zsh
# install Rust cargo
curl https://sh.rustup.rs -sSf | sh
cargo install --locked zellij
# generate config file for customization
mkdir ~/.config/zellij
zellij setup --dump-config > ~/.config/zellij/config.kdl
# make zellij autostart when login
echo 'eval "$(zellij setup --generate-auto-start zsh)"' >> ~/.zshrc
```

### [NodeJS](https://github.com/nodesource/distributions/blob/master/README.md)
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
```

### [NeoVim unstable version](https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu)
*I choose the unstable version because the version in stable channel is only 0.7.x*

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --config vi
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --config vim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --config editor
```

### [LunarVim](https://www.lunarvim.org/docs/installation)
```bash
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
```
