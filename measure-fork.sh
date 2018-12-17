#!/bin/bash

EXECUTABLE="forksum"

if [[ ! -e ${EXECUTABLE} ]] ; then
	gcc -O -o $EXECUTABLE "src/"$EXECUTABLE.c -lm
fi

echo $(./${EXECUTABLE} 1 5000)
