#FROM ubuntu:18.04
#FROM ubuntu:20.04
FROM ubuntu:22.04
RUN apt-get update -y
RUN apt-get install -y tzdata
ENV TZ="Europe/Berlin"
RUN apt-get install -yq sudo time git-core build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev python3-distutils rsync unzip zlib1g-dev file wget python3.6 python3.10 libelf1 libelf-dev

RUN apt-get clean

RUN useradd -m openwrt &&\
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt
WORKDIR /home/openwrt

#ENV OPENWRT_VERSION=22.03.4
ENV OPENWRT_VERSION=23.05.0
RUN wget -O - https://github.com/openwrt/openwrt/archive/v${OPENWRT_VERSION}.tar.gz | \
  tar --strip=1 -xzvf -

#RUN make dirclean
COPY --chown=openwrt:openwrt config .config
COPY --chown=openwrt:openwrt feeds.conf feeds.conf

RUN scripts/feeds update -a
RUN scripts/feeds install -a

RUN make defconfig

ENV PACKAGES="kmod-leds-gpio kmod-crypto-hw-ccp kmod-sp5100-tco amd64-microcode flashrom irqbalance"

RUN $(/usr/bin/env python3)
RUN ls -al /usr/bin | grep python
RUN ls -al /home/openwrt/staging_dir/host/bin/
#RUN rm  /home/openwrt/staging_dir/host/bin/python3 
#RUN ln -s /usr/bin/python3 /home/openwrt/staging_dir/host/bin/python3 
USER root
