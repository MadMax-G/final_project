# Setting Up Prometheus and Grafana on Kubernetes via Argo CD

This README file presents steps to set up Prometheus and Grafana on a Kubernetes cluster with the use of Argo CD.

## Prerequisites
- Existing Argo CD installation on your cluster.

## Installing Prometheus

### Create a Namespace

Initiate by creating a namespace in your cluster with this command:

```bash
kubectl create ns observability
```

This command establishes a namespace named "observability" in your cluster, which will constitute the environment for the Prometheus deployment.

### Configure the Argo CD Application for Prometheus

Upon gaining access into the Argo CD UI, locate the "+ NEW APP" button at the top-left of the screen and click on it. Complete the required fields as follows:

- **Application Name**: prometheus
- **Project**: default
- **Source**: Adjust source to HELM, then insert this [link](https://prometheus-community.github.io/helm-charts)
- **Chart**: prometheus
- **Cluster URL**: This automatically fills up with the URL of the cluster running Argo CD.
- **Namespace**: observability

After accurately completing these fields, click the "CREATE" button.

### Synchronize the Argo CD Application

Upon successful creation of the application, you can kickstart the synchronization by selecting the "Sync" button in the application details view. This operation will apply the Prometheus Helm chart to your cluster, bringing Prometheus deployment into effect.

## Installing Grafana

As for Grafana, we'll be incorporating a distinctive approach based on this [guide](https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/). Here, the deployment and service for Grafana will be manually created within the same namespace as Prometheus.

### Create a Deployment and Service

Create a new file named `grafana.yaml` and insert the following content into it:

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: grafana
  name: grafana
spec:
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      securityContext:
        fsGroup: 472
        supplementalGroups:
          - 0
      containers:
        - name: grafana
          image: grafana/grafana:latest
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 3000
              name: http-grafana
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /robots.txt
              port: 3000
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 2
          livenessProbe:
            failureThreshold: 3
            initialDelaySeconds: 30
            periodSeconds: 10
            successThreshold: 1
            tcpSocket:
              port: 3000
            timeoutSeconds: 1
          resources:
            requests:
              cpu: 250m
              memory: 750Mi
          volumeMounts:
            - mountPath: /var/lib/grafana
              name: grafana-pv
      volumes:
        - name: grafana-pv
          persistentVolumeClaim:
            claimName: grafana-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  ports:
    - port: 3000
      protocol: TCP
      targetPort: http-grafana
  selector:
    app: grafana
  sessionAffinity: None
  type: LoadBalancer
```

Apply the manifest to your Kubernetes cluster:

```bash
kubectl apply -f grafana.yaml --namespace=observability
```

### Confirm the Deployment

To verify the deployment status of each object, input and run the following commands:

- For PVC: `kubectl get pvc --namespace=observability -o wide`
- For Deployment: `kubectl get deployments --namespace=observability -o wide`
- For Service: `kubectl get svc --namespace=observability -o wide`

## Gaining Access to Grafana

To obtain the external IP for Grafana, input the following command:

```bash
kubectl get svc --namespace=observability
```

The output will contain the LoadBalancer IP for Grafana. Copy this IP and enter it in your web browser followed by ":3000" (e.g., `http://<LoadBalancer IP>:3000`).

On the Grafana login page, use 'admin' for both username and password fields.

## Adding Prometheus as a Data Source in Grafana

Upon gaining access into Grafana, navigate to the home page and select the "Add your first data source" option. From the list of available options, opt for 'Prometheus'.

Back in your cluster, input the following command to obtain the cluster IP for the Prometheus server:

```bash
kubectl get svc --namespace=observability
```

Duplicate the ClusterIP that corresponds to the Prometheus server and paste it into the URL field in the Grafana data source configuration settings for Prometheus. 

Scroll down and click on "Save & Test", after which, navigate to the 'Explore' view.

In the explore view, select a metric you desire to monitor, input it into the query field, and run the query. This enables you to start monitoring your cluster with Grafana and Prometheus.

Congratulations! You have successfully set up a monitoring solution with Prometheus and Grafana on your Kubernetes cluster with the use of Argo CD.
