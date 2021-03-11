FROM openjdk:8-alpine

ENV APP_NAME="cas-management"

ENV BUILD_DEPS="gettext" \
    RUNTIME_DEPS="libintl" \
    LOG_DIR=/var/log/atlas/${APP_NAME}

RUN mkdir -p /app \
    /data/${APP_NAME}/config \
    /var/log/atlas/${APP_NAME}

COPY ${APP_NAME}*-exec.war /app/${APP_NAME}-exec.war
COPY config/application.properties /tmp/application.properties
COPY config/log4j2.xml /data/${APP_NAME}/config/log4j2.xml

RUN \ 
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del $BUILD_DEPS && \
    apk add --update tini

EXPOSE 9000
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "envsubst < /tmp/application.properties > /data/${APP_NAME}/config/application.properties && java -Dcas.standalone.configurationDirectory=/data/${APP_NAME}/config -jar /app/cas-management-exec.war"]
