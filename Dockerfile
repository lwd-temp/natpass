FROM lwch/darwin-crosscompiler:11.3

ARG APT_MIRROR
ARG GO_VERSION
ARG GO_PROXY

ADD build.go /tmp/build.go

RUN if [ -n "$APT_MIRROR" ]; then sed -i "s|deb.debian.org|$APT_MIRROR|g" /etc/apt/sources.list; fi && \
   if [ -n "$APT_MIRROR" ]; then sed -i "s|security.debian.org|$APT_MIRROR|g" /etc/apt/sources.list; fi && \
   dpkg --add-architecture i386 && \
   dpkg --add-architecture amd64 && \
   apt-get update && apt-get upgrade -y && \
   apt-get install -y gcc libc6-dev && \
   apt-get install -y gcc-multilib && \
   apt-get install -y gcc-mingw-w64 && \
   apt-get install -y curl git && \
   apt-get update && \
   apt-get install -y libx11-dev:i386 && \
   apt-get install -y libx11-dev:amd64 && \
   apt-get clean && \
   curl -L https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz|tar -xz -C /usr/local && \
   cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPROXY=$GO_PROXY

RUN go build -o /bin/build build.go && \
   rm -fr /tmp/build.go

CMD /bin/build