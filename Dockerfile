FROM ghcr.io/linuxserver/code-server:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget vim curl git nano \
    gcc g++ build-essential make cmake pkg-config \
    openssl libssl-dev ca-certificates \
    python3 python3-pip python3-dev python3-venv \
    unzip zip bzip2 xz-utils tar gzip \
    htop tree jq sqlite3 libsqlite3-dev \
    autoconf automake libtool \
    libffi-dev libgmp-dev libsodium-dev \
    protobuf-compiler llvm clang lld \
    libudev-dev libusb-1.0-0-dev \
    software-properties-common apt-transport-https gnupg lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn pnpm

RUN echo '#!/bin/bash\n\
echo "=== Development Environment ==="\n\
echo "GCC: $(gcc --version | head -1)"\n\
echo "Python: $(python3 --version)"\n\
echo "Node.js: $(node --version)"\n\
echo "npm: $(npm --version)"\n\
echo "Rust: $(rustc --version)"\n\
echo "Cargo: $(cargo --version)"\n\
echo "CMake: $(cmake --version | head -1)"\n\
echo "Protobuf: $(protoc --version)"\n\
echo "=============================="\n\
' > /usr/local/bin/check-env && chmod +x /usr/local/bin/check-env

WORKDIR /config
EXPOSE 8443
ENTRYPOINT ["/init"]
