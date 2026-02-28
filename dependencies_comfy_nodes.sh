#!/bin/bash

for d in /data/custom_nodes/* ; do
    export path=$d/requirements.txt
	if [ -f $path ]; then
		pip install -r $path
	fi
	echo 
done