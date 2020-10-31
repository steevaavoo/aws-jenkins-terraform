pipeline {
  agent {
    docker {
      args '-v /var/run/docker.sock:/var/run/docker.sock'
      image 'pwshjenkinsagent:2020-10-30'
    }

  }
  stages {
    stage('build') {
      steps {
        echo 'Hello World'
      }
    }

  }
}