# https://hub.docker.com/_/microsoft-powershell?tab=description
# Latest Ubuntu 18.04 Build is 7.0.3-ubuntu-18.04 - later ones are rc. Prefer full release.
FROM mcr.microsoft.com/powershell:7.0.3-ubuntu-18.04

# We want to install the requisite packages automatically, so some scripting will be involved.

# Version Control via Environment Variables
# https://docs.docker.com/engine/reference/builder/#environment-replacement
# Docker versions list:
# https://docs.docker.com/engine/release-notes/
ENV DOCKER_VERSION=19.03.13

# Install Docker Engine using "convenience script" - Note: not for production
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
# lastest versions of the Convenience Script will accept an environment variable called
# "VERSION" for version control


RUN VERSION="${DOCKER_VERSION}" && \
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# When called via Jenkinsfile, make sure to pass the argument below to allow the agent (Docker-in-Docker) to
# interact with the Docker daemon on the host Docker container.
# args  '-v /var/run/docker.sock:/var/run/docker.sock'
