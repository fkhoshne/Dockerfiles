#!/bin/bash -e

IMAGE="xeon-ubuntu1804-analytics-ffmpeg2"
DIR=$(dirname $(readlink -f "$0"))

. "${DIR}/../../../../script/shell.sh"
