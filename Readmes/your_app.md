# Application Deployment on Kubernetes via Argo CD

This README guides you through the process of deploying an application on a Kubernetes cluster utilizing Argo CD.

### Create a Namespace

Begin by creating a namespace in your cluster with this command:

```bash
kubectl create ns applications
```

This command generates a namespace named "applications" in your cluster, where your application deployment will happen.

### Configure the Argo CD Application

Once logged into the Argo CD UI, navigate to and click the "+ NEW APP" button in the top-left corner. Fill out the following fields:

- **Application Name**: input-app-name (or any other name you prefer).
- **Project**: default
- **Source URL**: Input your Git repository URL containing your Kubernetes manifests or Helm chart for the application deployment. Example [Git Repo](https://github.com/MadMax-G/final_project).
- **Path**: helmapp
- **Cluster URL**: This will auto-fill with the URL of the cluster running Argo CD.
- **Namespace**: applications

Upon completion of these fields, click the "CREATE" button.

### Argo CD Application Sync

Upon the application creation, trigger the deployment by selecting the "Sync" button from the view of the application details. This action applies the deployment and service manifest files from your Git repository to the cluster, creating an application pod and a LoadBalancer service accessible over the internet via port '9000.

### View the Application Resources

To overview the created pods and services, select the application name within the Argo CD dashboard. This selection reveals a diagram exhibiting the relationship amongst the multiple resources associated with your application.

### Access the Application

To get your application's external IP, select the service resource within the 'Argo CD application details' view. The external IP is under the 'HOSTNAMES' category.

Now you can access your application using this external IP and port 9000. Congratulations! You've successfully deployed an application on your Kubernetes cluster using Argo CD!
