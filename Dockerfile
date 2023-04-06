FROM debian:stable-slim

RUN apt-get update

RUN apt-get install -y curl zsh wget unzip exa fzf fd-find bat ripgrep htop iputils-ping dnsutils net-tools

RUN apt-get install -y build-essential git cmake gettext libtool-bin autoconf automake pkg-config byobu python3 python3-pip jq

# Build Neovim 0.8
RUN git clone https://github.com/neovim/neovim.git --branch release-0.8 --depth 1 && \
  cd neovim && \
  make CMAKE_BUILD_TYPE=Release && \
  make install && \
  cd .. && \
  rm -rf neovim && \
  ln -s /usr/local/bin/nvim /usr/local/bin/vi && \
  ln -s /usr/local/bin/nvim /usr/local/bin/vim

RUN apt-get install -y x11-apps ffmpeg

RUN mkdir -p ~/.local/bin && \
  ln -s $(which batcat) ~/.local/bin/bat && \
  ln -s $(which fdfind) ~/.local/bin/fd

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get update && \
  apt-get install -y nodejs

RUN mkdir ~/.npm-global && \
  npm config set prefix '~/.npm-global' && \
  npm install -g prettier emmet-ls

# Setup timezone & locales
RUN apt-get install -y locales
ENV TZ=Asia/Tokyo
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Install GitHub CLI
RUN type -p curl >/dev/null || apt install curl -y && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt-get update && \
  apt-get install gh -y

# Change shell to zsh
RUN chsh -s /bin/zsh

# Install Powerlevel10k theme and vimode plugin
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k && \
  echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc && \
  git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode && \
  echo 'source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh' >>~/.zshrc

# Install AstroNvim
RUN rm -rf ~/.config/nvim
RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

RUN pip3 install --user pipenv

ENV RUNNING_IN_DOCKER=true

# Config Zsh
RUN echo "\n# Reverse search in shell history\nHISTFILE=~/.zsh_history\nHISTSIZE=10000\nSAVEHIST=10000\nsetopt append_history\nsetopt share_history\nsetopt hist_ignore_all_dups\n\n# Aliases\nalias ls='exa'\nalias ll='ls -l'\nalias l='ll -al'\nalias vi='nvim'\nalias cat='bat'\n\n# Executive path setting\nexport PATH=$PATH:$HOME/.npm-global/bin:$HOME/.local/bin" >> ~/.zshrc

RUN apt-get update && apt-get upgrade -y

CMD ["byobu"]
