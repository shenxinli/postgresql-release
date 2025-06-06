#!/bin/bash

VERSION=$1
ARCH=$2

case "$VERSION" in
  10) FULL="10.23" ;;
  12) FULL="12.22" ;;
  14) FULL="14.18" ;;
  16) FULL="16.9" ;;
  *)
    echo "Unsupported PostgreSQL version: $VERSION"
    exit 1
    ;;
esac

sudo apt-get update
sudo apt-get install -y build-essential libreadline-dev zlib1g-dev

# 下载 PostgreSQL 源代码
wget https://ftp.postgresql.org/pub/source/v${FULL}/postgresql-${FULL}.tar.gz

# 解压源代码
tar -xzf postgresql-${FULL}.tar.gz
mv postgresql-${FULL} postgresql-${VERSION} && cd postgresql-${VERSION}

OUTPUT_DIR=$(pwd)/output
mkdir -p "$OUTPUT_DIR"

# 根据架构选择交叉编译工具链和编译选项
if [[ "$ARCH" == "amd64" ]]; then
  ./configure --prefix=${OUTPUT_DIR} --enable-debug --with-openssl --without-readline --without-zlib
elif [[ "$ARCH" == "arm64" ]]; then
  # 安装必要的交叉编译工具
  sudo apt-get install -y gcc-aarch64-linux-gnu
  CC=aarch64-linux-gnu-gcc ./configure --prefix=${OUTPUT_DIR} --enable-debug --with-openssl --without-readline --without-zlib
fi

# 编译和安装 PostgreSQL
make -j$(nproc)
make install

# 打包结果
ls -l ${OUTPUT_DIR}
echo "compress build: postgresql-${VERSION}-linux-${ARCH}.tar.gz in ${OUTPUT_DIR}"
tar -czf postgresql-${VERSION}-linux-${ARCH}.tar.gz ${OUTPUT_DIR}
echo "build completed: postgresql-${VERSION}-linux-${ARCH}.tar.gz"