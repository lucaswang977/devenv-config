FROM debian:stable-slim

RUN apt-get update

RUN apt-get install -y curl apt-utils apt-file ca-certificates gnupg zsh wget telnet unzip exa fzf fd-find bat ripgrep htop iputils-ping dnsutils net-tools

RUN apt-get install -y build-essential git cmake gettext libtool-bin autoconf automake pkg-config tmux python3 python3-pip jq

# Build Neovim stable
RUN git clone https://github.com/neovim/neovim.git --branch stable --depth 1 && \
  cd neovim && \
  make CMAKE_BUILD_TYPE=Release && \
  make install && \
  cd .. && \
  rm -rf neovim && \
  ln -s /usr/local/bin/nvim /usr/local/bin/vi && \
  ln -s /usr/local/bin/nvim /usr/local/bin/vim

RUN mkdir -p ~/.local/bin && \
  ln -s $(which batcat) ~/.local/bin/bat && \
  ln -s $(which fdfind) ~/.local/bin/fd

# Change shell to zsh
RUN chsh -s /bin/zsh

# Install Powerlevel10k theme and vimode plugin
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k && \
  echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc && \
  git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode && \
  echo 'source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh' >>~/.zshrc

# Setup timezone & locales
RUN apt-get install -y locales
ENV TZ=Asia/Tokyo
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen

# Config Zsh
RUN echo "\n# Reverse search in shell history\nexport HISTFILE=~/.zsh_history\nexport HISTSIZE=10000\nexport SAVEHIST=10000\nsetopt append_history\nsetopt share_history\nsetopt hist_ignore_all_dups\n" >> ~/.zshrc
RUN echo "\n# Aliases\nalias ls='exa'\nalias ll='ls -l'\nalias l='ll -al'\nalias vi='nvim'\nalias cat='bat'\nalias npm='pnpm'\nalias npx='pnpx'\n"  >> ~/.zshrc
RUN echo "\n# Executive path setting\nexport PATH=$HOME/.local/clipboard/bin:$PATH:$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.local/share/pnpm\nexport DISPLAY=host.docker.internal:0\n\nexport LC_ALL=en_US.UTF-8\nexport LANG=en_US.UTF-8\nexport LANGUAGE=en_US.UTF-8\nexport EDITOR=vim\n" >> ~/.zshrc
RUN echo "\nexport PNPM_HOME=$HOME/.local/share/pnpm\n"  >> ~/.zshrc

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN NODE_MAJOR=18; echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update; apt-get install nodejs -y

# Install Yarn & PNPM
RUN mkdir ~/.npm-global && \
  npm config set prefix '~/.npm-global' && \
  npm install -g yarn pnpm prettier

# Install GitHub CLI
RUN type -p curl >/dev/null || apt install curl -y && \
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
  apt-get update && \
  apt-get install gh -y

# Install AstroNvim
RUN rm -rf ~/.config/nvim
RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
RUN git clone https://github.com/lucaswang977/astronvim-config.git ~/.config/nvim/lua/user
RUN vi --headless +qa

ENV RUNNING_IN_DOCKER=true

# Config Clipboard between host and container
RUN git clone https://github.com/ms-jpq/isomorphic_copy.git /root/.local/clipboard

# Setup tmux
RUN git clone https://github.com/gpakosz/.tmux.git /root/.local/.tmux
RUN ln -s /root/.local/.tmux/.tmux.conf /root/.tmux.conf
COPY configs/tmux.conf.local /root/.tmux.conf.local

RUN apt-get update && apt-get upgrade -y && apt-file update

# Install SSH & login with credentials
RUN apt-get install -y openssh-server
RUN echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir /run/sshd
RUN mkdir -p /root/.ssh && touch /root/.ssh/authorized_keys
COPY pubkeys/macm1.pub /root/
COPY pubkeys/chromebook.pub /root/
RUN cat /root/macm1.pub >> /root/.ssh/authorized_keys
RUN cat /root/chromebook.pub >> /root/.ssh/authorized_keys
RUN rm /root/macm1.pub
RUN rm /root/chromebook.pub
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
