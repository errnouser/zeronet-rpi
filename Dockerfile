FROM resin/raspberry-pi-alpine:latest

ENV HOME /root

RUN apk --update upgrade \
  && apk add tor --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/community/ \
  && apk --no-cache --no-progress add musl-dev bash gcc python python-dev py2-pip \
  && pip install gevent msgpack-python \
  && apk del musl-dev gcc python-dev py2-pip \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* \
  && mkdir -p /root/data \
  && echo "SOCKSPort 9050" >> /etc/tor/torrc \
  && echo "ControlPort 9051" >> /etc/tor/torrc \
  && echo "DataDirectory /root/data/tor" >> /etc/tor/torrc \
  && echo "DirReqStatistics 0" >> /etc/tor/torrc \
  && echo "GeoIPFile /root/data/tor/geoip" >> /etc/tor/torrc \
  && echo "GeoIPv6File /root/data/tor/geoip6" >> /etc/tor/torrc \
  && echo "CookieAuthentication 1" >> /etc/tor/torrc \
  && git clone https://github.com/HelloZeroNet/ZeroNet.git

VOLUME /root/data

WORKDIR /root

ENV ZERONET_UI_PORT=43110 ZERONET_HOME=1HeLLo4uzjaLetFx6NH3PMwFP3qbRbTf3D DISABLE_TOR=false

CMD ( ${DISABLE_TOR} || tor & ) && python /ZeroNet/zeronet.py --tor $( ! ${DISABLE_TOR} && echo "always" || echo "disable" ) --ui_ip "*"  --ui_port ${ZERONET_UI_PORT} --data_dir /root/data --homepage ${ZERONET_HOME}

EXPOSE 43110 15441
