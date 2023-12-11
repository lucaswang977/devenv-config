# MacOSX Host Machine Preparing

## Basic installations
- Install XCode and Rosetta (for Apple Silicon)
```bash
xcode-select --install
/usr/sbin/softwareupdate --install-rosetta --agree-to-license 
```

## Install Docker Desktop
- Download the [package](https://www.docker.com/products/docker-desktop/) and install it

## Install the terminal emulator (iTerm2)
- Download and install the [package](https://iterm2.com/downloads.html)
- Download and install the [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip).
- Preference:
  - Profiles - Text - JetBrainsMono Nerd Font, Regular, 12
  - Profiles - Keys - Left Option key: Esc+ / Right Option key: Esc+

## Install the tiling window manager (Amethyst)
- Download and install the [package](https://ianyh.com/amethyst/)
- Preference: 
  - Floating - tick "Float small windows"
  - Floating - "Automatically float all applications except those listed" - com.google.Chrome & com.googlecode.iterm2
