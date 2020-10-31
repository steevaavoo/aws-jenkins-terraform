pipeline {
  agent {
    docker {
      args '-v /var/run/docker.sock:/var/run/docker.sock'
      image 'steevaavoo/pwshjenkinsagent:2020-10-30'
    }

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
      }
    }

  }
}
