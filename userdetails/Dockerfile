FROM tomcat:8.5-jre8-alpine

ENV APP_NAME="userdetails"
ENV BUILD_DEPS="gettext" \
    RUNTIME_DEPS="libintl" \
    LOG_DIR=/var/log/atlas/${APP_NAME} \
    CATALINA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Dlogging.config=/data/${APP_NAME}/config/logback.groovy"

RUN mkdir -p /data/${APP_NAME}/config \
    /var/log/atlas/${APP_NAME}

COPY ${APP_NAME}*.war /tmp/${APP_NAME}.war
COPY config/logback.groovy /data/${APP_NAME}/config/logback.groovy
COPY config/${APP_NAME}-config.yml /tmp/${APP_NAME}-config.yml

RUN rm -rf $CATALINA_HOME/webapps && \
    mkdir -p $CATALINA_HOME/webapps/${APP_NAME} && \
    unzip /tmp/${APP_NAME}.war -d $CATALINA_HOME/webapps/${APP_NAME} && \
    rm /tmp/${APP_NAME}.war

RUN \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del $BUILD_DEPS && \
    apk add --update tini

RUN apk add --update fontconfig ttf-dejavu

EXPOSE 8080
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "envsubst < /tmp/${APP_NAME}-config.yml > /data/${APP_NAME}/config/${APP_NAME}-config.yml && catalina.sh run"]
