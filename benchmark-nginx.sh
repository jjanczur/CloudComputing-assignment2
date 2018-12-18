#!/usr/bin/env bash

if [ "$PROVIDER" = "" ]; then
    PROVIDER=native
fi

for BENCHMARK in nginx; do
    RESULT_FILE=${PROVIDER}-${BENCHMARK}.csv
	DOKCERFILE=${BENCHMARK}.Dockerfile
	BENCHMARK_SCRIPT=./measure-${BENCHMARK}.sh

    CURRENT_TIME=$(date +%s)
    CURRENT_TIME_NICE=$(date)

    if [[ ! -e ${RESULT_FILE} ]]; then
        echo "[$CURRENT_TIME_NICE] creating $RESULT_FILE"
        echo "time,value" > ${RESULT_FILE}
    fi

	if [ "$PROVIDER" = "docker" ]; then
		docker build -f ${DOKCERFILE} -t ${BENCHMARK} .
		RESULT=$(docker run ${BENCHMARK})
	else
		RESULT=$(${BENCHMARK_SCRIPT} $1)
	fi
    

    echo "[$CURRENT_TIME_NICE] $BENCHMARK benchmark result $RESULT"
    echo "$CURRENT_TIME,$RESULT" >> ${RESULT_FILE}
done