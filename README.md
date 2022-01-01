# CI Tools - Docker hub image
---

## Description
---

[CI Tools](https://github.com/emilioforrer/ci-tools) is a [Docker Hub](https://hub.docker.com/r/emilioforrer/ci-tools) image for CI/CD deployments, with tools like curl, dind, docker-compose, kind, kubectl, helm, vault, 1password, semver-cli, argo-cd, bitwarden, waypoint, earthly etc.

### Tools and dependencies

|Name              | Version                    | Command
|------------------|----------------------------|--------
|git               | 2.32.0                     | git version
|bash              | 5.1.4(1)-release           | bash --version
|yq                | 2.12.2                     | yq --version
|jq                | v20210212-7320-g4be84a0f82 | jq --version
|curl              | 7.79.1                     | curl --version
|docker            | 20.10.9                    | docker --version
|docker-compose    | 1.29.2                     | docker-compose --version
|kind              | 0.11.1                     | kind --version
|kubectl           | v1.22.2                    | kubectl version --client
|helm              | v3.7.0                     | helm version
|vault             | v1.8.3                     | vault --version
|1password         | 1.12.2                     | op --version
|bitwarden         | 1.18.1                     | bw --version
|semver-cli        | 1.1.0                      | --
|argocd            | v2.1.3+d855831             | argocd version --client
|waypoint          | v0.6.3 (bd303e12)          | waypoint --version
|earthly           | v0.6.2                     | earthly --version

**Note:** to see a list of changes for supported tags and dependency versions, please see the [CHANGELOG.md](CHANGELOG.md)

### Usage
---

#### Bash

This image has a custom colored bash and prints the `STERR` in red color .

New extra **commands**:

##### `println`

Is a new command that accepts as a first parameter a **color** and a second parameter a **text** to print (if no color given, it prints the text with the **default** color).

**e.g.**

Print the text in red color <span style="color: red;background-color: black;padding: 1px 10px 1px 8px">hello</span>
```bash
println r "hello"
```
Print the text as warning (yellow) color <span style="color: yellow;background-color: black;padding: 1px 10px 1px 8px">hello</span>


```bash
println warn "hello"
```

Print the text in cyan color <span style="color: cyan;background-color: black;padding: 1px 10px 1px 8px">hello</span>

```bash
println cyan "hello"
```

Print the text in default color <span style="color: white;background-color: black;padding: 1px 10px 1px 8px">hello</span>
```bash
println "hello"
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

```bash
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           emilioforrer/ci-tools:latest \
           bash
```

Inside the image you can run `sudo docker version` or

```bash
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           emilioforrer/ci-tools:latest \
           sudo docker version
```

#### Docker compose

[Docker compose](https://docs.docker.com/compose/) is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services.

e.g. Create a `docker-compose.yaml` file.

```bash
cat << EOF > docker-compose.yaml
version: "3.7"
services:
  nginx-hello:
    image: emilioforrer/nginx-hello
    ports:
      - '8000:80'
  ruby-hello:
    image: emilioforrer/ruby-hello
    network_mode: "host"
    ports:
      - '5000:5000'
  python-hello:
    image: emilioforrer/python-hello
    network_mode: "host"
    ports:
      - '5000:5000'
  nodejs-hello:
    image: emilioforrer/nodejs-hello
    network_mode: "host"
    environment:
      URLS: 'http://0.0.0.0:7000,http://0.0.0.0:3000,http://0.0.0.0:4000,http://0.0.0.0:5000'
    ports:
      - '9000:9000'
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
      RUBY_URL: 'http://0.0.0.0:3000'
      PHP_URL: 'http://0.0.0.0:7000'
EOF
```

And then run 

```bash
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

```bash
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           sudo kind create cluster
```

#### Kubectl

[Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) Kubectl is a command line tool for controlling Kubernetes clusters. 

e.g.

```bash
docker run --rm -v "$KUBECONFIG:$KUBECONFIG" \
           -e KUBECONFIG=$KUBECONFIG \
           emilioforrer/ci-tools:latest kubectl version
```

#### Helm

[Helm](https://helm.sh/) Helm is the best way to find, share, and use software built for Kubernetes.


```bash
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           helm version
```

#### GIT

[Git](https://git-scm.com/) is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

e.g. Clonning a repository in the current working directory of the host.

```bash
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           git clone https://github.com/emilioforrer/ci-tools.git
```

#### yq

[yq](https://mikefarah.gitbook.io/yq/) is a lightweight and portable command-line YAML processor

e.g. Create a yaml and get a node.

```bash
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

```bash
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           yq '.spec.containers[0].name' pod.yaml
```

#### jq

[jq](https://stedolan.github.io/jq/) is like `sed` for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that `sed`, `awk`, `grep` and friends let you play with text.



e.g. Create a json and get a node.

```bash
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

```bash
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           jq '.spec.containers[0].name' pod.json
```

#### curl

[curl](https://curl.haxx.se/) is used in command lines or scripts to transfer data. It is also used in cars, television sets, routers, printers, audio equipment, mobile phones, tablets, settop boxes, media players and is the internet transfer backbone for thousands of software applications affecting billions of humans daily.

e.g 

```bash
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           curl -fG https://raw.githubusercontent.com/emilioforrer/ci-tools/develop/README.md > README.md
```

#### Vault CLI

[vault](https://www.vaultproject.io/) is a secure, store and tightly control access to tokens, passwords, certificates, encryption keys for protecting secrets and other sensitive data using a UI, CLI, or HTTP API.

e.g 

```bash
docker run -v $(pwd)/:/home/developer/workspace \
           emilioforrer/ci-tools:latest \
           vault --version
```


#### 1Password CLI

[1Password](https://1password.com/downloads/command-line/) with 1Password you only ever need to memorize one password.
All your other passwords and important information are protected by your Master Password, which only you know.
e.g 

```bash
docker run -it emilioforrer/ci-tools:latest op --version
```

#### Bitwarden CLI

[Bitwarden](https://bitwarden.com/) Open Source Password Management for You and Your Business.
he easiest and safest way for individuals and businesses to store, share, and secure sensitive data on any device
e.g 

```bash
docker run -it emilioforrer/ci-tools:latest bw --version
```

#### Waypoint CLI

[waypoint-cli](https://www.waypointproject.io/) allows developers to deploy, manage, and observe their applications through a consistent abstraction of underlying infrastructure.
e.g 

```bash
docker run -it emilioforrer/ci-tools:latest waypoint --help
```

#### Earthly CLI

[earthly-cli](https://earthly.dev/) is a syntax for defining your build. It works with your existing build system. Get repeatable and understandable builds today.
e.g 

```bash
# In order to use `earthly bootstrap` inside the image without sudo, you need to add `--group-add $(stat -c '%g' /var/run/docker.sock)` 
docker run -it -v /var/run/docker.sock:/var/run/docker.sock --group-add $(stat -c '%g' /var/run/docker.sock) emilioforrer/ci-tools:latest earthly --help
```
#### Semver CLI

[semver-cli](https://github.com/davidrjonas/semver-cli) is a simple command line tool to compare and manipulate version strings.
e.g 

```bash
docker run -it emilioforrer/ci-tools:latest semver --help
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

