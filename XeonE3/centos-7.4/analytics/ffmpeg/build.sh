#!/bin/bash -e

IMAGE="xeone3-centos74-analytics-ffmpeg"
VERSION="19.10"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
