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
    image: drpsychick/dind-buildx-helm
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
                        withCredentials([usernamePassword(credentialsId: 'docker_hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push madmax1234/jenkins-docker-hub:latest
                            '''
                        }
                    }
                }
            }
        }
    
        stage('Build and push helm chart') {
            steps {
                container('dind') {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'docker_hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            helm package app
                            helm push app-0.1.0.tgz  oci://registry-1.docker.io/madmax1234
                            helm package helmdb
                            helm push helmdb-0.1.0.tgz  oci://registry-1.docker.io/madmax1234
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
                subject: "Failed: The Build Failed",
                body: "The build failed. Please check the Jenkins build log for details.",
                attachLog: true,
            )
        }
    }
}
