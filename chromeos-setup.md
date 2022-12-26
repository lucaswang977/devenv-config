# ChromeOS Linux Terminal Setup
- Setup Linux from Settings: Settings -> Developers -> Linux development environment -> Turn on
- *Don't forget the username you inputted while creating this environment*

## Change default Debian Linux container to Ubuntu

**Create Ubuntu container**
- Open the browser, press ctrl+alt+t to open Crosh
- Power off the Linux container
- Fetch Ubuntu container
```bash
vmc start termina
lxc stop penguin --force
lxc delete penguin
lxc launch images:ubuntu/jammy penguin
lxc exec penguin -- bash
```

**Setup Ubuntu**
- System update and install required packages
```bash
apt update
apt install binutils gnupg
```

- Setup Chrome container guest tool
```bash
echo "deb https://storage.googleapis.com/cros-packages bullseye main" > /etc/apt/sources.list.d/cros.list
if [ -f /dev/.cros_milestone ]; then sudo sed -i "s?packages?packages/$(cat /dev/.cros_milestone)?" /etc/apt/sources.list.d/cros.list; fi
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4EB27DB2A3B88B8B
apt update

apt download cros-ui-config # ignore any warning messages
ar x cros-ui-config_0.15_all.deb data.tar.gz
gunzip data.tar.gz
tar f data.tar --delete etc/gtk-3.0/settings.ini
gzip data.tar
ar r cros-ui-config_0.15_all.deb data.tar.gz
rm data.tar.gz
sudo apt install cros-guest-tools ./cros-ui-config_0.15_all.deb
rm cros-ui-config_0.15_all.deb
```

- Shutdown the virtual machine and reboot
```bash
shutdown -h now
```
- Now you can start Linux as normal by clicking the terminal icon

## Setting NERD font
*This setting can take effect after reboot, but will disappear once you open the Setting dialog of the terminal.*
- Press Ctrl+Shift+J to open the developer console when the terminal window is focused.
- Input following code
```javascript
term_.prefs_.set('font-family', 'DejaVu Sans Mono Nerd');
term_.prefs_.set('user-css-text', '@font-face {font-family: "DejaVu Sans Mono Nerd"; src: url("https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf"); font-weight: normal; font-style: normal;}')
```
