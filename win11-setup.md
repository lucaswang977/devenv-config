# Windows 11 Host Machine Preparing

## Setting up Windows Terminal
* Save $HOME environmental variable
```
Set-Item -Path Env:\HOME -Value 'C:\Users\lucas'
```

* Nerd font installation
- Download and install the [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip).
- Settings:
  - Powershell - Appearance - Font - JetBrainsMono Nerd Font Mono, Regular, 10

## Install software with winget
* Install git
```
winget install -e --id Git.Git
```

* Git keeps line ending unmodified
```
git config --global core.autocrlf false
```

* Install Docker Desktop
```
winget install -e --id Docker.DockerDesktop
```

* Setting up Docker Desktop
  * Use containerd for pulling and storing images
  * Autostart without openning the dashboard

* Install VSCode, it's useful when we come to Windows
```
winget install -e --id Microsoft.VisualStudioCode
```

## Mouse scrolling direction reverse
* Start a new terminal with Administrator:
* Paste this and run then select "1":
```
$mode = Read-host "How do you like your mouse scroll (0 or 1)?"; Get-PnpDevice -Class Mouse -PresentOnly -Status OK | ForEach-Object { "$($_.Name): $($_.DeviceID)"; Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.DeviceID)\Device Parameters" -Name FlipFlopWheel -Value $mode; "+--- Value of FlipFlopWheel is set to " + (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.DeviceID)\Device Parameters").FlipFlopWheel + "`n" }
```
