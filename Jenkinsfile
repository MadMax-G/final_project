pipeline {
    agent {
        kubernetes {
            label 'dind-agent'
            yaml """
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
"""
        }
    }
    stages {
         stage ('Run app') {
      steps {
        sh 'python3 database.py &'
      }
    }
    stage ('test app') {
      steps {
        sh 'pytest test.py'
      }
    }
        stage('Build and Push Docker Image') {
             when {
                changeset 'database.py'
            }
            steps {
                container('dind') {
                    script {
                        sh 'dockerd &'
                        sh 'sleep 5'
                        sh 'docker build -t madmax1234/jenkins-docker-hub:1.0 .'
                        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker madmax1234/jenkins-docker-hub:1.0
                            '''
                        }
                    }
                }
            }
        }
    }
}
