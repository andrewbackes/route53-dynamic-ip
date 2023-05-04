FROM amazon/aws-cli
RUN yum update -y \
  && yum install -y bind-utils

ADD ./refresh-dns.sh /refresh-dns.sh
RUN chmod +755 /refresh-dns.sh
ENTRYPOINT ["/refresh-dns.sh"]