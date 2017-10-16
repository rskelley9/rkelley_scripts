#!/bin/sh

if [ -f "`find . -name .DS_Store`" ] ; then
  if [ ! -f "`git rev-parse --is-inside-work-tree`" ] ; then
    echo "no git repository found"

    while true; do
      read -p "Do you wish to initialize git repository in this folder $(echo $(pwd))?" yn

      case $yn in
          [Yy]* ) git init; break;;
          [Nn]* ) exit;;
          * ) echo "Please answer yes or no.";;
      esac
    done
  fi

  if[ ! -f "`find . -name .gitignore`" ] ; then
    touch $(pwd)/.gitignore && echo "created .gitignore"
  fi

  echo "removing .DS_Store"
  find . -name .DS_Store -print0 | xargs -0 git rm

  git config --global core.excludesfile "$(pwd)/.gitignore"
  echo .DS_Store >> ~/.gitignore && echo ".DS_Store added to .gitignore"

else
  echo ".DS_Store not found."
fi