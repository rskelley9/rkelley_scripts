#!/bin/sh

if [ ! -f "`which brew`" ] ; then
  echo "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

if brew ls --versions imagemagick > /dev/null; then
  echo "installing imagemagick"
  brew unlink imagemagick && brew install imagemagick@6 && brew link imagemagick@6 --force
else
  brew install imagemagick@6 && brew link imagemagick@6 --force
fi

echo "installing dependencies for imagemagick."
sudo apt-get install libmagickwand-dev
