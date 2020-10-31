pipeline {
  agent {
    docker {
      args '-v /var/run/docker.sock:/var/run/docker.sock'
      image 'steevaavoo/pwshjenkinsagent:2020-10-30'
    }
  }

  environment {
    // Needed to create this because AWS expects a region to be defined globally
    AWS_DEFAULT_REGION = "us-west-2"
    PREFIX = "steevaavoo"
    TERRAFORM_BUCKET_NAME = "${PREFIX}-tfstate"
  }


  options {
    // taking AWS credential from Jenkins Global credential store and creates default environment variables
    // unless you specify otherwise.
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
          # TODO: make this idempotent and reintegrate
          aws s3 mb s3://${TERRAFORM_BUCKET_NAME} || true
        """

        sh label: "Terraform init", script: """
          terraform init \
          # passing in Jenkins environment variables to Terraform
          -backend-config="bucket=${TERRAFORM_BUCKET_NAME}" \
          -backend-config="region=${AWS_DEFAULT_REGION}"
        """
      }
    }
  }
}
