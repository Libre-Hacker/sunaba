#!/bin/sh

set -e

srcdir=`dirname "$0"`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd "$srcdir"

autoreconf --force --verbose --install
cd "$ORIGDIR"

if test -z "$NOCONFIGURE"; then
    "$srcdir"/configure "$@"
fi

if [ ! -d ./bin ]; then
  mkdir -p ./bin;
fi

if [ ! -d ./bin/linux ]; then
  mkdir -p ./bin/linux;
fi

if [ ! -d ./binWin32 ]; then
  mkdir -p ./binWin32;
fi
