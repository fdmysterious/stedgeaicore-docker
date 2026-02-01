FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN echo "Group: $(getent group 1000 | cut -d ':' -f 1)"

# Remove ubuntu user
RUN userdel $(getent passwd 1000 | cut -d ':' -f 1)

# Configure dash to bash
# https://superuser.com/questions/715722/how-to-do-dpkg-reconfigure-dash-as-bash-automatically
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure dash


RUN apt-get update
RUN apt-get install -y libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-sync1 libxcb-xfixes0 libxcb-shape0 libx11-xcb1 libfreetype6 libfontconfig1 libdbus-1-3

WORKDIR /tmp
COPY ./stedgeai-linux-offline .


RUN ./stedgeai-linux-offline --root /opt/stedgeai install -c --al --am stedgeai0300.base stedgeai0300.core stedgeai0300.stm32mculib stedgeai0300.stneuralart
RUN rm /tmp/stedgeai-linux-offline

RUN apt-get install -y bash

ENV PATH="$PATH:/opt/stedgeai/3.0/Utilities/linux"


COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

COPY user_entrypoint.sh /opt/user_entrypoint.sh
RUN chmod +x /opt/user_entrypoint.sh

# Add tini

#ENV TINI_VERSION v0.19.0
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
#RUN chmod +x /tini
#ENTRYPOINT ["/tini", "--", "/opt/entrypoint.sh"]

RUN apt-get install -y gosu

ENTRYPOINT ["/opt/entrypoint.sh"]
