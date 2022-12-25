# My MacOSX Development Environment Setup
* I agree with the designing philosophy of ChromeOS, software is just a service, I don't want to install many packages locally. So iTerm2 will not be included.
* To minimize affecting to the default MacOS system, I choose to use Canonical Multipass to setup local virtual machines instead of installing development environment in the system directly.

## Basic installations
- xcode-select --install
- Rosetta 2
- /usr/sbin/softwareupdate --install-rosetta --agree-to-license

## [Canonical Multipass](https://multipass.run/) 
* Nothing fancy but download the package and install
* Choose the latest LTS version of Ubuntu to start

```bash
multipass launch jammy -c 2 -n ubuntu-machine
multipass shell ubuntu-machine
```

## Terminal.app Setup
- Install the [DejaVu Sans Mono Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf) font.
- Default Terminal profile should be set to 'Pro', and the font will be 'DejaVu Sans Mono Nerd 13'.
- Open a new Terminal window
