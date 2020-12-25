FROM skalenetwork/schain:3.2.2-develop.0
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=true
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y dialog apt-utils psmisc
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN node --version
RUN npm --version
RUN npm install -g yarn@1.22.4
RUN yarn --version
RUN chown -R 65534:0 "/root/.npm" || true
RUN npm install -g truffle@5.0.12
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
EXPOSE 15000 15010 15020 15030 15040 15050
CMD []
ENTRYPOINT ["bash", "/dev_dir/inner_run.sh"]
