# My MacOSX Development Environment Setup
* I agree with the designing philosophy of ChromeOS, software is just a service, I don't want to install many packages locally. So iTerm2 will not be included.
* To minimize affecting to the default MacOS system, I choose to use Canonical Multipass to setup local virtual machines instead of installing development environment in the system directly.

## Basic installations
- xcode-select --install
- /usr/sbin/softwareupdate --install-rosetta --agree-to-license # install Rosetta 2 on Apple Sillicon

## [Canonical Multipass](https://multipass.run/) 
* Nothing fancy but download the package and install
* Choose the latest LTS version of Ubuntu to start

```bash
multipass launch jammy -c 2 -n ubuntu-machine
multipass shell ubuntu-machine
```

## Terminal.app Setup
- Install the [DejaVu Sans Mono Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf) font.
- Choose 'Pro' and set it as the default
- Set the font and size to 'DejaVu Sans Mono Nerd 13'.
- Set the Window Size to 150x40
