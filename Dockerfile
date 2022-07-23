FROM alpine:3.13

RUN apk add --no-cache zlib openssl libstdc++ libpcap libgcc
RUN apk add --no-cache -t .build-deps \
  bsd-compat-headers \
  libmaxminddb-dev \
  linux-headers \
  openssl-dev \
  libpcap-dev \
  python3-dev \
  zlib-dev \
  binutils \
  fts-dev \
  cmake \
  clang \
  bison \
  bash \
  swig \
  perl \
  make \
  flex \
  git \
  g++ \
  fts \
  openssh

RUN echo "===> Cloning zeek..." \
  && cd /tmp \
  && git clone --recursive --branch=v4.1.1 "https://github.com/zeek/zeek.git"

RUN echo "===> Compiling zeek..." \
  && cd /tmp/zeek \
  && CC=clang ./configure \
      --prefix=/usr/local/zeek \
      --build-type=Debug \
      --disable-broker-tests \
      --disable-zeekctl \
      --disable-auxtools \
      --disable-python \
      --disable-archiver \
      --disable-btest \
      --disable-btest-pcaps \
      --disable-zkg \
  && make -j $(nproc) \
  && make install

  RUN echo "===> Installing zeek-hello package..." \
    && cd /tmp/test_zeek_hello \
    && git clone https://github.com/YaroslavYakovlev/test_ussc.git \
    && cd test_zeek_hello \
    && make -j $(nproc) \
    && make install \
    && zeek hello.zeek

#   RUN echo "===> Installing zeek-llc package..." \
#     && cd /tmp/zeek/auxil/ \
#     && git clone https://github.com/zeek/zeek-llc.git \
#     && cd zeek-llc \
#     && CC=clang ./configure --zeek-dist=/tmp/zeek \
#     && make -j $(nproc) \
#     && make install \
#     && /usr/local/zeek/bin/zeek -N Zeek::LLC