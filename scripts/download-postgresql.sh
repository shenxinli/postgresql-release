#!/usr/bin/env bash
set -e

VERSION="$1"
OS="$2"
ARCH="$3"

# 映射 EnterpriseDB 所需的文件名形式
case "$OS" in
  linux)
    OS_NAME="linux"
    ;;
  windows)
    OS_NAME="windows"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

case "$ARCH" in
  amd64)
    ARCH_NAME="x64"
    ;;
  arm64)
    if [[ "$OS" == "linux" ]]; then
      echo "ARM64 builds from source, skipping download."
      exit 0
    else
      echo "Unsupported Windows arch: arm64"
      exit 1
    fi
    ;;
  *)
    echo "Unsupported arch: $ARCH"
    exit 1
    ;;
esac

EXT="tar.gz"
[[ "$OS" == "windows" ]] && EXT="zip"

FILENAME="postgresql-${VERSION}-${OS_NAME}-${ARCH_NAME}-binaries.${EXT}"
URL="https://get.enterprisedb.com/postgresql/${FILENAME}"

echo "Downloading from $URL..."
curl -fSL "$URL" -o "package.${EXT}"
mkdir -p postgresql
cd postgresql
if [[ "$EXT" == "zip" ]]; then
  unzip ../package.${EXT}
else
  tar -xf ../package.${EXT} --strip-components=1
fi
