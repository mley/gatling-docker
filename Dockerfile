FROM 		alpine:latest
MAINTAINER	mley https://github.com/mley/gatling-docker
LABEL		Description="fefe's gatling httpd"

RUN 		apk add --no-cache make gcc cvs zlib openssl zlib-dev libc-dev openssl-dev \
			&& cd /tmp \
			&& cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co dietlibc \
			&& cd dietlibc \
			&& make \
			&& install bin-x86_64/diet /usr/local/bin \
			&& cd /tmp \
			&& cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
			&& cd libowfat \
			&& diet make \
			&& make install \
			&& cd /tmp \
			&& cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co gatling \
			&& cd gatling \
			&& diet make gatling \
			&& mv gatling / \
			&& cd / \
			&& apk del make gcc cvs zlib-dev libc-dev openssl-dev \
			&& rm -rf /tmp/*


# don't start FTP and SMB server by default
ENV			GATLING_OPTS="-F -S"

EXPOSE		80

ENTRYPOINT	/gatling ${GATLING_OPTS}


