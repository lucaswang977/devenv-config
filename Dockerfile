FROM manjarolinux/build:latest

RUN pacman -Syy
RUN pacman -S --noconfirm openssh
RUN /usr/bin/ssh-keygen -A
RUN echo 'root:password' | chpasswd && \
    sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir /run/sshd
COPY pubkeys/macm1.pub /root/
COPY pubkeys/chromebook.pub /root/
RUN cat /root/macm1.pub > /root/.ssh/authorized_keys
RUN cat /root/chromebook.pub >> /root/.ssh/authorized_keys
RUN rm /root/macm1.pub
RUN rm /root/chromebook.pub
RUN chmod 600 /root/.ssh/authorized_keys

RUN pacman -S --noconfirm neovim nushell zellij ripgrep fd unzip wget docker
RUN pacman -S --noconfirm nodejs-lts-hydrogen npm
RUN pacman -S --noconfirm github-cli glow stylua jq
RUN mkdir ~/.npm-global && \
  npm config set prefix '~/.npm-global' && \
  npm install -g pnpm prettier

# Config neovim
RUN rm -rf ~/.config/nvim
RUN git clone https://github.com/lucaswang977/nvim-config.git ~/.config/nvim
RUN nvim --headless +qa

# Config zellij
RUN mkdir -p /root/.config/zellij
COPY configs/zellij/config.kdl /root/.config/zellij/
COPY configs/zellij/layout.kdl /root/.config/zellij/

# Config starship
RUN pacman -S --noconfirm starship
RUN mkdir ~/.cache/starship
RUN starship init nu > ~/.cache/starship/init.nu
RUN mkdir ~/.config/starship
COPY configs/starship/starship.toml /root/.config/starship/

# Config zoxide
RUN pacman -S --noconfirm zoxide
RUN zoxide init nushell > ~/.zoxide.nu

# Config nushell
RUN mkdir -p /root/.config/nushell
COPY configs/nushell/config.nu /root/.config/nushell/
COPY configs/nushell/env.nu /root/.config/nushell/
COPY configs/nushell/myenv.nu /root/.config/nushell/
RUN chsh -s /bin/nu

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
