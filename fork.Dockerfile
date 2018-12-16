FROM debian:stable

RUN apt-get update
RUN apt-get install -y gcc

COPY measure-fork.sh measure-fork.sh
COPY /src/forksum.c /src/forksum.c

CMD ["./measure-fork.sh"]