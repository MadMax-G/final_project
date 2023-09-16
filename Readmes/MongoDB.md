# MongoDB Setup on Kubernetes using Argo CD

Follow this README for a step-by-step guide on how to set up MongoDB on a Kubernetes cluster with the Argo CD pipeline.

### Creation of Namespace 

Begin by initiating a namespace in your existing cluster.

```bash
kubectl create ns data
```

This command formulates a namespace labeled "data" inside your cluster, to be employed in the succeeding MongoDB deployment.

### Argo CD Application Configuration

Following successful login to the Argo CD UI, locate and select the "+ NEW APP" button (found in the screen's top left area). Complete the required fields as follows:

- **Application Name**: mongo-application (or any name you prefer)
- **Project**: default
- **Source URL**: Specify the URL of the Git repository possessing your Kubernetes manifests or Helm chart for MongoDB deployment. For example [Git Repo](https://github.com/MadMax-G/final_project).
- **Path**: helmdb
- **Cluster URL**: It's auto-filled with the URL of the cluster hosting your Argo CD.
- **Namespace**: data

Upon filling all necessary fields, hit the "CREATE" button.

### Application Syncing in Argo CD

Post creation of the application, begin the deployment by selecting the "Sync" button as seen in the display of application details. This process applies both the Service and Deployment manifest files into your cluster from your Git repository. As a result, a MongoDB Pod and a LoadBalancing Service accessible on the internet via port '27017' is created.

To view the created Pod, services, and Persistent Volume Claims (PVCs), simply click on the application name situated in the Argo CD dashboard. This action reveals a diagram showing the relationships existing among the various resources related to your application.

With these steps duly followed, you successfully deployed an instance of MongoDB on your cluster utilizing Argo CD. Congratulations!
