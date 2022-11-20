#!/bin/bash

set -e

echo "#################################"
echo "Initialising sonar-node-plugin..."
echo "#################################"

JAVA_OPTS=""

if [[ -n ${DRONE_WORKSPACE} ]]; then
    echo "sonar.projectBaseDir=${DRONE_WORKSPACE}" >> /opt/${SONAR_SCANNER}/conf/sonar-scanner.properties
    if [[ ! -f "/drone/src/sonar-project.properties" ]]; then 
        JAVA_OPTS+=" -Dsonar.projectKey=${DRONE_REPO_NAMESPACE}:${DRONE_REPO_NAME}"
        JAVA_OPTS+=" -Dsonar.projectName=${DRONE_REPO}"
    fi
fi

if [[ -n ${PLUGIN_SONAR_HOST} ]]; then
    JAVA_OPTS+=" -Dsonar.host.url=${PLUGIN_SONAR_HOST}"
fi

if [[ -n ${PLUGIN_SONAR_TOKEN} ]]; then
    JAVA_OPTS+=" -Dsonar.login=${PLUGIN_SONAR_TOKEN}"

elif [[ -n ${PLUGIN_SONAR_LOGIN} && -n ${PLUGIN_SONAR_PASSWORD} ]]; then
    JAVA_OPTS+=" -Dsonar.login=${PLUGIN_SONAR_LOGIN} -Dsonar.password=${PLUGIN_SONAR_PASSWORD}"
    echo "Using authentication token is encouraged for security reasons. Refer to https://docs.sonarqube.org/latest/user-guide/user-token/"
fi

if [[ -n ${PLUGIN_SONAR_LOGLEVEL} ]]; then
    JAVA_OPTS+=" -Dsonar.log.level=${PLUGIN_SONAR_LOGLEVEL}"
fi

if [[ -n ${PLUGIN_SONAR_PROJECT_SETTINGS} ]]; then
    JAVA_OPTS+=" -Dproject.settings=${PLUGIN_SONAR_PROJECT_SETTINGS}"
fi

# additional setup for nvm installation
touch $HOME/.bashrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# bootstrap nvm
export NVM_DIR="$HOME/.nvm" && \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

if [[ -n ${PLUGIN_USE_NODE_VERSION} ]]; then
    echo PLUGIN_USE_NODE_VERSION found!
    echo Setup NODE_VERSION=${PLUGIN_USE_NODE_VERSION}
    # Install and use specific node version
    nvm install ${PLUGIN_USE_NODE_VERSION} && \
    nvm use ${PLUGIN_USE_NODE_VERSION}
else
    echo PLUGIN_USE_NODE_VERSION not found!
    echo Set node to latest LTS
    # Install and use current LTS version
    nvm install --lts && \
    nvm use --lts
fi

echo "############################################################"
echo "Initialised sonar-node-plugin - ready to perform sonar scan."
echo "############################################################"

if [[ -n ${PLUGIN_SONAR_DEBUG} && ${PLUGIN_SONAR_DEBUG} == "true" ]]; then
    JAVA_OPTS+=" -X"
    echo "JAVA_OPTS=${JAVA_OPTS}"
fi

sonar-scanner ${JAVA_OPTS}