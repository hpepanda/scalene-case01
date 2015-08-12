#! /bin/bash

CUR_PATH=$(pwd)
cd /var/cache/apt/archives
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
cd $CUR_PATH