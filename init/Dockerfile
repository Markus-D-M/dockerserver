FROM alpine:3.19

COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

ENTRYPOINT ["/bin/ash", "-c", "/app/init.sh"]
