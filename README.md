# aws-jenkins-terraform

## Abstract

Mapping my previous cloud experience with Azure to Amazon Web Services - terms will be corrected as I go.

## Goals

- [x] Install Docker Desktop to run local Jenkins container
- [x] Create custom Jenkins Docker Agent image with all necessary tools for this pipeline
  - [x] aws cli
  - [x] terraform
  - [x] docker cli
  - [x] kubectl
  - [x] helm
  - [x] pwsh
- [x] Link Jenkins/Blueocean to GitHub Repo for CI
- [x] Test Docker agent plugins with some arbitrary commands
- [x] Test AWS cli login with get-caller-identity and withCredentials option
- [x] Create backend S3 storage on AWS for tfstate
  - [x] Create S3 bucket with cli
  - [x] Instruct terraform to create tfstate in bucket
- [x] Test terraform init state storage
- [x] Test terraform plan
- [x] Build/Destroy based on interactive pipeline parameter
- [x] Build/Destroy S3 tfstate storage based on interactive pipeline parameter
- [ ] Create custom node.js "Hello World" Docker container and upload to AWS "container registry"
- [ ] Deploy custom container in K8s

## Getting Started

### Setting up Jenkins

1. Start Docker Desktop
1. Start Jenkins Docker Container

    ```powershell
    # https://hub.docker.com/r/jenkinsci/blueocean/
    # This will create and run a Jenkins Blue Ocean container inside the Docker Desktop Hyper-V VM
    # and store all permanent data (plugins etc.) on the Hyper-V VM in the jenkins-data folder, which is
    # mapped to the /var/jenkins_home folder inside the Jenkins container.
    # Use this every time to spawn an instance of the Jenkins/Blueocean container which is ephemeral, 
    # but refers to the state on the Host Docker VM.
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
