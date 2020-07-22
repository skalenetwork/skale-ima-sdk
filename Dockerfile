FROM skalenetwork/schain:1.46-develop.39
RUN apt-get update && apt-get clean && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs=10.* --no-install-recommends
RUN npm install -g yarn@1.22.4
EXPOSE 15000 15010 15020 15030 15040 15050
CMD []
ENTRYPOINT ["bash", "/dev_dir/inner_run.sh"]
