FROM skalenetwork/schain:3.17.0-develop.31
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true
# ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y dialog apt-utils psmisc git
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y nodejs
RUN apt update && apt install build-essential && npm install -g node-gyp
RUN node --version
RUN npm --version
RUN rm -rf /root/tmp
RUN rm -rf ~/tmp/*
RUN mkdir -p /root/.npm/_logs || true
RUN mkdir -p /root/.cache/node-gyp/ || true
RUN chown -R 65534:1000 "/root/.npm" || true
RUN npm cache clean --force
RUN npm -g config set user root
RUN npm install --quiet --no-progress --unsafe-perm -g yarn@1.22.4
RUN yarn --version
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update
RUN npm install --quiet --no-progress --unsafe-perm -g truffle@5.0.12

COPY IMA /IMA
COPY skaleManagerSample.json /skaleManagerSample.json
RUN cd /IMA && yarn install

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
EXPOSE 15000 15010 15020 15030 15040 15050
CMD []
ENTRYPOINT ["bash", "/dev_dir/inner_run.sh"]
