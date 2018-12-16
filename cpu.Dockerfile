FROM debian:stable

RUN apt-get update
RUN apt-get install -y gcc

COPY linpack.sh linpack.sh
COPY /src/linpack.c /src/linpack.c
COPY measure-cpu.sh measure-cpu.sh

CMD ["./measure-cpu.sh"]