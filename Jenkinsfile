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
         stage('Run Tests and Build Docker Image') {
            steps {
                container('dind') {
                    script {
                        sh 'dockerd &'
                        sh 'sleep 5'
                        sh 'docker build -t madmax1234/jenkins-docker-hub:latest .'
                        sh 'docker run madmax1234/jenkins-docker-hub:latest test.py'
                        echo 'passed test'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                container('dind') {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'error', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push madmax1234/jenkins-docker-hub:latest
                            '''
                        }
                    }
                }
            }
        }
    }
       post {
        failure {
            emailext (
                to: 'maxmadorski@gmail.com',
                subject: "Failed: ${currentBuild.fullDisplayName}",
                body: "The build failed. Please check the Jenkins build log for details.",
                attachLog: true,
            )
        }
    }
}
