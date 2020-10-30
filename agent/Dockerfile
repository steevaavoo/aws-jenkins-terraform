# https://hub.docker.com/_/microsoft-powershell?tab=description
# Latest Ubuntu 18.04 Build is 7.0.3-ubuntu-18.04 - later ones are rc. Prefer full release.
FROM mcr.microsoft.com/powershell:7.0.3-ubuntu-18.04

# We want to install the requisite packages automatically, so some scripting will be involved.

# Version Control via Environment Variables
# https://docs.docker.com/engine/reference/builder/#environment-replacement
# Docker version list:
# https://docs.docker.com/engine/release-notes/
ENV DOCKER_VERSION=19.03.13

# AWS CLI version list
# https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ENV AWSCLI_VERSION=2.0.59

# Terraform version list:
# https://github.com/hashicorp/terraform/tags
ENV TF_VERSION=0.13.5

# K8s version list
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
ENV K8S_VERSION=1.19.0

# Helm version list
# https://github.com/helm/helm/releases
ENV HELM_VERSION=3.4.0

# Updating apt-get with available packages and installing unzip
RUN apt-get -q update && apt-get -q install unzip

# Install Docker Engine using "convenience script" - Note: not for production
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
# lastest versions of the Convenience Script will accept an environment variable called
# "VERSION" for version control
RUN VERSION=${DOCKER_VERSION} && \
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# When called via Jenkinsfile, make sure to pass the argument below to allow the agent (Docker-in-Docker) to
# interact with the Docker daemon on the host Docker container.
# args  '-v /var/run/docker.sock:/var/run/docker.sock'

# Install AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#x86
# Left the curl args verbose deliberately to illustrate truncated args above
RUN curl --fail --silent --show-error --location https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip --output awscliv2.zip && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip

# Install Terraform
# https://gist.github.com/kaikousa/1a951df681ad2f11b5b0b77180238c44
RUN curl https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip -q terraform.zip && \
    mv terraform /usr/bin && \
    rm terraform.zip

# Install Kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/v${K8S_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install Helm
# https://helm.sh/docs/intro/install/
RUN curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
    tar -zxf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm
