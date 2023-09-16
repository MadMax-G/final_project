pipeline {
  agent {label 'mac'}
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker_hub')
  }
  stages {
    stage('Setup') {
      steps {
        script {
          podTemplate(yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: dind
    image: docker:dind
    env:
    - name: DOCKER_HOST
      value: unix:///var/run/docker-dind.sock
    securityContext:
      privileged: true
    volumeMounts:
    - mountPath: /var/run
      name: docker-sock
  volumes:
  - name: docker-sock
    emptyDir: {}
""") {
            node('mac') {
              stage('Run Tests and Build Docker Image') {
                steps {
                  sh 'docker buildx build --platform linux/amd64 -t madmax1234/jenkins-docker-hub:latest .'
                  sh 'docker run madmax1234/jenkins-docker-hub:latest test.py'
                  echo 'passed test'
                }
              }
              stage('Login') {
                steps {
                  withCredentials([usernamePassword(credentialsId: 'docker_hub', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR')]) {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                  }
                }
              }
              stage('Push') {
                steps {
                  sh 'docker push madmax1234/jenkins-docker-hub:latest'
                }
              }
            }
          }
        }
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
