# My MacOSX Development Environment Setup
* I agree with the designing philosophy of ChromeOS, software is just a service, I don't want to install many packages locally. So iTerm2 will not be included.
* To minimize affecting to the default MacOS system, I choose to use Docker to setup a container instead of installing development environment into the host system directly.

## Basic installations
- xcode-select --install
- /usr/sbin/softwareupdate --install-rosetta --agree-to-license # install Rosetta 2 on Apple Sillicon

## [Docker Desktop](https://www.docker.com/products/docker-desktop/) 
* Nothing fancy but download the package and install

## Terminal.app Setup
- Install the [DejaVu Sans Mono Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf) font.
- Choose 'Pro' and set it as the default
- Set the font and size to 'DejaVu Sans Mono Nerd 13'.
- Set the Window Size to 150x40
