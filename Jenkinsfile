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
        echo 'Showing Util Versions'
        sh """
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
