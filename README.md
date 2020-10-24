# aws-jenkins-terraform

## Abstract

Mapping my previous cloud experience with Azure to Amazon Web Services - terms will be corrected as I go.

## Goals

- [ ] Install Docker Desktop to run local Jenkins container
- [ ] Create custom Jenkins Docker Agent image with all necessary tools for this pipeline
  - [ ] aws cli
  - [ ] terraform
  - [ ] docker cli
  - [ ] kubectl
  - [ ] helm
  - [ ] pwsh
- [ ] Create custom node.js "Hello World" Docker container and upload to AWS "container registry"
- [ ] Deploy custom container in K8s

## Getting Started

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
