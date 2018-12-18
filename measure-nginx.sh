#!/bin/bash

x="$(wrk -t1 -c3 -d20s $1 | grep Transfer)"

if echo "$x" | grep -q GB; then
    t="$(echo ${x} | sed -Ee 's/Transfer\/sec:\s+(.*)GB/\1/')"
    f=0.5
    awk "BEGIN {print $f/$t}"
elif echo "$x" | grep -q MB; then
    t="$(echo ${x} | sed -Ee 's/Transfer\/sec:\s+(.*)MB/\1/')"
    f=512
    awk "BEGIN {print $f/$t}"
fi
