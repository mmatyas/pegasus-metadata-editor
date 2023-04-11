#! /bin/bash

set -o errexit
set -o nounset

if [[ -z ${QT_VER-} || -z ${TARGET-} ]]; then
  echo "Please define QT_VER and TARGET first"
  exit 1
fi
set -o xtrace


# Native dependencies

if [[ $TARGET = x11* ]]; then
  sudo apt-add-repository -y ppa:brightbox/ruby-ng
  sudo apt-get -qq update
  sudo apt-get install -y \
    libgl1-mesa-dev \
    libudev-dev \
    libx11-xcb-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-sync-dev \
    libxcb-util-dev \
    libxcb-xfixes0-dev \
    libxcb-xinerama0-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libzstd-dev
fi

if [[ $TARGET = rpi* ]]; then
  sudo apt-get -qq update
  sudo apt-get install -y \
    g++-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf
fi


# Toolchains

TOOLS_URL=https://github.com/mmatyas/pegasus-frontend/releases/download/alpha1

pushd /tmp
  wget ${TOOLS_URL}/qt${QT_VER//./}_${TARGET}.tar.xz

  if [[ $TARGET = rpi* ]]; then
    if [[ $TARGET = rpi4* ]]; then
      wget ${TOOLS_URL}/rpi-sysroot_buster_mesa.tar.xz
    else
      wget ${TOOLS_URL}/rpi-sysroot_buster_brcm.tar.xz
    fi
  fi

  if [[ $TARGET == macos* ]]; then OUTDIR=/usr/local; else OUTDIR=/opt; fi
  for f in *.tar.xz; do sudo tar xJf ${f} -C ${OUTDIR}/; done
popd
