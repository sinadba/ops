#!/bin/bash

if which svn &> /dev/null; then
	if [ ! -d "/tmp/useful-scripts-$USER" ]; then
		svn checkout https://github.com/superhj1987/useful-scripts/trunk "/tmp/useful-scripts-$USER"
		echo 'export PATH="$PATH:/tmp/useful-scripts-$USER"' >> ~/.bash_profile
	else
		cd /tmp/useful-scripts-$USER
		svn up
	fi
fi

source ~/.bash_profile