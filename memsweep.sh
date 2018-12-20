#!/bin/bash
EXECUTABLE="memsweep"
if [[ ! -e ./${EXECUTABLE} ]] ; then
	#echo "Compiling..." 1>&2
	gcc -O -o ./$EXECUTABLE "./"$EXECUTABLE.c -lm
fi

if [[ "$SYSTEMROOT" = "C:\Windows" ]] ; then
	RESULT=$(./${EXECUTABLE}.exe | tail -1)
else
	RESULT=$(./${EXECUTABLE} | tail -1)
fi
echo "$RESULT"