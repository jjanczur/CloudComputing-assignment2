FROM debian:stable

RUN apt-get update
RUN apt-get install -y gcc

COPY measure-fork.sh measure-fork.sh
COPY forksum.c forksum.c

CMD ["./measure-fork.sh"]