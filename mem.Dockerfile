FROM debian:stable

RUN apt-get update
RUN apt-get install -y gcc

COPY measure-mem.sh measure-mem.sh
COPY memsweep.sh memsweep.sh
COPY memsweep.c memsweep.c

CMD ["./measure-mem.sh"]