FROM 		debian:jessie
MAINTAINER	mley https://github.com/mley/gatling-docker
LABEL		Description="fefe's gatling httpd"

# install dependencies
RUN 		apt-get update && apt-get install -y  \
				make gcc-4.9 cvs \
				zlib1g zlib1g-dev \
				openssl libssl-dev 

RUN		 	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 100 

# build and install dietlibc
RUN			cd \
			&& cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co dietlibc \
			&& cd dietlibc \
			&& make \
			&& install bin-x86_64/diet /usr/local/bin 
			
# build and install libowfat
RUN			cd \
			&& cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat \
			&& cd libowfat \
			&& diet make \
			&& make install 

# build and install gatling
RUN			cd \
			&& cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co gatling \
			&& cd gatling \
			&& diet make gatling \
			&& make install 

# clean up
RUN			cd \
			&& rm -rf dietlibc libowfat gatling \
			&& apt-get -y remove --purge make gcc-4.9 cvs zlib1g-dev libssl-dev \
			&& apt-get -y autoremove \
			&& apt-get clean \
			&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# don't start FTP and SMB server by default
ENV			GATLING_OPTS="-F -S"

EXPOSE		80

CMD			/opt/diet/bin/gatling ${GATLING_OPTS}

