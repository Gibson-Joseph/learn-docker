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

# Scaling in Action

### Scale up the pods

```sh
kubectl scale deployment/<DEPLOYMENT_APP> --replicas=<NUMBER>
```

```sh
kubectl scale deployment/first-app --replicas=3

deployment.apps/first-app scaled
```

Now you can see the 3 pods

```sh
kubectl get pods

NAME                         READY   STATUS    RESTARTS        AGE
first-app-6f65c97f86-8wlbn   1/1     Running   0               27s
first-app-6f65c97f86-nmkhr   1/1     Running   3 (8m19s ago)   87m
first-app-6f65c97f86-ql7zl   1/1     Running   0               27s
```

### Scale down the pods

```sh
kubectl scale deployment/first-app --replicas=1

deployment.apps/first-app scaled
```

```sh
kubectl get pods

NAME                         READY   STATUS        RESTARTS      AGE
first-app-6f65c97f86-8wlbn   1/1     Terminating   4 (68s ago)   6m34s
first-app-6f65c97f86-nmkhr   1/1     Running       7 (68s ago)   93m
first-app-6f65c97f86-ql7zl   1/1     Terminating   4 (65s ago)   6m34s
```

Now you can see that our two pods are **terminating**

```sh
kubectl get pods

NAME                         READY   STATUS    RESTARTS        AGE
first-app-6f65c97f86-nmkhr   1/1     Running   7 (4m10s ago)   96m
```

# Updating Deployments

A Deployment manages Pods and allows you to update your application without downtime using rolling updates

```sh
kubectl set image deployment/<DEPLOYMENT_NAME> <CONTAINER_NAME>=<IMAGE_NAME>
```

```sh
kubectl set image deployment/first-app kub-first-app=gibsonjoseph/kub-first-app:2

deployment.apps/first-app image updated
```

### Check Rollout Status

```sh
kubectl rollout status deployment/<DEPLOYMENT_NAME>
```

```sh
kubectl rollout status deployment/first-app

deployment "first-app" successfully rolled out
```

# Deployment Rollbacks & History

Here I have used the image that never exists

```sh
kubectl set image deployment/first-app kub-first-app=gibsonjoseph/kub-first-app:3 # NOTE: This image is not exists

deployment.apps/first-app image updated
```

To check the status

```sh
kubectl rollout status deployment/first-app

Waiting for deployment "first-app" rollout to finish: 1 old replicas are pending termination...
```

NOTE: **kubernetes cannot kill the old Pod yet because the new Pod is NOT healthy**

```sh
kubectl get pods

NAME                         READY   STATUS             RESTARTS   AGE
first-app-5fc5568b94-77rjt   1/1     Running            0          16m
first-app-76f46bbcb7-vbpng   0/1     ImagePullBackOff   0          6m59s
```

## Rollback the problematic deployment

This will undo the latest deployment

```sh
kubectl rollout undo deployment<DEPLOYMENT_NAME>

```

```sh
kubectl rollout undo deployment/first-app
deployment.apps/first-app rolled back
```

When we chack the pod again, we can notice the problematic pod is gone

```sh
kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
first-app-5fc5568b94-77rjt   1/1     Running   0          19m
```

As well we are back to successful status

```sh
kubectl rollout status deployment/first-app

deployment "first-app" successfully rolled out
```

## History

To check our deployment history

```sh
kubectl rollout history deployment/<DEPLOYMENT_NAME>
```

```sh
kubectl rollout history deployment/first-app

deployment.apps/first-app
REVISION  CHANGE-CAUSE
1         <none>
3         <none>
4         <none>
```

Here we can see the different deployment that we can made. We can also have details about the deployment.

```sh
kubectl rollout history deployment/<DEPLOYMENT_NAME> --revision=<REVISION_IDENTIFIERS>
```

```sh
kubectl rollout history deployment/first-app --revision=3

deployment.apps/first-app with revision #3
Pod Template:
  Labels:       app=first-app
        pod-template-hash=76f46bbcb7
  Containers:
   kub-first-app:
    Image:      gibsonjoseph/kub-first-app:3
    Port:       <none>
    Host Port:  <none>
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
  Node-Selectors:       <none>
  Tolerations:  <none>
```

Here we can see which image was used and couple of other things here.

### To go back to previous deployment

```sh
kubectl rollout undo deployment/<DEPLOYMENT_NAME> --to-revision=<REVISION_IDENTIFIERS>
```

```sh
kubectl rollout undo deployment/first-app --to-revision=1

deployment.apps/first-app rolled back
```

```sh
kubectl get pods

NAME                         READY   STATUS        RESTARTS   AGE
first-app-5fc5568b94-77rjt   1/1     Terminating   0          31m
first-app-6f65c97f86-8stw6   1/1     Running       0          26s
```

### NOTE: Rollback is not working for me; need to check that again on sometime

# To restart

```sh
kubectl rollout restart deployment/first-app

deployment.apps/first-app restarted
```

# To delete the service

```sh
kubectl delete service first-app

service "first-app" deleted from default namespace
```

# To delete the deployment

```sh
kubectl delete deployment first-app

```
