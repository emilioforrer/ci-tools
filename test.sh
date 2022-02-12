#!/bin/bash
set -e;

# TODO: Improve the way to test the commands 

echo "Git Version"
docker run --rm emilioforrer/ci-tools:latest git --version
echo "------------------------"
echo ""
echo "Bash Version"
docker run --rm emilioforrer/ci-tools:latest bash --version
echo "------------------------"
echo ""
echo "yq Version"
docker run --rm emilioforrer/ci-tools:latest yq --version
echo "------------------------"
echo ""
echo "jq Version"
docker run --rm emilioforrer/ci-tools:latest jq --version
echo "------------------------"
echo ""
echo "curl Version"
docker run --rm emilioforrer/ci-tools:latest curl --version
echo "------------------------"
echo ""
echo "docker Version"
docker run --rm emilioforrer/ci-tools:latest docker --version
echo "------------------------"
echo ""
echo "docker-compose Version"
docker run --rm emilioforrer/ci-tools:latest docker-compose --version
echo "------------------------"
echo ""
echo "kind Version"
docker run --rm emilioforrer/ci-tools:latest kind --version
echo "------------------------"
echo ""
echo "kubectl Version"
docker run --rm emilioforrer/ci-tools:latest kubectl version --client
echo "------------------------"
echo ""
echo "helm Version"
docker run --rm emilioforrer/ci-tools:latest helm version
echo "------------------------"
echo ""
echo "vault Version"
docker run --rm emilioforrer/ci-tools:latest vault --version
echo "------------------------"
echo ""
echo "1passwsord Version"
docker run --rm emilioforrer/ci-tools:latest op --version
echo "------------------------"
echo ""
echo "bitwarden Version"
docker run --rm emilioforrer/ci-tools:latest bw --version
echo "------------------------"
echo ""
echo "semver Status"
docker run --rm emilioforrer/ci-tools:latest semver get major 1.0.0 1>/dev/null && echo "OK"
echo "------------------------"
echo ""
echo "argocd Version"
docker run --rm emilioforrer/ci-tools:latest argocd version --client
echo "------------------------"
echo ""
echo "waypoint Version"
docker run --rm emilioforrer/ci-tools:latest waypoint --version
echo "------------------------"
echo ""
echo "earthly Version"
docker run --rm emilioforrer/ci-tools:latest earthly --version
echo "------------------------"
echo ""