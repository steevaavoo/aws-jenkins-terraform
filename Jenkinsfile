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
    BUCKET_EXISTS = ""
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

// # ORIGINAL: bucket_exists=`aws s3api list-buckets --query 'Buckets[?starts_with(Name, \`"'${TERRAFORM_BUCKET_NAME}'"\`) == \`true\`].Name' --output text`

        sh label: "Creating S3 Bucket for tfstate", script: """
          # Checking if my bucket already exists and adding result to variable
          # The original script (see above) needed to be run through the Jenkins Pipeline Syntax Generator to avoid
          # throwing errors.
          $BUCKET_EXISTS=`aws s3api list-buckets --query \'Buckets[?starts_with(Name, \\`"\'${TERRAFORM_BUCKET_NAME}\'"\\`) == \\`true\\`].Name\' --output text`
          # Evaluating variable and creating a bucket if empty
          if [[ ${BUCKET_EXISTS} ]]; then
            echo "Bucket exists, moving on."
          else
            echo "Bucket does not exist, creating..."
            aws s3 mb s3://${TERRAFORM_BUCKET_NAME} --region ${DEFAULT_REGION}
          fi
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

    stage('destroy-storage') {
      when { expression { params.AWS_STORAGE_DESTROY } }
      steps {
        sh label: "Deleting S3 Bucket for tfstate", script: """
          aws s3 rb s3://${TERRAFORM_BUCKET_NAME} --region ${DEFAULT_REGION} --force
        """
      }
    }
  }
}
