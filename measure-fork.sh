#!/bin/bash

EXECUTABLE="forksum"

if [[ ! -e ${EXECUTABLE} ]] ; then
	gcc -O -o $EXECUTABLE "./"$EXECUTABLE.c -lm
fi
TIMEFORMAT=%R
{ time ./${EXECUTABLE} 1 5000 > /dev/null ; } 2>&1
