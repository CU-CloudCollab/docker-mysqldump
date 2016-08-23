FROM dtr.cucloud.net/cs/awscli

RUN \
  apt-get update && \
  apt-get install -y \
    mysql-client \
    && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY dump.sh /opt/dump.sh
RUN \
  chmod +x /opt/dump.sh

CMD ["/opt/dump.sh"]
