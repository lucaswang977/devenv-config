# ChromeOS Linux Terminal Setup
- Setup Linux from Settings: Settings -> Developers -> Linux development environment -> Turn on
- *Don't forget the username you inputted while creating this environment*

## Setting up Docker
- Add Docker's official GPG key and setup the repo:
```bash
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- Update the apt and install the latest version of Docker
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

- Add current user to Docker's user group and don't forget to reboot
```bash
sudo usermod -aG docker $USER
reboot
```


## Setting NERD font
*This setting can take effect after reboot, but will disappear once you open the Setting dialog of the terminal.*
- Press Ctrl+Shift+J to open the developer console when the terminal window is focused.
- Input following code
```javascript
term_.prefs_.set('font-family', 'DejaVu Sans Mono Nerd');
term_.prefs_.set('user-css-text', '@font-face {font-family: "DejaVu Sans Mono Nerd"; src: url("https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf"); font-weight: normal; font-style: normal;}')
```
