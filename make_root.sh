#!/bin/bash

export ALEYA_ROOT=$(pwd)/root

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

if [ -z "$ALEYA_ROOT" ]; then
    echo "ALEYA_ROOT is not set. Please set it in your environment."
    exit 1
fi

if [ -d "$ALEYA_ROOT" ]; then
    echo "ALEYA_ROOT already exists. Please remove it before running this script."
    exit 1
fi

mkdir $ALEYA_ROOT
mkdir $ALEYA_ROOT/home

chown root:root $ALEYA_ROOT
chmod 755 $ALEYA_ROOT
