FROM alpine:latest

# System utils
RUN apk add --update musl-locales bash tzdata shadow zsh net-tools bind-tools curl wget unzip exa fzf fd bat ripgrep bottom

# Development related
RUN apk add --update build-base byobu nodejs npm neovim python3 py3-pip github-cli jq

# Other utilities
RUN apk add --update ffmpeg

# X11 related
RUN apk add --update xsel xclip xterm xclock

# Setup locales
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "Asia/Tokyo" >  /etc/timezone
ENV MUSL_LOCPATH=/usr/share/i18n/locales/musl
ENV TZ=Asia/Tokyo
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN mkdir ~/.npm-global && \
  npm config set prefix '~/.npm-global' && \
  npm install -g prettier emmet-ls

# Install Powerlevel10k theme and vimode plugin
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k && \
  echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc && \
  git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode && \
  echo 'source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh' >>~/.zshrc

# Install AstroNvim
RUN rm -rf ~/.config/nvim
RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

ENV RUNNING_IN_DOCKER=true

# Config Zsh
RUN echo -e "\n# Reverse search in shell history\nHISTFILE=~/.zsh_history\nHISTSIZE=10000\nSAVEHIST=10000\nsetopt append_history\nsetopt share_history\nsetopt hist_ignore_all_dups\n\n# Aliases\nalias ls='exa'\nalias ll='ls -l'\nalias l='ll -al'\nalias vi='nvim'\nalias cat='bat'\n\n# Executive path setting\nexport PATH=$PATH:$HOME/.npm-global/bin" >> ~/.zshrc

# Change shell to zsh
RUN sed -i 's/\/bin\/ash/\/bin\/zsh/' /etc/passwd

CMD ["byobu"]
