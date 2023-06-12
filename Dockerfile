FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y git build-essential sudo

RUN mkdir -p /workdir/qsym

WORKDIR /workdir/qsym
COPY . /workdir/qsym

RUN ./setup.sh
RUN pip install .

RUN chmod +x enable_sqsym.sh
RUN ./enable_sqsym.sh
