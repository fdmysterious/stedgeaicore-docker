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

# Install development dependencies
RUN apt-get install -y bash cmake ninja-build
RUN apt-get install -y wget xz-utils

# Istall arm gcc toolchain from archive file
#ADD --unpack --checksum=sha256:213b181a61be6a5eb64d21f05459a22b723585844cbb4f3e52f28994690cc612 https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz /opt/arm-none-eabi
#ADD --unpack https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz /opt/arm-none-eabi

RUN wget https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz
RUN tar xf /tmp/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz -C /opt
RUN rm /tmp/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz

# Configure path
ENV PATH="$PATH:/opt/stedgeai/3.0/Utilities/linux:/opt/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi/bin"


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
