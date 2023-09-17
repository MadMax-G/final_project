# Setting up Jenkins on a Kubernetes Cluster

This README provides a comprehensive guide on how to set up Jenkins on a Kubernetes cluster using Helm. The steps are based on the instructions provided on this [source](https://sweetcode.io/how-to-setup-jenkins-ci-cd-pipeline-on-kubernetes-cluster-with-helm/).

## Prerequisites

Ensure that you have the following requirements set up:

- Kubectl: The command-line tool for Kubernetes. It must be installed and connected to your Kubernetes cluster. Your Kubernetes configuration file (kubeconfig) should be in the default location: `~/.kube/config`.
- Helm: It is a package manager for Kubernetes. Install Helm on your machine.

### Installing Helm

You can install Helm using the following command:

```bash
sudo apt install helm
```

## Jenkins Installation

After setting up the prerequisites, proceed with the following steps to install Jenkins.

1. **Add Jenkins Helm Repository**

   Add Jenkins to your Helm repository using the following command:

   ```bash
   helm repo add jenkins https://charts.jenkins.io
   ```

2. **Update Helm Repository**

   Update your Helm repository with the following command:

   ```bash
   helm repo update
   ```

3. **Install Jenkins**

   Install the official Jenkins package using the following command:

   ```bash
   helm install myjenkins jenkins/jenkins
   ```

4. **Retrieve Jenkins Password**

   Get the Jenkins admin password using the following command:

   ```bash
   kubectl get secret --namespace default myjenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
   ```

5. **Find the LoadBalancer IP**

   Retrieve the IP of the LoadBalancer using the following command:

   ```bash
   kubectl get svc --namespace=default
   ```

   The 'default' namespace is where the Jenkins installation resides.

6. **Access Jenkins**

   Open the Jenkins URL in your web browser. The URL is the External-IP of the Jenkins service at port 8080. Log in using the username 'admin' and the password retrieved in the previous step.

## Problem solving - Jenkins doesn't create a LoadBalancer

   If Jenkins doesn't create a LoadBalancer after installation on the cluster, replace the 'service' YAML file with the following one:

   ```bash
   apiVersion: v1
   kind: Service
   metadata:
     annotations:
       cloud.google.com/neg: '{"ingress":true}'
       meta.helm.sh/release-name: myjenkins
       meta.helm.sh/release-namespace: default
     creationTimestamp: "2023-09-17T09:13:21Z"
     labels:
       app.kubernetes.io/component: jenkins-controller
       app.kubernetes.io/instance: myjenkins
       app.kubernetes.io/managed-by: Helm
       app.kubernetes.io/name: jenkins
       helm.sh/chart: jenkins-4.6.4
     managedFields:
     - apiVersion: v1
       fieldsType: FieldsV1
       fieldsV1:
         f:metadata:
           f:annotations:
             .: {}
             f:meta.helm.sh/release-name: {}
             f:meta.helm.sh/release-namespace: {}
           f:labels:
             .: {}
             f:app.kubernetes.io/component: {}
             f:app.kubernetes.io/instance: {}
             f:app.kubernetes.io/managed-by: {}
             f:app.kubernetes.io/name: {}
             f:helm.sh/chart: {}
         f:spec:
           f:internalTrafficPolicy: {}
           f:ports:
             .: {}
             k:{"port":8080,"protocol":"TCP"}:
               .: {}
               f:name: {}
               f:port: {}
               f:protocol: {}
               f:targetPort: {}
           f:selector: {}
           f:sessionAffinity: {}
           f:type: {}
       manager: helm
       operation: Update
       time: "2023-09-17T09:13:21Z"
     name: myjenkins
     namespace: default
     resourceVersion: "2594490"
     uid: befd0758-56cd-4463-b1dc-26efe29d27e5
   spec:
     internalTrafficPolicy: Cluster
     ports:
     - name: http
       port: 8080
       protocol: TCP
       targetPort: 8080
     selector:
       app.kubernetes.io/component: jenkins-controller
       app.kubernetes.io/instance: myjenkins
     sessionAffinity: None
     type: LoadBalancer
   status:
     loadBalancer: {}
   
   ```


## Jenkins Configuration

After logging in to Jenkins, follow the instructions to install the suggested plugins. 

### Creating Credentials

1. Navigate to "Manage Jenkins" on the left panel.
2. Click on the "Credentials" section.
3. Click on "(global)" under Domain.
4. Click "+add credentials" in the top right corner and create a username with password for your Git repository and DockerHub. The description is crucial for pipeline definition.

### Installing Additional Plugins

1. Navigate to "Manage Jenkins" on the left panel.
2. Click on the "Plugins" section.
3. Go to "Available plugins".
4. Search for: 'Blue Ocean', 'Docker plugin', 'Docker', 'Kubernetes plugin', 'Pipeline', 'Email plugin'. Note that the 'Multibranch Workflow' plugin is no longer supported, and you need to use the 'Multibranch Pipeline' job type instead.

### Setting up a Pipeline Job

1. On the Dashboard, click "+ New Item".
2. Select 'Multibranch Pipeline', give it a name, and click 'ok'.
3. Provide a display name and description as per your preference.
4. Under 'Branch Sources', select Git.
5. Enter this project URL [repo](https://github.com/MadMax-G/final_project.git) and provide the credentials configured in the previous steps.

The pipeline will look for a file named "Jenkinsfile" in the main branch of the specified repository.
