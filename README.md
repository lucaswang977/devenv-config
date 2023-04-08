# Development Environment Setup
Setup a productive development environ is always a time wasting thing to me. Since I have two computers with different operating system. My personal needs are:
* They should provide the same development experiences between my computers, which have different hosting operating systems.
* They should have the minimal dependencies on the host operating systems, which means the machine can be powerwashed whenever I want, without any data loss or much effort on environment re-setup.

### NeoVim with AstroNvim
* https://astronvim.com/Basic%20Usage/mappings

## Host machine setup
I use Docker container to provide a separated environment for development. Before setting the guest container, we should setup the host machine first.

- [ChromeOS with Docker](chromeos-setup.md)
- [MacOSX with Docker desktop](macosx-setup.md)

## Guest development envrionment setup (based on Dockerfile)
Guest container's OS is Debian Bullseye slim.
```bash
docker build -t webdev .
mkdir share
```

## Start the container
```bash
docker run -d --name devenv --env="DISPLAY=host.docker.internal:0" -v /Users/lucas/tmp/share:/root/share -v vroot:/root -w /root -p 5173:5173 -p 2222:22 -h devenv webdev

ssh root@localhost -p 2222
```
