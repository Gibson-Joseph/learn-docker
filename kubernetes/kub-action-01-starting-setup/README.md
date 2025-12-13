# Imperative Approch

## To create a new deployment object

**_NOTE_ :** Before creating the deployment you have to push your image into the docker hub

```sh
kubectl create deployment <deployment_name> --image=<your_image_name>
```

```sh
kubectl create deployment first-app --image=kub-first-app
```

## To check the deployment

```sh
kubectl get deployments

NAME        READY   UP-TO-DATE   AVAILABLE   AGE
first-app   0/1     1            0           14s
```

# To check the pods

```sh
kubectl get pods

NAME                        READY   STATUS             RESTARTS   AGE
first-app-7bc4c5754-frjcc   0/1     ImagePullBackOff   0          82s
```

# To delete the deployment

```sh
kubectl delete deployment <deployment_name>
```

```sh
kubectl delete deployment first-app

deployment.apps "first-app" deleted from default namespace
```

---

# To create Service

**A Service** in Kubernetes is used to **expose your application (Pods)** so that it can be accessed either **inside the cluster or from outside.**

Pods are temporary and their IPs change.
A Service gives them a **stable IP and DNS name**.

## 🔹 Types of Kubernetes Services

### 1️⃣ ClusterIP (Default)

- Accessible **only inside the Kubernetes cluster**
- Used for **internal communication** (backend → database, frontend → backend)

📌 Example use case:

- Backend API used only by frontend running in the same cluster

### 2️⃣ NodePort

- Exposes the service on **each node’s IP**
- Accessible using:

```sh
<NodeIP>:<NodePort>
```

- NodePort range: **30000–32767**

📌 Example use case:

- Quick testing without ingress or load balancer

### 3️⃣ LoadBalancer

- Exposes the service **externally**
- Works with **cloud providers** (AWS, GCP, Azure)
- Creates an **external IP**

📌 Example use case:

- Production applications that must be accessible from the internet

```sh
kubectl expose deployment <DEPLOYMENT_NAME> --type=<SERVICE_TYPE> --port=<SERVICE_PORT>
```

**Create a ClusterIP Service**

```sh
kubectl expose deployment first-app --type=LoadBalancer --port=8080

service/first-app exposed
```

# To get all services

```sh
kubectl get services

NAME         TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
first-app    LoadBalancer   10.99.17.7   <pending>     8080:30355/TCP   37s
kubernetes   ClusterIP      10.96.0.1    <none>        443/TCP          123m # This is default one, not created by us
```

You use `minikube service` because **Minikube does NOT give you a real external IP** like cloud Kubernetes (AWS/GCP/Azure).

So Minikube **creates a tunnel / proxy** to let you access the service from your local machine.

```sh
minikube service <DEPLOYMENT_NAME>
```

```sh
minikube service first-app

┌───────────┬───────────┬─────────────┬───────────────────────────┐
│ NAMESPACE │   NAME    │ TARGET PORT │            URL            │
├───────────┼───────────┼─────────────┼───────────────────────────┤
│ default   │ first-app │ 8080        │ http://192.168.49.2:30355 │
└───────────┴───────────┴─────────────┴───────────────────────────┘
🎉  Opening service default/first-app in default browser...

```

You use minikube **service because** Minikube does not have a real cloud load balancer, so it creates a local tunnel to expose your service.

---
