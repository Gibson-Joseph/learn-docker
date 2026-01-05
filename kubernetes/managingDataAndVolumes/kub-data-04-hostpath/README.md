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
   SSH into the Kubernetes node

```sh
minikube ssh
```

```sh
ls /data
```

---

## 🧠 One-line summary

> `hostPath` mounts a directory from the Kubernetes node into Pods,
> allowing data to persist across Pod restarts but tying it to a single node.

---

# HostPath PersistentVolume (PV)

This README explains the Kubernetes **PersistentVolume** defined in `host-pv.yaml`, what each field means, and when you should (and should not) use a **hostPath** volume.

---

## What is a PersistentVolume (PV)?

A **PersistentVolume (PV)** is a cluster-level storage resource managed by Kubernetes. It is:

- **Independent of Pods**
- Created by a **cluster administrator** (or once per cluster)
- Later **claimed by Pods** using a **PersistentVolumeClaim (PVC)**

Pods do not talk to PVs directly — they talk to PVCs.

---

## Use Case of `hostPath` PV

A `hostPath` volume uses a **directory from the node’s filesystem** as storage.

✅ Good for:

- Local development
- Learning Kubernetes
- Single-node clusters (Minikube, Kind)

❌ Not recommended for:

- Production environments
- Multi-node clusters
- High availability workloads

---

## YAML Explained (Line by Line)

```yaml
apiVersion: v1
kind: PersistentVolume
```

- Defines a **PersistentVolume** resource
- Uses core Kubernetes API (`v1`)

---

```yaml
metadata:
  name: host-pv
```

- Unique name of the PersistentVolume inside the cluster

---

```yaml
spec:
```

- The **actual configuration** of the storage

---

### Storage Capacity

```yaml
capacity:
  storage: 1Gi
```

- Total storage available in this PV
- PVCs **cannot request more than this**
- Used by Kubernetes for **binding decisions**

---

### Volume Mode

```yaml
volumeMode: Filesystem
```

Defines how the storage is exposed to the Pod:

- `Filesystem` → Mounted as a directory (most common)
- `Block` → Raw block device (advanced use cases like databases)

---

### Access Modes

```yaml
accessModes:
  - ReadWriteOnce
```

Defines **how Pods can access the volume**:

- `ReadWriteOnce (RWO)`

  - Mounted as read-write by **one node only**
  - Multiple Pods can use it **if they run on the same node**

Other options (commented):

- `ReadOnlyMany (ROX)` → Read-only by many nodes
- `ReadWriteMany (RWX)` → Read-write by many nodes (requires special storage)

---

### hostPath Configuration

```yaml
hostPath:
  path: /data
  type: DirectoryOrCreate
```

- Uses the node’s local directory: `/data`
- If `/data` does not exist, Kubernetes **creates it automatically**

⚠️ Important:

- Data lives **only on that node**
- If the Pod moves to another node, data is lost

---

## Why PV Is Defined Only Once

- PVs are **not Pod-specific**
- Many Pods (via PVCs) can reuse the same PV (based on access mode)
- Encourages **separation of concerns**:

| Role      | Responsibility    |
| --------- | ----------------- |
| Admin     | Creates PV        |
| Developer | Creates PVC & Pod |

---

## Typical Flow

1. **Admin creates PersistentVolume (PV)**
2. **Developer creates PersistentVolumeClaim (PVC)**
3. Kubernetes binds PVC → PV
4. Pod uses the PVC

```text
Pod → PVC → PV → Host filesystem (/data)
```

---

## Example PVC (For Reference)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: host-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

- PVC requests `500Mi`
- Kubernetes binds it to `host-pv` (1Gi available)

---

## Key Takeaways

- `hostPath` = node-local storage
- PV is cluster-scoped and created once
- PVC is namespace-scoped and used by Pods
- Suitable for **learning & development only**

---

## References

- Kubernetes Persistent Volumes:
  [https://kubernetes.io/docs/concepts/storage/persistent-volumes/](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- Storage Types Comparison:
  [https://www.computerweekly.com/feature/Storage-pros-and-cons-Block-vs-file-vs-object-storage](https://www.computerweekly.com/feature/Storage-pros-and-cons-Block-vs-file-vs-object-storage)

---
