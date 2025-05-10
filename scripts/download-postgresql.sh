#!/usr/bin/env bash
set -e

VERSION="$1"
OS="$2"
ARCH="$3"

# Normalize
PLATFORM=""
EXT="tar.gz"

if [[ "$OS" == "windows" ]]; then
  EXT="zip"
  case "$ARCH" in
    x64) PLATFORM="windows-x64-binaries" ;;
    *) echo "Unsupported Windows arch: $ARCH" && exit 1 ;;
  esac
else
  case "$OS-$ARCH" in
    linux-amd64) PLATFORM="linux-x64-binaries" ;;
    linux-arm64) PLATFORM="linux-arm64-binaries" ;;
    *) echo "Unsupported platform: $OS-$ARCH" && exit 1 ;;
  esac
fi

URL="https://get.enterprisedb.com/postgresql/postgresql-${VERSION}-${PLATFORM}.${EXT}"

echo "Downloading from $URL"

mkdir -p postgresql
cd postgresql

curl -LO "$URL"

if [[ "$EXT" == "zip" ]]; then
  unzip "postgresql-${VERSION}-${PLATFORM}.${EXT}"
else
  tar -xf "postgresql-${VERSION}-${PLATFORM}.${EXT}"
fi
