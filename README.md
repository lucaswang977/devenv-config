# Development Environment Setup
Setup a productive development environ is always a time wasting thing to me. Since I have two computers with different operating system. My personal needs are:
* They should provide the same development experiences between my computers, which have different hosting operating systems.
* They should have the minimal dependencies on the host operating systems, which means the machine can be powerwashed whenever I want, without any data loss or much effort on environment re-setup.

### NeoVim with LunarVim
* <Space-sk> to show all the commands 
* <Space-Lc> open lunarvim's config file
* <Space-f> find files
* <Space-e> show file explorers
* <Space-Sc> restore the sessions at the last time
* <Space-bj> jump between tabs
* <Space-ts> show all the todolist with telescope
* <C-h/j/k/l> jumping between windows
* <zz> move current line to the center of screen
* <C-g> open neogit for all the git stuff in neovim
* <C-s> open Telescope live_grep

## Host machine setup
*I use Docker container to provide a separated environment for development. Before setting the guest container, we should setup the host machine first.

- [ChromeOS with Docker](chromeos-setup.md)
- [MacOSX with Docker desktop](macosx-setup.md)

## Guest development envrionment setup (based on Dockerfile)

  *Guest container's OS is Debian Bullseye slim.
```bash
docker build -t webdev .
docker volume create vroot
mkdir share
```

### Start the container
```bash
docker run -it --rm -v vroot:/root -v /Users/lucas/tmp/share:/root/share -w /root -p 5173:5173 -h devenv webdev
```
