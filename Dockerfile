FROM debian:stable
MAINTAINER Jurjen Bokma "j.bokma@rug.nl"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Setup multiarch because Skype is 32bit only
#RUN dpkg --add-architecture i386

# Make sure the repository information is up to date
RUN apt-get update

# Leftover from PulseAudio attempt
# Install PulseAudio for i386 (64bit version does not work with Skype)
#RUN apt-get install -y libpulse0:i386 pulseaudio:i386
RUN apt-get install -y libpulse0 pulseaudio

# We need
# openssh-server to access the docker container (not any more),
# wget to download skype,
# xeyes for testing X,
# apt-utils for apt itself
# locales for wire
RUN apt-get install -y wget x11-apps apt-utils locales

## Install Skype
RUN wget https://go.skype.com/skypeforlinux-64.deb -O /usr/src/skype.deb
RUN sh -c "apt-get install -y gnupg2 "$(dpkg -I /usr/src/skype.deb |grep Depends:|sed -r '/Depends:/  s/Depends:// ; s/$/,/ ; s/,/:i386/g ')""
RUN dpkg -i /usr/src/skype.deb || true
RUN apt-get install -fy						# Automatically detect and install dependencies
RUN apt-get install -y skypeforlinux

# Install Discord
RUN wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O /usr/src/discord.deb
RUN sh -c "apt-get install -y gnupg2 xserver-xorg-video-intel i965-va-driver $(dpkg -I /usr/src/discord.deb |grep Depends|sed 's/Depends:// ; s/(.*)//g; s/,//g')"
RUN dpkg -i /usr/src/discord.deb || true
RUN apt-get install -fy						# Automatically detect and install dependencies
RUN apt-get install -y discord

# Install BlueJeans
RUN mkdir  -p /root/.local/share/applications
RUN touch /root/.local/share/applications/mimeapps.list
RUN wget 'https://swdl.bluejeans.com/desktop-app/linux/2.2.0/BlueJeans.deb' -O /usr/src/bluejeans.deb
RUN sh -c "apt-get install -y desktop-file-utils $(dpkg -I /usr/src/bluejeans.deb |grep Depends|sed 's/Depends:// ; s/(.*)//g; s/,//g')"
RUN dpkg -i /usr/src/bluejeans.deb || true
RUN apt-get install -fy						# Automatically detect and install dependencies
RUN apt-get install -y bluejeans-v2

# Install Slack
RUN wget 'https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.3-amd64.deb' -O /usr/src/slack.deb
RUN sh -c "apt-get install -y trash-cli"
RUN dpkg -i /usr/src/slack.deb || true
RUN apt-get install -fy						# Automatically detect and install dependencies
RUN apt-get install -y slack-desktop

# Install Wire
RUN apt-get install apt-transport-https
RUN wget -q https://wire-app.wire.com/linux/releases.key -O- | apt-key add -
RUN echo "deb [arch=amd64] https://wire-app.wire.com/linux/debian stable main" > /etc/apt/sources.list.d/wire-desktop.list
RUN apt-get -y update
RUN apt-get -y install wire-desktop
RUN apt-get -y update
RUN apt-get -y dist-upgrade

# Not used at the moment
# Create OpenSSH privilege separation directory, enable X11Forwarding
#RUN mkdir -p /var/run/sshd
#RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Set locale (fix locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true
RUN echo "Europe/Amsterdam" > /etc/timezone

# Not used at the moment.
# Set up the launch wrapper - sets up PulseAudio to work correctly
RUN echo 'export PULSE_SERVER="tcp:localhost:64713"' >> /usr/local/bin/skype-pulseaudio
RUN echo 'PULSE_LATENCY_MSEC=60 skype' >> /usr/local/bin/skype-pulseaudio
RUN chmod 755 /usr/local/bin/skype-pulseaudio

# Create user "docker" and set the password.
RUN useradd -m -d /home/docker docker
RUN echo "docker:secret" | chpasswd
RUN echo "root:verysecret" | chpasswd

## Not used
## Prepare ssh config folder so we can upload SSH public key later
#RUN mkdir /home/docker/.ssh
#RUN chown -R docker:docker /home/docker
#RUN chown -R docker:docker /home/docker/.ssh

# Expose the SSH port
#EXPOSE 22

# BlueJeans?
#EXPOSE 5671 5672 5673 5674 5675 5676 5677 5678 5679

USER docker:docker

# Start a program
#ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/bin/bash"]
