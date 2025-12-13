# Kubernetes

[Official website & docs](https://kubernetes.io/docs/home/)

## What is Kubernetes? (K8s)

**Kubernetes** is a tool that helps you **run, manage, and scale applications** that are packed inside **containers** (usually Docker containers).
👉 Think of Kubernetes as a **manager for containers**.

# Kubernetes: Required setup & installations steps

### Why do we need Kubernetes?

Imagine this situation:

- You have 1 or more applications
- Each app runs inside a Docker container
- You want:
  - App to stay running (even if it crashes)
  - Multiple copies of the app for more users
  - Easy updates without downtime
  - Automatic scaling when traffic increases

Doing this manually is hard.

➡️ Kubernetes does all of this for you automaticall

---

## Core concepts (very basic)

### 1. Container

A **container** packages your app + everything it needs to run.

Example:

- Frontend app
- Backend API
- Database

All run in separate containers.

---

### 2. Pod

A **Pod** is the **smallest unit in Kubernetes**.

- A Pod usually contains **1 container**
- Kubernetes does **not manage containers directly**
- It manages **Pods**

📦 Pod = wrapper around container

---

### 3. Node

A **Node** is a **machine** (VM or physical server).

- It runs Pods
- One node can run many Pods

---

### 4. Cluster

A **Cluster** is a group of nodes.

- Kubernetes runs on a **cluster**
- Your apps run inside this cluster

---

## MiniKube setup

[Minikube installation for linux](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)

**Minikube** is a tool that lets you **run Kubernetes locally on your machine**.

**In simple words**
_Minikube = a local Kubernetes cluster for learning, testing, and development_

Instead of setting up a full Kubernetes cluster in the cloud (AWS, GCP, etc.), Minikube:

- Creates a single-node Kubernetes cluster
- Runs it using a VM or container (Docker, Podman, VirtualBox, etc.)
- Is perfect for beginners and local testing

**What Minikube does**

- Starts a local Kubernetes cluster
- Runs core Kubernetes components (API server, scheduler, controller, etc.)
- Lets you deploy apps exactly like you would in real Kubernetes

```sh
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

Test to ensure the version you installed is up-to-date:

```sh
minikube version

minikube version: v1.37.0
commit: 65318f4cfff9c12cc87ec9eb8f4cdd57b25047f3
```

[minikube can be deployed as a VM, a container, or bare-metal.](https://minikube.sigs.k8s.io/docs/drivers/)

**Start a cluster using the docker driver:**

The **Docker driver** allows you to install **Kubernetes** into an existing Docker install.

```sh
minikube start --driver=docker
```

To make docker the default driver:

```sh
minikube config set driver docker
```

To check the minikube status

```sh
minikube status

minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

To see the minikube dashboard in your browser

```sh
minikube dashboard
```

---

# Kubectl

[Kubectl installtion for linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

**kubectl** (pronounced kube-control) is the **command-line tool to talk to Kubernetes**.

**In simple words**
kubectl = remote control for Kubernetes

It does **not create a cluster**.
It only:

- Communicates with a Kubernetes cluster (Minikube, cloud cluster, etc.)
- Sends instructions like deploy app, check pods, delete service, etc.

**What kubectl does**

- Deploy applications
- Inspect cluster state
- Manage resources (Pods, Services, Deployments, ConfigMaps, etc.)

Test to ensure the version you installed is up-to-date:

```sh
kubectl version --client

Client Version: v1.34.3
Kustomize Version: v5.7.1
```

Or use this for detailed view of version:

```sh
 kubectl version --client --output=yaml

clientVersion:
  buildDate: "2025-12-12T23:00:56Z"
  compiler: gc
  gitCommit: df11db1c0f08fab3c0baee1e5ce6efbf816af7f1
  gitTreeState: clean
  gitVersion: v1.34.3
  goVersion: go1.24.11
  major: "1"
  minor: "34"
  platform: linux/amd64
kustomizeVersion: v5.7.1
```
