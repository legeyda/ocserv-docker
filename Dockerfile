FROM ubuntu:24.04 AS build

ARG OCSERV_VERSION=1.3.0
ARG WORKDIR=/tmp/ocserv
WORKDIR $WORKDIR

# 	rm -rf /var/lib/apt/lists/*; \

RUN set -eux; \
	apt-get --yes update; \
	apt-get --yes install curl build-essential ipcalc-ng libgnutls28-dev libev-dev autoconf automake pkg-config protobuf-c-compiler libreadline-dev gperf; \
	curl --output src.tar.gz https://gitlab.com/openconnect/ocserv/-/archive/$OCSERV_VERSION/ocserv-$OCSERV_VERSION.tar.gz; \
	tar xzf src.tar.gz; \
	cd ocserv-$OCSERV_VERSION; \
	autoreconf -fvi; \
	./configure; \
	make;

COPY entry-point.sh ./entry-point.sh.in

RUN set -eux; \
	shelduck_installer=$(curl -fsS https://raw.githubusercontent.com/legeyda/shelduck/refs/heads/main/install.sh); \
	eval "$shelduck_installer"; \
	/opt/bin/shelduck resolve file://entry-point.sh.in > ./entry-point.sh







FROM ubuntu:24.04
ARG OCSERV_VERSION=1.3.0
ARG WORKDIR=/tmp/ocserv
WORKDIR $WORKDIR

RUN mkdir -p /opt/bin /etc/ocserv
COPY --from=build $WORKDIR/ocserv-$OCSERV_VERSION/doc/sample.config /etc/ocserv/ocserv.config
COPY --from=build $WORKDIR/ocserv-$OCSERV_VERSION/src/ocserv      /opt/bin
COPY --from=build $WORKDIR/ocserv-$OCSERV_VERSION/src/occtl       /opt/bin
COPY --from=build $WORKDIR/ocserv-$OCSERV_VERSION/src/ocpasswd    /opt/bin
COPY --from=build $WORKDIR/entry-point.sh /opt/bin

ENV PATH="$PATH:/opt/bin"
ENTRYPOINT ["/opt/bin/entry-point.sh"]
CMD ["occtl", "--foreground"]