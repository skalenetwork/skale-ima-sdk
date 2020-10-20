FROM skalenetwork/schain:1.46-develop.72
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y psmisc
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN node --version
RUN npm --version
RUN npm install -g yarn@1.22.4
RUN npm install -g truffle@5.0.12
RUN npm install -g yarn
RUN yarn --version
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
EXPOSE 15000 15010 15020 15030 15040 15050
CMD []
ENTRYPOINT ["bash", "/dev_dir/inner_run.sh"]
