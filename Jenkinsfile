pipeline {
    agent {
        kubernetes {
            label 'dind-agent'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  name: jenkins-dind-agent
  namespace: jenkins
spec:
  containers:
  - name: jenkins-dind
    image: docker:dind
    env:
    - name: DOCKER_HOST
      value: tcp://localhost:2375
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-graph-storage
      mountPath: /var/lib/docker
  volumes:
  - name: docker-graph-storage
    emptyDir: {}
"""
        }
    }
    stages {
         stage('Run Tests and Build Docker Image') {
            steps {
                container('dind') {
                    script {
                        echo 'in script'
                        sh 'dockerd &'
                        echo 'before sleep'
                        sh 'sleep 5'
                        echo 'after sleep'
                        sh 'docker buildx build --platform linux/amd64 -t madmax1234/jenkins-docker-hub:latest .'
                        echo 'after build'
                        sh 'docker run madmax1234/jenkins-docker-hub:latest test.py'
                        echo 'passed test'
                    }
                }
            }
        }
    }
}
//         stage('Push Docker Image') {
//             steps {
//                 container('dind') {
//                     script {
//                         withCredentials([usernamePassword(credentialsId: 'docker_hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//                             sh '''
//                             echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
//                             docker push madmax1234/jenkins-docker-hub:latest
//                             '''
//                         }
//                     }
//                 }
//             }
//         }
//     }
//        post {
//         failure {
//             emailext (
//                 to: 'maxmadorski@gmail.com',
//                 subject: "Failed: ${currentBuild.fullDisplayName}",
//                 body: "The build failed. Please check the Jenkins build log for details.",
//                 attachLog: true,
//             )
//         }
//     }
// }
