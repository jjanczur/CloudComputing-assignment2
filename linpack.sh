#!/bin/bash 
EXECUTABLE="linpack"
if [[ ! -e ./${EXECUTABLE} ]] ; then
	gcc -O -o ./${EXECUTABLE} ./${EXECUTABLE}.c -lm
fi

if [[ "$SYSTEMROOT" = "C:\Windows" ]] ; then
	RESULT=$(./${EXECUTABLE}.exe | tail -1)
else
	RESULT=$(./${EXECUTABLE} | tail -1)
fi
echo "$RESULT"
#echo $(./${RESULT} 1 1000)