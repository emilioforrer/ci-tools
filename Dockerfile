# Note: Latest version of docker may be found at:
# https://hub.docker.com/_/docker
ARG DOCKER_VERSION_IMAGE_NAME=docker:20

FROM node:10-alpine as node-builder

# Note: Latest version of bitwarden may be found at:
# https://github.com/bitwarden/cli/releases
ENV BITWARDEN_VERSION="v1.20.0"

RUN apk add git

RUN git clone https://github.com/bitwarden/cli.git && \
    cd cli/ && \
    git checkout ${BITWARDEN_VERSION} && \
    git submodule update --init --recursive && \
    npm install && \
    sed -i "/\"package:lin\":/c\\        \"package:lin\": \"pkg . --targets node10-alpine-x64 --output ./dist/linux/bw\"," ./package.json && \
    npm run dist:lin 


FROM golang:latest as go-builder

# Note: Latest version of semver-cli may be found at:
# https://github.com/davidrjonas/semver-cli/releases
ENV SEMVER_CLI_VERSION="1.1.0"

RUN mkdir temp && \
    cd temp && \
    go mod init local/build && \
    go get -d -v github.com/davidrjonas/semver-cli@${SEMVER_CLI_VERSION} && \
    mkdir bin && \
    go build -o bin/semver github.com/davidrjonas/semver-cli

FROM ${DOCKER_VERSION_IMAGE_NAME}

# Define docker user
ARG DOCKER_USER=developer

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBECTL_VERSION="v1.23.1"

# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.7.2"

# Note: Latest version of vault may be found at:
# https://github.com/kubernetes-sigs/kind/releases
ENV KIND_VERSION="v0.11.1"

# Note: Latest version of vault may be found at:
# https://releases.hashicorp.com/vault/
ENV VAULT_VERSION="1.9.2"

# Note: Latest version of waypoint may be found at:
# https://releases.hashicorp.com/waypoint/
ENV WAYPOINT_VERSION="0.6.3"

# Note: Latest version of earthly may be found at:
# https://github.com/earthly/earthly/releases/
ENV EARTHLY_VERSION="v0.6.2"

# Note: Latest version of 1password may be found at:
# https://app-updates.agilebits.com/product_history/CLI
ENV ONEPASSWORD_VERSION="v1.12.3"

# Note: Latest version of argo-cd may be found at:
# https://github.com/argoproj/argo-cd/releases
ENV ARGO_CD_VERSION="v2.2.1"

# Note: Latest version of docker-compose may be found at:
# https://docs.docker.com/compose/release-notes/
ENV DOCKER_COMPOSE_VERSION="1.29.2"

# Install dependencies
RUN apk add --no-cache --virtual build-dependencies gcc musl-dev python3-dev libffi-dev openssl-dev cargo libc-dev make && \
    apk add --update --no-cache ca-certificates sudo bash git openssh-client curl py-pip jq libc6-compat libstdc++ && \
    pip install  docker-compose==${DOCKER_COMPOSE_VERSION} && \
    pip install yq

# Remove the dev dependencies
RUN apk del build-dependencies

# Download and install kubectl
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl 

# Download and install helm
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm

# Download and install kind
RUN curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-$(uname)-amd64" && \
    chmod +x ./kind  && \
    mv ./kind /usr/local/bin

# Download and install vault cli
RUN wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    chown root vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
    chmod +x ./vault  && \
    mv ./vault /usr/local/bin && \
    rm ./vault_${VAULT_VERSION}_linux_amd64.zip

RUN wget -q "https://releases.hashicorp.com/waypoint/${WAYPOINT_VERSION}/waypoint_${WAYPOINT_VERSION}_linux_amd64.zip" && \
    unzip waypoint_${WAYPOINT_VERSION}_linux_amd64.zip && \
    chmod +x ./waypoint  && \
    mv ./waypoint /usr/local/bin && \
    rm ./waypoint_${WAYPOINT_VERSION}_linux_amd64.zip

# Download and install 1password cli
RUN wget -q https://cache.agilebits.com/dist/1P/op/pkg/${ONEPASSWORD_VERSION}/op_linux_amd64_${ONEPASSWORD_VERSION}.zip && \
    chown root op_linux_amd64_${ONEPASSWORD_VERSION}.zip && \
    unzip op_linux_amd64_${ONEPASSWORD_VERSION}.zip && \
    chmod +x ./op  && \
    mv ./op /usr/local/bin && \
    rm ./op_linux_amd64_${ONEPASSWORD_VERSION}.zip

# Download and install earthly cli
RUN wget https://github.com/earthly/earthly/releases/download/${EARTHLY_VERSION}/earthly-linux-amd64 -O /usr/local/bin/earthly && \
    chmod +x /usr/local/bin/earthly

# Download and install argo-cd
RUN curl -Lo ./argocd "https://github.com/argoproj/argo-cd/releases/download/${ARGO_CD_VERSION}/argocd-linux-amd64" && \
    chmod +x ./argocd  && \
    mv ./argocd /usr/local/bin

# Copy binaries from node-builder
# bitwarden-cli from https://github.com/bitwarden/cli 
COPY --from=node-builder /cli/dist/linux /usr/local/bin

# Copy binaries from go-builder
# semver-cli from https://github.com/davidrjonas/semver-cli/releases 
COPY --from=go-builder /go/temp/bin /usr/local/bin

# Add the docker user and group
RUN addgroup -S docker && adduser --uid 1000 -S ${DOCKER_USER} -G docker

# Make the docker user sudo
RUN echo "${DOCKER_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${DOCKER_USER} && \
    echo "Set disable_coredump false" >> /etc/sudo.conf && \
    chmod 0440 /etc/sudoers.d/${DOCKER_USER}

# Copy the scripts
COPY scripts/ /scripts

# Copy .bashrc file
RUN cp /scripts/.bashrc /root && \
    cp /scripts/.bashrc /home/${DOCKER_USER}

# switch to the docker user
USER ${DOCKER_USER}

# Set the workspace directory
ENV WORKSPACE=/home/${DOCKER_USER}/workspace

# Make the workspace directory
RUN mkdir -p ${WORKSPACE} && chmod 777 -R ${WORKSPACE}

# cd to the working directory
WORKDIR ${WORKSPACE}

# Set default shell command to bash
SHELL ["/bin/bash", "--login", "-c"]