FROM fpco/stack-build:lts-9.8 as build
RUN mkdir /opt/build
COPY app /opt/build/app
COPY blog.cabal /opt/build
COPY stack.yaml /opt/build
RUN cd /opt/build && stack build --system-ghc
RUN mkdir -p /opt/myapp
ARG BINARY_PATH
WORKDIR /opt/myapp
RUN apt-get update && apt-get install -y \
  ca-certificates \
  libgmp-dev
# NOTICE THIS LINE
RUN cp /opt/build/.stack-work/install/x86_64-linux/lts-9.8/8.0.2/bin/build-site /usr/bin
