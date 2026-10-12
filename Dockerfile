FROM --platform=amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install all build dependencies required by build.sh
# See: check_host_dependencies() in build.sh for the complete list
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    libarchive-tools \
    ca-certificates \
    coreutils \
    cpio \
    curl \
    dosfstools \
    dropbear-bin \
    fdisk \
    findutils \
    git \
    gzip \
    grub-common \
    grub2-common \
    grub-efi-amd64-bin \
    grub-efi-ia32-bin \
    grub-pc-bin \
    openssl \
    rsync \
    udev \
    util-linux \
    wget \
    xorriso \
    unzip \
    mount \
    jq \
    openssh-client \
    file \
    tar \
    file \
    xz-utils && \
  rm -rf /var/lib/apt/lists/*
  

# Install Go from the official Go distribution
ARG GO_VERSION=1.25.3

RUN ARCH="$(dpkg --print-architecture)" && \
    case "$ARCH" in \
      amd64) GO_ARCH=amd64 ;; \
      arm64) GO_ARCH=arm64 ;; \
      *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;; \
    esac && \
    curl -fsSLo /tmp/go.tar.gz \
      "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /tmp
COPY . .

CMD ./build.sh --ssh --net-addressing=static --ip-addr=192.168.1.9 --netmask=255.255.255.0 --gateway=192.168.1.1 --dns=192.168.1.1 --expert-password='test'
