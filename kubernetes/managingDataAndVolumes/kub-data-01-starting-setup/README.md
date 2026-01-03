# Managing Data & Volumns with Kuernetes

Here’s a **clear, beginner-friendly `README.md`** you can put directly into your repo for **Kubernetes Volumes (emptyDir)**.
I’ve written it assuming **you’re learning Kubernetes**, not production yet.

---

# Kubernetes Volumes – `emptyDir`

## 📌 What is a Volume in Kubernetes?

In Kubernetes, **containers inside a Pod are ephemeral**:

- If a container restarts → data is lost
- If a Pod is deleted → data is lost

A **Volume** provides **shared storage** for containers inside a Pod and can persist data **while the Pod is running**.

---

## 📦 What is `emptyDir`?

`emptyDir` is the **simplest type of Kubernetes volume**.

- Created **when the Pod starts**
- Deleted **when the Pod is removed**
- Shared between all containers in the same Pod
- Stored on:

  - Node disk (default)
  - Memory (if configured)

> Think of `emptyDir` as a **temporary folder for a Pod**

---

## 🔍 Use case of `emptyDir`

Use `emptyDir` when:

- You need **temporary data storage**
- You want to **share files between containers**
- Data does **not need to survive Pod deletion**

Common examples:

- Logs
- Cache
- Temporary uploads
- Runtime generated files

---

## 🧱 Example: Deployment with `emptyDir`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: story
  template:
    metadata:
      labels:
        app: story
    spec:
      containers:
        - name: story
          image: gibsonjoseph/kub-data-demo:1
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          emptyDir: {}
```

---

## 🧠 How this works (step by step)

### 1️⃣ Pod starts

- Kubernetes creates an empty directory on the node

### 2️⃣ Volume is mounted

```yaml
mountPath: /app/story
```

- Inside the container, `/app/story` is backed by the volume

### 3️⃣ App writes data

- Any file written to `/app/story` goes into the volume

### 4️⃣ Container restarts

- Data **remains** (Pod is still running)

### 5️⃣ Pod is deleted

- Volume and all data are **deleted**

---

## 🔗 Volume vs VolumeMount

### `volumes`

Defined at **Pod level**

```yaml
volumes:
  - name: story-volume
    emptyDir: {}
```

### `volumeMounts`

Defined at **container level**

```yaml
volumeMounts:
  - mountPath: /app/story
    name: story-volume
```

📌 **The names must match**

---
