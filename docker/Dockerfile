FROM ailispaw/ubuntu-essential:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update \
 && apt-get -q -y install --no-install-recommends build-essential ca-certificates git sudo

RUN useradd -m -d /home/p4 -s /bin/bash p4 \
 && echo "p4:p4" | chpasswd \
 && echo "p4 ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99_p4 \
 && chmod 440 /etc/sudoers.d/99_p4

ENV BMV2_COMMIT="7e25eeb19d01eee1a8e982dc7ee90ee438c10a05" \
    PI_COMMIT="219b3d67299ec09b49f433d7341049256ab5f512" \
    P4C_COMMIT="48a57a6ae4f96961b74bd13f6bdeac5add7bb815" \
    PROTOBUF_COMMIT="v3.2.0" \
    GRPC_COMMIT="v1.3.2"

USER p4

WORKDIR /home/p4

RUN git clone git://github.com/mininet/mininet.git \
 && cd mininet \
 && sudo ./util/install.sh -nwv \
 && cd .. && sudo rm -rf mininet

RUN sudo apt-get -q -y install --no-install-recommends curl unzip automake libtool \
 && git clone https://github.com/google/protobuf.git \
 && cd protobuf \
 && git checkout ${PROTOBUF_COMMIT} \
 && export CFLAGS="-Os" \
 && export CXXFLAGS="-Os" \
 && export LDFLAGS="-Wl,-s" \
 && ./autogen.sh \
 && ./configure --prefix=/usr \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && sudo make install \
 && sudo ldconfig \
 && unset CFLAGS CXXFLAGS LDFLAGS \
 && cd python \
 && sudo python setup.py install \
 && cd ../.. && sudo rm -rf protobuf

RUN sudo apt-get -q -y install --no-install-recommends libssl-dev \
 && git clone https://github.com/grpc/grpc.git \
 && cd grpc \
 && git checkout ${GRPC_COMMIT} \
 && git submodule update --init --recursive \
 && export LDFLAGS="-Wl,-s" \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && sudo make install \
 && sudo ldconfig \
 && unset LDFLAGS \
 && cd .. \
 && sudo apt-get -q -y install --no-install-recommends python-pip \
 && sudo pip install grpcio \
 && sudo rm -rf grpc

RUN sudo apt-get -q -y install --no-install-recommends \
      cmake libjudy-dev libreadline6-dev python-dev \
      bison flex libboost-all-dev libevent-dev pkg-config \
 && git clone https://github.com/p4lang/behavioral-model.git \
 && cd behavioral-model \
 && git checkout ${BMV2_COMMIT} \
 && tmpdir=$(mktemp -d -p .) \
 && cd ${tmpdir} \
 && bash ../travis/install-thrift.sh \
 && bash ../travis/install-nanomsg.sh \
 && sudo ldconfig \
 && bash ../travis/install-nnpy.sh \
 && cd .. \
 && sudo rm -rf ${tmpdir} \
 && cd .. \
    \
 && sudo apt-get -q -y install --no-install-recommends libgmp-dev libpcap-dev \
 && git clone https://github.com/p4lang/PI.git \
 && cd PI \
 && git checkout ${PI_COMMIT} \
 && git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure --with-proto \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && sudo make install \
 && sudo ldconfig \
 && cd .. && sudo rm -rf PI \
    \
 && cd behavioral-model \
 && ./autogen.sh \
 && ./configure --enable-debugger --with-pi \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && sudo make install \
 && sudo ldconfig \
 && cd targets/simple_switch_grpc \
 && ./autogen.sh \
 && ./configure --with-thrift \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && sudo make install \
 && sudo ldconfig \
 && cd ../../.. && sudo rm -rf behavioral-model

RUN sudo apt-get -q -y install --no-install-recommends \
      libgc-dev libfl-dev python-scapy python-ipaddr tcpdump \
 && git clone https://github.com/p4lang/p4c \
 && cd p4c \
 && git checkout ${P4C_COMMIT} \
 && git submodule update --init --recursive \
 && mkdir -p build \
 && cd build \
 && cmake .. \
 && make -j$(getconf _NPROCESSORS_ONLN) \
 && make -j$(getconf _NPROCESSORS_ONLN) check \
 && sudo make install \
 && sudo ldconfig \
 && cd ../.. && sudo rm -rf p4c

RUN sudo pip install crcmod psutil \
 && sudo apt-get -q -y install --no-install-recommends net-tools iputils-ping \
 && git clone https://github.com/p4lang/tutorials.git \
