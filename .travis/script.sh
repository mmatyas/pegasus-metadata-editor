#! /bin/bash

set -o errexit
set -o nounset

if [[ -z ${QT_VER-} || -z ${TARGET-} ]]; then
  echo "Please define QT_VER and TARGET first"
  exit 1
fi
set -o xtrace


# Platform settings - Qt dir
if [[ $TARGET == macos* ]]; then
  QT_HOSTDIR=/usr/local/Qt-${QT_VER}
elif [[ $TARGET == x11* ]]; then
  QT_HOSTDIR=/opt/qt${QT_VER//./}_${TARGET}
else
  QT_HOSTDIR=/opt/qt${QT_VER//./}_${TARGET}_hosttools
fi
# Platform settings - Cross prefix
if [[ $TARGET == rpi1* ]]; then
  CROSS=/opt/rpi-toolchain/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
elif [[ $TARGET == rpi* ]]; then
  CROSS=/opt/linaro/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
fi
# Platform settings - install path
if [[ $TARGET == macos* ]]; then
  INSTALLED_FILE=usr/local/pegasus-metadata-editor/Pegasus\ Metadata\ Editor.app
  INSTALLED_BINARY=${INSTALLED_FILE}/Contents/MacOS/pegasus-metaed
else
  INSTALLED_FILE=opt/pegasus-metadata-editor/pegasus-metaed
  INSTALLED_BINARY=${INSTALLED_FILE}
fi


# Lint
find . -name *.qml -exec ${QT_HOSTDIR}/bin/qmllint {} \;


# Build
mkdir build && pushd build
  ${QT_HOSTDIR}/bin/qmake ..
  make
  make install INSTALL_ROOT=$PWD/../installoc
popd


# Check deps
${CROSS-}objdump -p "installoc/${INSTALLED_BINARY}" | grep NEEDED | sort


# Create artifacts
mkdir dist && pushd dist
  DISTDIR=pegasus-metadata-editor
  mkdir $DISTDIR
  cp -r "../installoc/${INSTALLED_FILE}" ../README.md ../LICENSE.md $DISTDIR/
  zip -r pegasus-metadata-editor_$(git describe --always)_${TARGET}.zip $DISTDIR
  rm -rf $DISTDIR
popd
