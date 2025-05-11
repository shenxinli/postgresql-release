#!/usr/bin/env bash
set -e

VERSION="$1"     # e.g., 10, 12, 14, 16
ARCH="$2"        # e.g., amd64 or arm64

# Map short version to full version used in EDB URLs
case "$VERSION" in
  10) FULL="10.23-1" ;;
  11) FULL="11.6-1"  ;;
  12) FULL="12.22-1" ;;
  14) FULL="14.18-1" ;;
  16) FULL="16.9-1"  ;;
  *)
    echo "Unsupported PostgreSQL version: $VERSION"
    exit 1
    ;;
esac

# Handle architecture mapping
if [[ "$ARCH" == "amd64" ]]; then
  PLATFORM="linux-x64-binaries"
  FILENAME="postgresql-${FULL}-linux-x64-binaries.tar.gz"
  URL="https://get.enterprisedb.com/postgresql/${FILENAME}"

  mkdir -p postgresql-linux-amd64
  echo "Downloading $FILENAME from $URL"
  curl -fSL "$URL" -o "postgresql-linux-amd64/${FILENAME}"
  echo "Download completed: postgresql-linux-amd64/${FILENAME}"

elif [[ "$ARCH" == "arm64" ]]; then
  echo "Building PostgreSQL $VERSION from source for linux/arm64..."

  # Install dependencies
  sudo apt-get update
  sudo apt-get install -y build-essential gcc-aarch64-linux-gnu libreadline-dev zlib1g-dev flex bison wget tar

  # Download source
  wget https://ftp.postgresql.org/pub/source/v${FULL}/postgresql-${FULL}.tar.gz
  tar -xzf postgresql-${FULL}.tar.gz
  mv postgresql-${FULL} postgresql-${VERSION} && cd postgresql-${VERSION}

  OUTPUT_DIR=$(pwd)/output
  mkdir -p "$OUTPUT_DIR"
  CC=aarch64-linux-gnu-gcc ./configure --prefix=${OUTPUT_DIR} --enable-debug --with-openssl --without-readline --without-zlib
  make -j$(nproc)
  make install

  # Package the result
  ls -l ${OUTPUT_DIR}
  echo "compress build: postgresql-${VERSION}-linux-${ARCH}.tar.gz in ${OUTPUT_DIR}"
  tar -czf postgresql-${VERSION}-linux-${ARCH}.tar.gz ${OUTPUT_DIR}
  echo "Build and packaging complete: postgresql-${VERSION}-linux-${ARCH}.tar.gz"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi
