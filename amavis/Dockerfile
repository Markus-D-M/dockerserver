FROM alpine:3.19

RUN apk add amavis~=2.13 spamassassin~=3.4 razor~=2.85 py3-pip~=23.3 clamav~=1.2 rsyslog~=8.2310 7zip~=23.01; \
    pip3 install --break-system-packages pyzor; \
    sed -i 's/\.iteritems/\.items/' /usr/lib/python3.*/site-packages/pyzor/client.py; \
    sed -i 's/\.iteritems/\.items/' /usr/bin/pyzor; \
    sed -i 's/ xrange(/ range(/' /usr/lib/python3.*/site-packages/pyzor/digest.py;


COPY amavisd.conf /etc/amavisd.conf
RUN chmod 744 /etc/amavisd.conf

RUN mkdir /run/clamav; chown clamav:clamav /run/clamav

COPY spamassassing.conf /usr/share/spamassassin/local.cf

RUN mkdir /etc/mail/razor; \
    razor-admin -home=/etc/mail/razor -register; \
    razor-admin -home=/etc/mail/razor -create; \
    razor-admin -home=/etc/mail/razor -discover

COPY rsyslog.conf /etc/rsyslog.conf
COPY clamd.conf /etc/clamav/clamd.conf
COPY freshclam.conf /etc/clamav/freshclam.conf


COPY entrypoint.sh /run/entrypoint.sh
RUN chmod 755 /run/entrypoint.sh


ENTRYPOINT ["/run/entrypoint.sh"]
