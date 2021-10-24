FROM alpine:latest

ENV SONAR_SCANNER_VERSION=4.6.2.2472
ENV SONAR_SCANNER_FILENAME=sonar-scanner-cli-${SONAR_SCANNER_VERSION}
ENV SONAR_SCANNER_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_FILENAME}.zip

RUN sed -i \
's|https://dl-cdn.alpinelinux.org/alpine/|http://mirror.aarnet.edu.au/pub/alpine/|g' \
/etc/apk/repositories

RUN apk update && \
apk add --progress curl unzip openjdk11-jre && \
curl -LO ${SONAR_SCANNER_URL} && \
unzip ${SONAR_SCANNER_FILENAME}.zip && rm ${SONAR_SCANNER_FILENAME}.zip && \
mv /sonar-scanner-* /sonar-scanner 

WORKDIR /sonar-scanner

CMD /bin/sh