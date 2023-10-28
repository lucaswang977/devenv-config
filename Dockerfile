FROM debian:stable-slim

# System dependencies
RUN apt update && apt install -y -q bash curl git sudo build-essential locales openssh-server

# Install Homebrew
RUN useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew

USER linuxbrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# Config Homebrew
USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew
RUN chown -R linuxbrew: /home/linuxbrew/.linuxbrew

# Install softwares by Homebrew
RUN brew install neovim
RUN brew install nushell zellij
RUN brew install gh node@20 pnpm prettier

# Config timezone and locale
ENV TZ=Asia/Tokyo
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && locale-gen

# Config SSH login with credentials
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

# Config Clipboard between host and container
RUN git clone https://github.com/ms-jpq/isomorphic_copy.git /root/.local/clipboard

# Config neovim
RUN rm -rf ~/.config/nvim
RUN git clone https://github.com/lucaswang977/nvim-config.git ~/.config/nvim
RUN nvim --headless +qa

# Config zellij
RUN mkdir -p /root/.config/zellij
COPY configs/zellij/config.kdl /root/.config/zellij/
RUN echo 'PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.bashrc
RUN eval zellij setup --generate-auto-start bash >> ~/.bashrc

# Config nushell
RUN mkdir -p /root/.config/nushell
COPY configs/nushell/config.nu /root/.config/nushell/
COPY configs/nushell/env.nu /root/.config/nushell/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
