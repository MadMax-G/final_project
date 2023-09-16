pipeline {
  agent {label 'mac'}
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker_hub')
  }
  stages {
      stage('Run Tests and Build Docker Image') {
          steps {
              container('dind') {
                  script {
                      sh 'dockerd &'
                      sh 'sleep 5'
                      sh 'docker buildx build --platform linux/amd64 -t madmax1234/jenkins-docker-hub:latest .'
                      sh 'docker run madmax1234/jenkins-docker-hub:latest test.py'
                      echo 'passed test'
                    }
                }
            }
        }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push madmax1234/jenkins-docker-hub:latest'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
