FROM docker:19

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBECTL_VERSION="v1.8.0"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.1.2"

# Install dependencies
RUN apk add --no-cache --virtual build-dependencies python-dev libffi-dev openssl-dev gcc libc-dev make && \
    apk add --no-cache ca-certificates sudo bash git openssh curl py-pip jq  && \
    pip install docker-compose && \
    pip install yq

# Remove the dev dependencies
RUN apk del build-dependencies

# Download and install kubectl
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl 

# Download and install heml
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm

# Download and install kind
RUN curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64" && \
    chmod +x ./kind  && \
    mv ./kind /usr/local/bin


# Define docker user
ENV DOCKER_USER=developer




# Add the docker user and group
RUN addgroup -S docker && adduser --uid 1000 -S ${DOCKER_USER} -G docker

# Make the docker user sudo
RUN echo "${DOCKER_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${DOCKER_USER} && \
    echo "${DOCKER_USER} ALL=(root) NOPASSWD: /usr/local/bin/docker" > /etc/sudoers.d/${DOCKER_USER} && \
    echo "Set disable_coredump false" >> /etc/sudo.conf && \
    chmod 0440 /etc/sudoers.d/${DOCKER_USER}

# switch to the docker user
USER ${DOCKER_USER}


# Set the workspace directory
ENV WORKSPACE=/home/${DOCKER_USER}/workspace

# Make the workspace directory
RUN mkdir -p ${WORKSPACE} && chmod 777 -R ${WORKSPACE}

# cd to the working directory
WORKDIR ${WORKSPACE}