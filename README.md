# Development Environtment Setup Notes

## Description
Setting up a productive development environment is always a time wasting thing to me. I am usually using two computers (one Mac Mini M1 and an old Pixelbook), which have different architecture (x86 & arm64) and operating systems.

Here are my personal requirements for setting up development environment:
* It should provide the same development(Linux + NeoVim) experience across those computers;
* It should depend on the operating system as least as possible, the machine can be powerwashed without losing data or paying much efforts on environment re-setup.

## Setup
To meet the requirements, I choose using Docker to provide the separated environment for development. 

### Host Computer Minimalist Setup
- [ChromeOS Setup](chromeos-setup.md)
- [MacOSX Setup](macosx-setup.md)

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
```bash
gh auth login
```

- Git global config
```bash
git config --global user.name "XXX"
git config --global user.email "YYY"
git config --global pull.rebase true
  ```

## Notes

### What are included in the container?
- ManjaroLinux (manjarolinux/build:latest, unofficial image) because it can provide consistent experience between x86 and arm64.
- [Stable version Neovim](https://github.com/neovim/neovim.git) with [self-configured dotfiles](https://github.com/lucaswang977/nvim-config).
- [Nushell](https://www.nushell.sh/) and [Starship](https://starship.rs/) customizable prompt.
- Nodejs version 20 installed with pacman
- [PNPM](https://pnpm.io/) as the default node package management
- GitHub CLI
- [Zellij](https://zellij.dev/) as the default terminal multiplexer.
- [Glow](https://github.com/ellisonleao/glow.nvim) for markdown preview in console and neovim
- SSH login with credentials (trusted host's pubkeys are in /pubkeys)
- Separated PostgreSQL database container on port 5432 (hostname "localdb") and [pgAdmin](https://www.pgadmin.org/) on port 18080 for DB management.
- $HOME/share of the host machine is shared as /root/share

### Container Exported Ports
- 3000, 3001 (NextJS)
- 1337 (Strapi admin)
- 5173 (Vite)
- 8822 (bridge with local port 22, for sshd)
- 18080 (pgAdmin)

### How to update the container?
- (On the host in the repo folder) Stop the container
```bash
docker compose down
```

- (On the host in the repo folder) Rebuild the image
```bash
docker compose build
```

- (On the host) Remove the volume (optional if you update the updated config files inside the container manually)
```bash
docker volume rm devenv-config_vroot
```

- (On the host) Remove the ssh known hosts
```bash
rm ~/.ssh/known_hosts
```

- (On the host in the repo folder) Start the container
```bash
docker compose up -d
```

### Memo
- Clipboard sharing between host and guest is by using OSC52 supported terminal emulators.
- Nushell & starship & zellij configuration files are included in this repository.
- Zellij keystrokes are shown on the user interface already, we don't have to remember them.

### Important Keystrokes
- Neovim

| Shortcuts     |               Action                    |
|---------------|-----------------------------------------|
| Space lS      | Toggle function list (LSP needed)       |
| Space le      | Eslint fix all                          |
| Space w       | Save the file                           |
| Space q       | Quit all the editting files             |
| Space e       | Open the file explorer                  |
| Space ff      | Telescope for opening files             |
| Space fg      | Telescope for grepping files            |
| Ctrl+up/down  | Move line/block up/down a line          |
| gc            | Toggle commment                         |
| :LspInstall   | Install LSP server                      |
| :TSInstall    | Install tree-sitter language support    |
| :Glow         | Markdown file preview                   |

## History
- Phase 3 (2023.10, current)
  - Docker with ManjaroLinux.
  - Neovim was fetched from the OS package repo. Neovim configured from scratch.
  - Nushell + Zellij as the default shell and multiplexer.
- Phase 2 (2023.6)
  - Docker with Debian Bullseye slim.
  - Neovim was built from source, LunarVim/Astronvim was used as the default nvim setting.
  - Byobu / tmux was used as the multiplexer.
- Phase 1 (2022.12)
  - Canonical multipass on Mac and customized linux container on ChromeOS
  - Neovim was built from source.
