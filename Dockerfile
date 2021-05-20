FROM ubuntu:18.04
MAINTAINER Daniel Guerra

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install -y software-properties-common apt-utils
RUN add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" && apt update
RUN apt-get -y install   adobe-flashplugin \
                         browser-plugin-freshplayer-pepperflash \
                         ca-certificates \
                         dbus-x11 \
                         firefox \
                         libx11-6 \
                         libx11-xcb1 \
                         libfontconfig1 \
                         sudo \
                         supervisor \
                         openbox \
                         xauth \
                         xautolock \
                         xfce4 \
                         xfce4-clipman-plugin \
                         xfce4-cpugraph-plugin \
                         xfce4-netload-plugin \
                         xfce4-screenshooter \
                         xfce4-taskmanager \
                         xfce4-terminal \
                         xfce4-xkb-plugin \
                         xvfb \
                         x11vnc  \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*

# Add german characters in terminal
RUN echo "set convert-meta off" >> /etc/inputrc
RUN echo "xfce4-session" > /etc/skel/.Xclients
RUN addgroup ubuntu
RUN useradd -m -s /bin/bash -g ubuntu ubuntu
RUN echo "ubuntu:ubuntu" | /usr/sbin/chpasswd
RUN echo "ubuntu    ALL=(ALL) ALL" >> /etc/sudoers
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir /var/log/supervisor
RUN mkdir /var/run/dbus
ADD bin /bin
# RUN mv /usr/bin/Xorg /usr/bin/Xorg-orig ; mv  /usr/bin/X /usr/bin/X-orig ; cp /usr/bin/Xvfb /usr/bin/Xorg; cp /usr/bin/Xvfb /usr/bin/X

ENV DISPLAY :0

EXPOSE 5900

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["supervisord"]
