#!/bin/bash

EXECUTABLE="forksum"

if [[ ! -e ${EXECUTABLE} ]] ; then
	echo "Compiling..." 1>&2
	gcc -O -o $EXECUTABLE "src/"$EXECUTABLE.c -lm
fi

echo "Running..." 1>&2

echo $(./${EXECUTABLE} $1 $2 $3)
