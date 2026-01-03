# Kubernetes Volumes – `hostPath`

## 📌 What is a Kubernetes Volume?

By default, **containers are ephemeral**:

- If a container restarts → data is lost
- If a Pod is recreated → data is lost

A **Kubernetes Volume** allows data to be:

- Stored outside the container filesystem
- Shared between Pods or containers
- Persisted beyond container restarts

---

## 📦 What is `hostPath`?

`hostPath` is a volume type that **mounts a directory from the Kubernetes node (host machine)** into a Pod.

> Think of `hostPath` as a **bind mount** from Docker:
>
> ```
> Host machine folder ↔ Pod container folder
> ```

---

## 🧠 Key idea

- Data is stored on the **node’s filesystem**
- All Pods running on the **same node** can access the same data
- Data survives **Pod restarts**
- Data is tied to the **node**, not the cluster

---

## 🧱 Example: Deployment using `hostPath`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: story-deployment
spec:
  replicas: 2
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
          hostPath:
            path: /data
            type: DirectoryOrCreate
```

---

## 🔍 How this works (step by step)

### 1️⃣ Node directory

- Kubernetes checks if `/data` exists on the node
- If it does not exist → it is **created automatically**

```yaml
type: DirectoryOrCreate
```

---

### 2️⃣ Volume creation

- The directory `/data` on the node becomes a volume

---

### 3️⃣ Volume mount

```yaml
mountPath: /app/story
```

Inside the container:

```
/app/story  →  /data (on the node)
```

---

### 4️⃣ Multiple Pods

Since `replicas: 2`:

- Two Pods are created
- If both Pods run on the **same node**:

  - They share the **same `/data` directory**

---

## 🔄 Data lifecycle

| Event                     | Data status           |
| ------------------------- | --------------------- |
| Container restart         | ✅ Data survives      |
| Pod restart               | ✅ Data survives      |
| Pod deletion              | ✅ Data survives      |
| Node deletion             | ❌ Data lost          |
| Pod moves to another node | ❌ Data not available |

---

## ⚠️ Important limitations (VERY IMPORTANT)

❌ **Node-specific**

- If the Pod is rescheduled to another node → data is not there

❌ **Not suitable for production**

- Not portable
- Not safe for multi-node clusters
- Not cloud-friendly

---

## ✅ When to use `hostPath`

Use `hostPath` when:

- Learning Kubernetes
- Local development (Minikube / Kind / Docker Desktop)
- You need quick shared storage
- You want to understand how volumes work

---

## ❌ When NOT to use `hostPath`

Do NOT use `hostPath` for:

- Databases
- User uploads
- Production workloads
- Multi-node clusters

---

## 🆚 `hostPath` vs `emptyDir`

| Feature               | emptyDir     | hostPath       |
| --------------------- | ------------ | -------------- |
| Lifetime              | Pod lifetime | Node lifetime  |
| Survives Pod deletion | ❌           | ✅             |
| Shared across Pods    | ❌           | ✅ (same node) |
| Production ready      | ❌           | ❌             |
| Beginner friendly     | ✅           | ⚠️             |

---

## 🧪 How to test it


1. Delete the Pod:

```sh
kubectl delete pod <pod-name>
```

2. New Pod starts:

- File still exists ✅

3. Check node filesystem:

```sh
ls /data
```

---

## 🧠 One-line summary

> `hostPath` mounts a directory from the Kubernetes node into Pods,
> allowing data to persist across Pod restarts but tying it to a single node.

---
