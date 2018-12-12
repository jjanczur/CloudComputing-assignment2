#!/bin/bash 
EXECUTABLE="linpack"
if [[ ! -e ./src/${EXECUTABLE} ]] ; then
	gcc -O -o ./src/${EXECUTABLE} ./src/${EXECUTABLE}.c -lm
fi

if [[ "$SYSTEMROOT" = "C:\Windows" ]] ; then
	RESULT=$(./src/${EXECUTABLE}.exe | tail -1)
else
	RESULT=$(./src/${EXECUTABLE} | tail -1)
fi
echo "$RESULT"
#echo $(./${RESULT} 1 1000)