FROM node:lts-alpine

ENV SONAR_VERSION=4.7.0.2747
ENV SONAR_SCANNER_CLI=sonar-scanner-cli-${SONAR_VERSION}
ENV SONAR_SCANNER=sonar-scanner-${SONAR_VERSION}

RUN apk add bash curl openjdk11-jre-headless

RUN curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_CLI}.zip -so /opt/${SONAR_SCANNER_CLI}.zip && \
unzip -d /opt /opt/${SONAR_SCANNER_CLI}.zip && \
rm /opt/${SONAR_SCANNER_CLI}.zip 

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

ENV PATH=$PATH:/opt/${SONAR_SCANNER}/bin

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]