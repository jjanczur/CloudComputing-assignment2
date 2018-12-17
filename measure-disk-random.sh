#!/usr/bin/env bash
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test \
    --bs=1M --iodepth=64 --size=4024M --readwrite=randwrite \
    | grep --ignore-case IOPS \
    | sed -r "s/^.*IOPS=([^ ,]*).*$/\1/I"
