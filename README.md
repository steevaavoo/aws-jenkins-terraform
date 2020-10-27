# aws-jenkins-terraform

## Abstract

Mapping my previous cloud experience with Azure to Amazon Web Services - terms will be corrected as I go.

## Goals

- [x] Install Docker Desktop to run local Jenkins container
- [ ] Create custom Jenkins Docker Agent image with all necessary tools for this pipeline
  - [x] aws cli
  - [ ] terraform
  - [x] docker cli
  - [ ] kubectl
  - [ ] helm
  - [x] pwsh
- [ ] Create custom node.js "Hello World" Docker container and upload to AWS "container registry"
- [ ] Deploy custom container in K8s

## Getting Started

### Setting up Jenkins

1. Start Docker Desktop
1. Start Jenkins Docker Container

    ```powershell
    # https://hub.docker.com/r/jenkinsci/blueocean/
    docker run `
        --rm -d `
        -u root `
        -p 8080:8080 `
        -v jenkins-data:/var/jenkins_home `
        -v /var/run/docker.sock:/var/run/docker.sock `
        -v /c/Users/$env:USERNAME:/home `
        --name jenkins `
        jenkinsci/blueocean:1.24.1
    ```

1. Show logs to see admin unlock code

    ```powershell
    docker container logs jenkins
    ```

1. Navigate to http://localhost:8080 and enter the password from above
1. Install suggested plugins
1. Create user
1. Instance configuration as suggested
1. Save & Finish, start using Jenkins
1. Click Manage Jenkins > Manage plugins > Available
1. Search for and tick plugins to install:
   1. AnsiColor
   1. CloudBees AWS Credentials
   1. PowerShell
1. Download now and install after restart

### Building the Docker Agent

Built iteratively, by connecting to bash in the Docker container and running the commands interactively.
Source URLs included in Dockerfile in each case.

1. Create an 'agent' folder and add a Dockerfile
1. Assemble Dockerfile
   1. Based on MS Powershell/Ubuntu Image, so PowerShell is integrated
   1. Add Docker Engine "convenience script"

    ```Dockerfile
    FROM mcr.microsoft.com/powershell:7.0.3-ubuntu-18.04

    ENV DOCKER_VERSION=19.03.13

    RUN VERSION="${DOCKER_VERSION}" && \
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh
    ```

1. Navigate to agent folder and build container

    ```powershell
    Push-Location .\agent
    $dockerUser = "steevaavoo"
    $tag = (Get-Date -Format "yyyy-MM-dd")
    $dockerImage = "$dockerUser/pwshjenkinsagent"
    $dockerImageAndTag = "$($dockerImage):$tag"
    $dockerImageAndLatestTag = "$($dockerImage):latest"
    docker build . -t $dockerImageAndTag
    docker tag $dockerImageAndTag $dockerImageAndLatestTag
    # Fix the "Cannot connect to the Docker daemon" error caused by running Docker-in-Docker - when calling the
    # agent, make sure to pass this as an argument.
    docker run -it -v /var/run/docker.sock:/var/run/docker.sock $dockerImageAndTag bash
    ```

1. Check install of Docker Engine succeeded - if you get a version list, it worked

    ```powershell
    docker run -it $dockerImageAndTag bash
    ```

    ```bash
    docker version
    ```

1. Install AWS CLI (adding the below to Dockerfile)
   1. First I needed to install the Unzip utility using apt-get (which needed updating first)

        ```bash
        RUN apt-get update
        RUN apt-get install unzip
        ```

   1. Next, I added the AWS CLI install script

        ```bash
        RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip && \
        ./aws/install
        ```

   1. Tested functionality by connecting to Bash shell in container and running:

        ```bash
        aws --version
        aws configure
        # provided my key and secret here to test connection to my account
        aws sts get-caller-identity
        # if UserID, Account and Arn are returned, AWS CLI connection is working
        ```

To Do and Note:

- [ ] Add remaining plug-ins
- [ ] Push to container registry
