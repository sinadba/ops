#!/bin/bash

if which svn &> /dev/null; then
	if [ ! -d "/tmp/ops-$USER" ]; then
		svn checkout https://github.com/gongice/ops/trunk "/tmp/ops-$USER"
		echo 'export PATH="$PATH:/tmp/ops-$USER/bin"' >> ~/.bash_profile
	else
		cd /tmp/ops-$USER
		svn up
	fi
fi

source ~/.bash_profile
