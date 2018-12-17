#!/usr/bin/env bash

if [ "$PROVIDER" = "" ]; then
    PROVIDER=native
fi

for BENCHMARK in cpu mem disk-random fork; do
    RESULT_FILE=${PROVIDER}-${BENCHMARK}.csv
    BENCHMARK_SCRIPT=./measure-${BENCHMARK}.sh

    CURRENT_TIME=$(date +%s)
    CURRENT_TIME_NICE=$(date)

    if [[ ! -e ${RESULT_FILE} ]]; then
        echo "[$CURRENT_TIME_NICE] creating $RESULT_FILE"
        echo "time,value" > ${RESULT_FILE}
    fi

    RESULT=$(${BENCHMARK_SCRIPT})

    echo "[$CURRENT_TIME_NICE] $BENCHMARK benchmark result $RESULT"
    echo "$CURRENT_TIME,$RESULT" >> ${RESULT_FILE}
done