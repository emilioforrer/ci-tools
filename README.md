# CI Tools - Docker hub image
---

## Description
---

[CI Tools](https://github.com/emilioforrer/ci-tools) is a [Docker Hub](https://hub.docker.com/r/emilioforrer/ci-tools) image for CI/CD deployments, with tools like curl, dind, docker-compose, kind, kubectl, helm, vault, etc.

To see a list of supported tags and dependency versions, please see the [CHANGELOG.md](CHANGELOG.md)

### Usage
---

#### Bash

This image has a custom colored bash and prints the `STERR` in red color .

New extra commands:

##### `print`

Is a new command that accepts as a first parameter a **color** and a second parameter a **text** to print (if no color given, it prints the text with the **default** color).

**e.g.**

Print the text in red color <span style="color: red;background-color: black;padding: 1px 10px 1px 8px">hello</span>
```bash
print r "hello"
```
Print the text as warning (yellow) color <span style="color: yellow;background-color: black;padding: 1px 10px 1px 8px">hello</span>


```bash
print warn "hello"
```

Print the text in cyan color <span style="color: cyan;background-color: black;padding: 1px 10px 1px 8px">hello</span>

```bash
print cyan "hello"
```

Print the text in default color <span style="color: white;background-color: black;padding: 1px 10px 1px 8px">hello</span>
```bash
print "hello"
```



List of colors

Name            | Short name
----------------|------------
black           | bk
red             |  r
green           |  g
yellow          |  y
blue            |  b
purple          |  p
cyan            |  c
white           | wh
info            |  i
warn (yellow)   |  w
error (red)     |  e
sucsess (green) | ok

#### DIND (Docker in Docker)

[DIND](https://itnext.io/docker-in-docker-521958d34efd) is a way to run Docker inside a Docker container (for example, to pull and build images, or to run other containers) in your CI/CD system.

```
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           emilioforrer/ci-tools:latest \
           bash
```

Inside the image you can run `sudo docker version` or

```
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           emilioforrer/ci-tools:latest \
           sudo docker version
```

#### Docker compose

[Docker compose](https://docs.docker.com/compose/) is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services.

e.g. Create a `docker-compose.yaml` file.

```
cat << EOF > docker-compose.yaml
version: "3.7"
services:
  ruby-hello:
    image: emilioforrer/ruby-hello
    network_mode: "host"
    ports:
      - '5000:5000'
  nodejs-hello:
    image: emilioforrer/nodejs-hello
    network_mode: "host"
    environment:
      URLS: 'http://0.0.0.0:5000,http://0.0.0.0:4000'
    ports:
      - '5001:5001'
  php-hello:
    image: emilioforrer/php-hello
    network_mode: "host"
    ports:
      - '7000:7000'
  elixir-hello:
    image: emilioforrer/elixir-hello
    network_mode: "host"
    ports:
      - '4000:4000'
    environment:
      RUBY_URL: 'http://0.0.0.0:5000'
      PHP_URL: 'http://0.0.0.0:7000'
EOF
```

And then run 

```
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           sudo docker-compose up
```

Now open your favorite browser and visit `http://localhost:5001/`


#### KIND (Kubernetes In Docker)

[KIND](https://github.com/kubernetes-sigs/kind) kind is a tool for running local Kubernetes clusters using Docker container "nodes".
kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

e.g. 

```
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           sudo kind create cluster
```

#### Kubectl

[Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) Kubectl is a command line tool for controlling Kubernetes clusters. 

e.g.

```
docker run --rm -v "$KUBECONFIG:$KUBECONFIG" \
           -e KUBECONFIG=$KUBECONFIG \
           emilioforrer/ci-tools:latest kubectl version
```

#### Helm

[Helm](https://helm.sh/) Helm is the best way to find, share, and use software built for Kubernetes.


```
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           helm version
```

#### GIT

[Git](https://git-scm.com/) is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

e.g. Clonning a repository in the current working directory of the host.

```
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           git clone https://github.com/emilioforrer/ci-tools.git
```

#### yq

[yq](https://mikefarah.gitbook.io/yq/) is a lightweight and portable command-line YAML processor

e.g. Create a yaml and get a node.

```
cat <<EOF > pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox
    command: ['sh', '-c', 'echo Hello Kubernetes! && sleep 3600']
EOF
```

Get the container name

```
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           yq '.spec.containers[0].name' pod.yaml
```

#### jq

[jq](https://stedolan.github.io/jq/) is like `sed` for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that `sed`, `awk`, `grep` and friends let you play with text.



e.g. Create a json and get a node.

```
cat <<EOF > pod.json
{
  "apiVersion": "v1",
  "kind": "Pod",
  "metadata": {
    "name": "myapp-pod",
    "labels": {
      "app": "myapp"
    }
  },
  "spec": {
    "containers": [
      {
        "name": "myapp-container",
        "image": "busybox",
        "command": [
          "sh",
          "-c",
          "echo Hello Kubernetes! && sleep 3600"
        ]
      }
    ]
  }
}
EOF
```

Get the container name

```
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           jq '.spec.containers[0].name' pod.json
```

#### curl

[curl](https://curl.haxx.se/) is used in command lines or scripts to transfer data. It is also used in cars, television sets, routers, printers, audio equipment, mobile phones, tablets, settop boxes, media players and is the internet transfer backbone for thousands of software applications affecting billions of humans daily.

e.g 

```
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           curl -fG https://raw.githubusercontent.com/emilioforrer/ci-tools/develop/README.md > README.md
```

#### Vault CLI

[vault](https://www.vaultproject.io/) is a secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.

e.g 

```
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           vault --version
```

## Development

### Scripts

#### Build Docker image

```bash
# Build Docker image
./build.sh
# Build and push Docker image
DOCKER_PUSH=true ./build.sh
```

**Note:** Before pushing an image, make sure to change the release version in the `VERSION` file.

#### Check tools versions

```bash
docker run --rm emilioforrer/ci-tools:latest git --version
docker run --rm emilioforrer/ci-tools:latest bash --version
docker run --rm emilioforrer/ci-tools:latest yq --version
docker run --rm emilioforrer/ci-tools:latest jq --version
docker run --rm emilioforrer/ci-tools:latest curl --version
docker run --rm emilioforrer/ci-tools:latest docker --version
docker run --rm emilioforrer/ci-tools:latest docker-compose --version
docker run --rm emilioforrer/ci-tools:latest kind --version
docker run --rm emilioforrer/ci-tools:latest helm version
docker run --rm -v "$KUBECONFIG:$KUBECONFIG" \
           -e KUBECONFIG=$KUBECONFIG \
           emilioforrer/ci-tools:latest kubectl version

```