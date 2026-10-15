FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y sudo dbus-x11 gsettings-desktop-schemas gnome-shell-common mutter-common gnome-settings-daemon-common desktop-file-utils
RUN useradd --create-home --shell /bin/bash setup-test && echo 'setup-test ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/setup-test
COPY --chown=setup-test:setup-test setup.sh myzsh.zsh myKittyConfig.conf current-theme.conf cheatsheet.txt pixegami-agnoster.zsh-theme init.lua lazy-lock.json /home/setup-test/environment/
COPY --chown=setup-test:setup-test lua /home/setup-test/environment/lua
COPY --chown=setup-test:setup-test scripts /home/setup-test/environment/scripts
COPY --chown=setup-test:setup-test desktop /home/setup-test/environment/desktop
COPY --chown=setup-test:setup-test ai /home/setup-test/environment/ai
COPY --chown=setup-test:setup-test docs /home/setup-test/environment/docs
USER setup-test
WORKDIR /home/setup-test/environment
ENV HOME=/home/setup-test XDG_CURRENT_DESKTOP=ubuntu:GNOME
# Private D-Bus and container home: cannot change host desktop settings.
CMD ["dbus-run-session", "--", "bash", "setup.sh"]
