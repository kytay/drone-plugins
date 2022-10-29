#!/bin/bash

JAVA_OPTS=""

if [[ -n "PLUGIN_SONAR_HOST" ]]; then
    JAVA_OPTS+=" -Dsonar.host.url=${PLUGIN_SONAR_HOST}"
fi

if [[ -n "PLUGIN_SONAR_TOKEN" ]]; then
    JAVA_OPTS+=" -Dsonar.login=${PLUGIN_SONAR_TOKEN}"

elif [[ -n "PLUGIN_SONAR_LOGIN" && -n "PLUGIN_SONAR_PASSWORD" ]]; then
    JAVA_OPTS+=" -Dsonar.login=${PLUGIN_SONAR_LOGIN} -Dsonar.password=${PLUGIN_SONAR_PASSWORD}"
    echo "Using authentication token is encouraged for security reasons. Refer to https://docs.sonarqube.org/latest/user-guide/user-token/"
fi

if [[ -n "PLUGIN_SONAR_LOGLEVEL" ]]; then
    JAVA_OPTS+=" -Dsonar.log.level=${PLUGIN_SONAR_LOGLEVEL}"
fi

if [[ -n "PLUGIN_SONAR_PROJECT_SETTINGS" ]]; then
    JAVA_OPTS+=" -Dproject.settings=${PLUGIN_SONAR_PROJECT_SETTINGS}"
fi

if [[ -n "PLUGIN_SONAR_DEBUG" && ${PLUGIN_SONAR_DEBUG} == "true" ]]; then
    JAVA_OPTS+=" -X"
fi

sonar-scanner ${JAVA_OPTS}