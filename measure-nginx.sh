#!/bin/bash

t="$(wrk -t1 -c3 -d10s http://127.0.0.1:80/big-file.txt | grep Transfer | sed -e 's/Transfer\/sec:      \(.*\)GB/\1/')"
f=0.5     
         
awk "BEGIN {print $f/$t}"