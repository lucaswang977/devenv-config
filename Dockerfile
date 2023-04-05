FROM alpine:edge

# System utils
RUN apk add --update musl-locales su-exec tzdata shadow zsh net-tools bind-tools curl wget unzip exa fzf fd bat ripgrep bottom

# Development related
RUN apk add --update byobu nodejs npm neovim python3 py3-pip build-base github-cli jq

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

RUN adduser -D -S -s /bin/zsh alpine && echo "alpine:abcdabcd" | chpasswd
RUN chmod u+s /sbin/su-exec

USER alpine
WORKDIR /home/alpine

RUN mkdir ~/.npm-global && \
  npm config set prefix '~/.npm-global' && \
  npm install -g prettier emmet-ls

# Install Powerlevel10k theme and vimode plugin
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k && \
  echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc && \
  git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode && \
  echo 'source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh' >>~/.zshrc

# Config Zsh
COPY .zshrc ~/.zshrc

# Config git
COPY .gitconfig ~/.gitconfig

# Python dev environment
RUN pip3 install --user pipenv

# Install AstroNvim
RUN rm -rf ~/.config/nvim
RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

CMD ["byobu"]