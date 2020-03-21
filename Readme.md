# CI Tools - Docker hub image
---

To see a list of supported tags and dependency versions, please see the [CHANGELOG.md](CHANGELOG.md)

## Description
---

### Usage
---

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
docker run --rm -it \
           -v /var/run/docker.sock:/var/run/docker.sock \
           emilioforrer/ci-tools:latest \
           sudo kubectl cluster-info
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
           curl -fG https://raw.githubusercontent.com/emilioforrer/ci-tools/develop/Readme.md > README.md
```