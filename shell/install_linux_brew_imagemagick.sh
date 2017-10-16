#!/bin/sh

whatsmyos(){

  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
  esac
  echo ${machine}
}

if [ ! -f "`which brew`" ] ; then
  echo "installing linux brew"
  cd $HOME
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"

  # PATH="$HOME/.linuxbrew/bin:$PATH"
  # echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >>~/.bash_profile

  brew install hello
else
  brew update
fi

if brew ls --versions imagemagick > /dev/null; then

  echo "unlinking and reinstalling imagemagick"
  brew unlink imagemagick && brew install imagemagick@6 && brew link imagemagick@6 --force

else
  echo "reinstalling imagemagick"
  brew install imagemagick@6 && brew link imagemagick@6 --force
fi

if $whatsmyos | grep -q 'Linux'; then
  if brew ls --versions libmagickwand-dev > /dev/null; then
    echo "installing dependencies for imagemagick."
    sudo apt-get install libmagickwand-dev
  fi
fi


