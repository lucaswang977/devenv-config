# 使用官方Debian镜像作为基础镜像
FROM debian:bullseye-slim

# 安装curl，用于添加Node.js源
RUN apt-get update && \
  apt-get install -y curl && \
  rm -rf /var/lib/apt/lists/*

# 添加Node.js官方源，并安装Node.js最新的稳定版
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get update && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir ~/.npm-global && \
  npm config set prefix '~/.npm-global' && \
  npm install -g prettier emmet-ls

# 安装zsh、curl、git、python3、pip、编译工具和依赖项
RUN apt-get update && \
  apt-get install -y zsh byobu curl git python3 python3-pip build-essential cmake gettext libtool-bin autoconf automake pkg-config unzip exa fd-find fzf bat ripgrep && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/.local/bin && \
  ln -s $(which batcat) ~/.local/bin/bat && \
  ln -s $(which fdfind) ~/.local/bin/fd

# 从源代码编译并安装Neovim 0.8
RUN git clone https://github.com/neovim/neovim.git --branch v0.8.0 --depth 1 && \
  cd neovim && \
  make CMAKE_BUILD_TYPE=Release && \
  make install && \
  cd .. && \
  rm -rf neovim && \
  ln -s /usr/local/bin/nvim /usr/local/bin/vi && \
  ln -s /usr/local/bin/nvim /usr/local/bin/vim

# 安装lunarvim
RUN bash -c "export LV_BRANCH='release-1.2/neovim-0.8' && bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)"

# 添加lvim命令到全局路径
RUN ln -s /root/.local/bin/lvim /usr/local/bin/lvim

# 将vi和vim命令指向lvim
RUN ln -sf /usr/local/bin/lvim /usr/local/bin/vi && \
  ln -sf /usr/local/bin/lvim /usr/local/bin/vim

# Config LunarVim
COPY config.lua /root/.config/lvim/config.lua

# Install GitHub CLI
RUN type -p curl >/dev/null || apt install curl -y && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt update && \
  apt install gh -y

# Zsh as the default shell
RUN chsh -s /bin/zsh

# Install Powerlevel10k theme and vimode plugin
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k && \
  echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc && \
  git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode && \
  echo 'source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh' >>~/.zshrc

# Config Zsh
COPY .zshrc /root/.zshrc

# Update system
RUN apt-get update && \
  apt-get install -y iputils-ping dnsutils net-tools x11-apps && \
  apt-get upgrade -y && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["byobu"]
