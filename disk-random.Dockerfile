FROM debian:stable

RUN apt-get update
RUN apt-get install -y fio

COPY measure-disk-random.sh measure-disk-random.sh

CMD ["./measure-disk-random.sh"]