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
    TF_VAR_PREFIX = "${PREFIX}"
    TF_VAR_AWS_DEFAULT_REGION = "${DEFAULT_REGION}"
    TF_VAR_TERRAFORM_BUCKET_NAME = "${TERRAFORM_BUCKET_NAME}"
    TF_VAR_ECR_NAME = "${PREFIX}-ecr001"
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
        // Prompts for input when starting build. Referenced later to decide whether to run terraform
        // build or terraform destroy
        // NOTE - run from http://localhost:8080/blue/organizations/jenkins/aws-jenkins-terraform/branches
        // to see parameter prompts.
        booleanParam(name: "TERRAFORM_DESTROY", defaultValue: false, description: 'Run Terraform Destroy (true) or Apply (false).')
        booleanParam(name: "AWS_STORAGE_DESTROY", defaultValue: false, description: 'Destroy AWS S3 Tfstate storage? Yes (true) No (false)')
  }

  stages {
    stage('init') {
      steps {
        // Thanks to Adam Rush for this fix to Error 126 when calling scripts
        // https://github.com/adamrushuk/aks-nexus-velero/blob/develop/.github/workflows/build.yml#L91
        sh label: "Setting permissions on Scripts folder", script: """
          chmod -R +x ./scripts/
        """

        sh label: "Showing Util Versions", script: './scripts/show_util_versions.sh'

        sh label: "Checking AWS Pipeline Credentials", script: './scripts/check_aws_credentials.sh'

        sh label: "Creating S3 Bucket for tfstate", script: './scripts/create_aws_storage.sh'

        sh label: "Terraform init", script: './scripts/terraform_init.sh'

      }
    }

    stage('build') {
      when { expression { !params.TERRAFORM_DESTROY } }
      steps {
        sh label: "Terraform plan", script: './scripts/terraform_plan.sh'

        sh label: "Terraform apply", script: './scripts/terraform_apply.sh'

      }
    }

    stage('destroy') {
      when { expression { params.TERRAFORM_DESTROY } }
      steps {
        sh label: "Terraform destroy", script: './scripts/terraform_destroy.sh'
      }
    }

    stage('destroy-storage') {
      when { expression { params.AWS_STORAGE_DESTROY } }
      steps {
        sh label: "Deleting S3 Bucket for tfstate", script: './scripts/destroy_storage.sh'
      }
    }
  }
}
