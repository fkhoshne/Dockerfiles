#!/bin/bash -e

IMAGE="vca2-centos75-media-nginx"
VERSION="19.10"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/build.sh"
