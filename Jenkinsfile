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
    // if we want to pass env vars to Terraform, prefix them with TF_VAR_<VARIABLE_NAME>
    // then declare them in variables.tf and reference them as var.<VARIABLE_NAME> (without
    // the TF_VAR_ prefix) in the relevant sections of .tf files
    PREFIX = "steevaavoo"
    DEFAULT_REGION = "us-west-2"
    TERRAFORM_BUCKET_NAME = "${PREFIX}-tfstate"
    TF_VAR_AWS_DEFAULT_REGION = "${DEFAULT_REGION}"
    TF_VAR_TERRAFORM_BUCKET_NAME = "${TERRAFORM_BUCKET_NAME}"
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

  parameters {
        booleanParam(name: "TERRAFORM_DESTROY", defaultValue: false, description: 'Run Terraform Destroy (true) or Apply (false).')
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
          # bit of a dirty workaround for now - check the cli docs for better options
          aws s3 mb s3://${TERRAFORM_BUCKET_NAME} --region ${DEFAULT_REGION} || true
        """

        sh label: "Terraform init", script: """
          # Passing env vars via -backend-config args since they don't work when called
          # referenced inside the providers.tf file
          # https://github.com/hashicorp/terraform/issues/13022
          cd ./terraform
          terraform init -backend-config="bucket=${TERRAFORM_BUCKET_NAME}" \
                         -backend-config="region=${DEFAULT_REGION}"
          cd ..
        """

        sh label: "Terraform plan", script: """
          cd ./terraform
          terraform plan -out=tfplan
          cd ..
        """
      }
    }
    // TODO: Add conditional build/destroy switch
    stage('build') {
      when { expression { !params.TERRAFORM_DESTROY } }
      steps {
        sh label: "Terraform apply", script: """
          cd ./terraform
          terraform apply -auto-approve tfplan
          cd ..
        """
      }
    }

    stage('destroy') {
      when { expression { params.TERRAFORM_DESTROY } }
      steps {
        sh label: "Terraform destroy", script: """
          cd ./terraform
          terraform destroy -auto-approve
          cd ..
        """
      }
    }
  }
}
