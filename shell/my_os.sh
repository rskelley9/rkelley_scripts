#!/bin/sh

case "$(uname -s)" in
    Linux*)     sys=Linux;;
    Darwin*)    sys=Mac;;
    CYGWIN*)    sys=Cygwin;;
    MINGW*)     sys=MinGw;;
    *)          sys="UNKNOWN:$(uname -s)"
esac
echo ${sys}