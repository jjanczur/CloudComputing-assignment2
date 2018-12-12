#!/usr/bin/env bash
TIMEFORMAT=%R
time fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test \
                          --bs=1M --iodepth=64 --size=1024M --readwrite=randwrite >& /dev/null