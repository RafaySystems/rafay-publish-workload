# Container image that runs your code
FROM ubuntu:18.04

RUN apt update && apt install -y python curl jq

RUN curl -o rctl-linux-amd64.tar.bz2  https://s3-us-west-2.amazonaws.com/rafay-prod-cli/publish/rctl-linux-amd64.tar.bz2
RUN tar -xf rctl-linux-amd64.tar.bz2
RUN chmod 0755 rctl
RUN mv rctl /usr/local/bin
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
