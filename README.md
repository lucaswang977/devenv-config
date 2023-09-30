# Development Environtment Setting Goals
Setting up a productive development environment is always a time wasting thing to me. I have two computers(one is Mac Mini M1, and the other is an old Chromebook) with different operating systems. 
Here are my personal requirements:
* It should provide the same development(Linux + NeoVim) experience across those computers;
* It should depend on the operating system as least as possible, which means the machine can be powerwashed without losing data or paying much efforts on environment re-setup.

## Setup
To meet the requirements, I choose Docker to provide the separated environment for development. 

### Host Computer Minimalist Setup
- [ChromeOS with Docker](chromeos-setup.md)
- [MacOSX with Docker desktop](macosx-setup.md)

### Docker Container Building
- Create share folder between host and guest machines.
```bash
mkdir $HOME/share
```

- Build container by docker compose then start it.
```bash
docker compose build
docker compose up -d
```

### Docker Container Login
- Log in the guest machine with ssh.
```bash
ssh root@localhost -p 8822
```

### Container Setup
- GitHub Authorization
- Git global config
 - git config --global user.name "XXX"
 - git config --global user.email "YYY"
- LSP and TreeSitter when using Nvim
 - :LspInstall tsserver
 - :TSInstall typescript

## Optional Tools
- Clipboard sharing between the host and guest machines.
```
mkdir ~/.local
git clone https://github.com/ms-jpq/isomorphic_copy.git ~/.local/clipboard
export PATH=$HOME/.local/clipboard/bin:$PATH
cssh root@localhost -p 8822
```

## Notes
### What is in the container?
- Debian stable slim with build-essentials and a whole bunch of useful tools as exa, ripgrep, etc.
- [Stable version Neovim](https://github.com/neovim/neovim.git) built from source
- [AstroNvim](https://astronvim.com/) as the default nvim config
- Zsh with [Powerlevel10k theme](https://github.com/romkatv/powerlevel10k) setup when login first time
- Nodejs version 18 installed with apt
- [PNPM](https://pnpm.io/) as the default node package management
- GitHub CLI
- Tmux as the default terminal multiplexer with [Oh my tmux!](https://github.com/gpakosz/.tmux)
- No password SSH login with pubkeys (in this folder /pubkeys)
- Separated PostgreSQL database container on port 5432 (hostname "localdb")
- $HOME/share of the host machine is shared as /root/share

### Container Exported Ports
- 3000, 3001 (NextJS)
- 1337 (Strapi admin)
- 5173 (Vite)
- 8822 (bridge with local port 22, for sshd)

### How to update the container?
- (On the host in the repo folder) Stop the container
```bash
docker compose down
```

- (On the host in the repo folder) Rebuild the image
```bash
docker compose build
```

- (On the host) Remove the volume

- (On the host in the repo folder) Start the container
```bash
docker compose up -d
```

### My Customizations on Tmux
- Edit this file /configs/tmux.conf.local
- Disabled C-b

### My Customizations on AstroNvim
- Seperated [config repo](https://github.com/lucaswang977/astronvim-config)
- If you want to add plugins from [AstroNvim Community](https://github.com/AstroNvim/astrocommunity), edit this /plugins/community.lua
- If you want to import plugins manually, edit this file /plugins/user.lua

### Keystrokes should be remembered
- Tmux
- AstroNvim default [key mappings](https://astronvim.com/Basic%20Usage/mappings)
