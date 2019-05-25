#! /bin/bash

set -o errexit
set -o nounset

if [[ -z ${QT_VER-} || -z ${TARGET-} ]]; then
  echo "Please define QT_VER and TARGET first"
  exit 1
fi
set -o xtrace


# Lint

find -name *.qml -exec /opt/${QT_VER}_${TARGET}_hosttools/bin/qmllint {} \;


# Build

mkdir build && pushd build
  /opt/${QT_VER}_${TARGET}_hosttools/bin/qmake ..
  make
  make install INSTALL_ROOT=$PWD/../installoc
popd


# Check deps

if [[ $TARGET == rpi1* ]]; then
  CROSS=/opt/rpi-toolchain/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
elif [[ $TARGET == rpi* ]]; then
  CROSS=/opt/linaro/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
fi
${CROSS-}objdump -p installoc/opt/pegasus-metadata-editor/pegasus-metaed | grep NEEDED | sort


# Create artifacts

mkdir dist && pushd dist
  DISTDIR=pegasus-metadata-editor
  mkdir $DISTDIR
  cp ../installoc/opt/pegasus-metadata-editor/pegasus-metaed ../README.md ../LICENSE.md $DISTDIR/
  zip -r pegasus-metadata-editor_$(git describe --always)_${TARGET}.zip $DISTDIR
  rm -rf $DISTDIR
popd
