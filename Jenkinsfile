pipeline {
  agent {
    docker {
      args '-v /var/run/docker.sock:/var/run/docker.sock'
      image 'steevaavoo/pwshjenkinsagent:2020-10-30'
    }
  }

  environment {
    // Needed to create this because AWS expects a region to be defined globally
    // https://www.terraform.io/docs/commands/environment-variables.html
    PREFIX = "steevaavoo"
    TF_VAR_AWS_DEFAULT_REGION = "us-west-2"
    TF_VAR_TERRAFORM_BUCKET_NAME = "${PREFIX}-tfstate"
  }


  options {
    // taking AWS credential from Jenkins Global credential store; creates default environment variables
    // unless you specify otherwise. http://localhost:8080/credentials/store/system/domain/_/
    // Syntax generator: http://localhost:8080/job/aws-jenkins-terraform/pipeline-syntax/
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credential']])
    // colorising the console output for readability
    ansiColor('xterm')
    // timestamping console output for same reason
    timestamps()
  }

  stages {
    stage('init') {
      steps {
        sh label: "Showing Util Versions", script: """
          aws --version
          terraform version
          docker version
          kubectl version --client
          helm version
          pwsh --version
        """

        sh label: "Checking AWS Pipeline Credentials", script: """
          aws sts get-caller-identity
        """

        sh label: "Creating S3 Bucket for tfstate", script: """
          # TODO: make this idempotent
          # || true is bash equivalent of PowerShells "silentlycontinue"
          aws s3 mb s3://${TF_VAR_TERRAFORM_BUCKET_NAME} || true
        """

        sh label: "Terraform init", script: """
          terraform init \
          # passing in Jenkins environment variables to Terraform
          # -backend-config="bucket=${TERRAFORM_BUCKET_NAME}" \
          # -backend-config="region=${AWS_DEFAULT_REGION}"
        """
      }
    }
  }
}
