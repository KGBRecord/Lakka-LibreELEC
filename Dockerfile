# Dockerfile for Lakka-LibreELEC Build Environment
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install core build dependencies in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Core build tools
    build-essential \
    gcc \
    g++ \
    libc6-dev \
    libc-dev-bin \
    linux-libc-dev \
    make \
    cmake \
    autoconf \
    automake \
    libtool \
    pkg-config \
    # Version control & network
    git \
    wget \
    curl \
    # Archive & compression
    tar \
    gzip \
    bzip2 \
    xz-utils \
    zip \
    unzip \
    zstd \
    lzop \
    # Text processing
    sed \
    gawk \
    patch \
    patchutils \
    # Development essentials
    libncurses5-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libxml2-dev \
    libxslt1-dev \
    # Python (essential for build system)
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    # Perl modules (essential for build)
    perl \
    libjson-perl \
    libparse-yapp-perl \
    libxml-parser-perl \
    # Java (basic)
    openjdk-11-jdk \
    # Build utilities
    bc \
    bison \
    flex \
    gperf \
    file \
    cpio \
    rdfind \
    # XML/XSLT processing
    xsltproc \
    # Font tools
    xfonts-utils \
    # Additional tools
    help2man \
    texinfo \
    rsync \
    # Security & certs
    ca-certificates \
    gnupg \
    # User management
    sudo \
    # Basic editors
    vim \
    nano \
    less \
    htop \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Fix libc symlinks for host-gcc compilation
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        ln -sf /lib/x86_64-linux-gnu/libc.so.6 /usr/lib/libc.so.6 || true; \
        ln -sf /usr/lib/x86_64-linux-gnu/libc_nonshared.a /usr/lib/libc_nonshared.a || true; \
    elif [ "$ARCH" = "arm64" ]; then \
        ln -sf /lib/aarch64-linux-gnu/libc.so.6 /usr/lib/libc.so.6 || true; \
        ln -sf /usr/lib/aarch64-linux-gnu/libc_nonshared.a /usr/lib/libc_nonshared.a || true; \
    fi

# Create build user and configure sudo
RUN groupadd -g 1000 builder && \
    useradd -u 1000 -g 1000 -m -s /bin/bash builder && \
    echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo 'Defaults !requiretty' >> /etc/sudoers && \
    usermod -aG sudo builder

# Set Java environment variables (detect architecture)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then \
        echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64" >> /etc/environment; \
    else \
        echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment; \
    fi

# Copy and set up entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Create working directory and copy files
WORKDIR /lakka-libreelec
COPY . .

# Fix permissions for builder user
RUN chown -R builder:builder /lakka-libreelec && \
    chmod -R u+rwX /lakka-libreelec

# Switch to builder user
USER builder

# Set up Rust for builder user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/builder/.cargo/bin:${PATH}"

# Set default shell
SHELL ["/bin/bash", "-c"]

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Default command
CMD ["/bin/bash"]