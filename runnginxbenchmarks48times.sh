#!/usr/bin/env bash

for I in $(seq 0 47); do
    echo "running benchmark #$I..."
    ./benchmark-nginx.sh $1
done