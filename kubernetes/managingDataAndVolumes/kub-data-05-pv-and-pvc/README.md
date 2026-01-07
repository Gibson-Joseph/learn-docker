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

## What is a PersistentVolumeClaim (PVC)?

A **PersistentVolumeClaim (PVC)** is a **request for storage** made by a Pod.

Think of it like this:

> **PV = actual storage (created by admin)** > **PVC = request for storage (created by developer)** > **Pod = uses the storage via PVC**

---

## Simple Analogy 🧠

- **PersistentVolume (PV)** → A hard disk in a data center
- **PersistentVolumeClaim (PVC)** → A request form saying:

  > “I need 500MB of disk, readable & writable”

- **Pod** → The application that uses that disk

---

## Why PVC Exists

PVC **decouples Pods from storage assumptions**.

Pods don’t need to know:

- Where the storage comes from
- What type of disk it is
- Which node it lives on

They just say:

> “Give me storage with these requirements”

Kubernetes finds a matching PV and binds it.

---

## What a PVC Defines

A PVC typically specifies:

1. **How much storage is needed**
2. **How it will be accessed**
3. _(Optionally)_ which storage class to use

Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: host-pvc
spec:
  volumeName: host-pv
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

---

## How PVC Works (Step-by-Step)

1. PVC is created
2. Kubernetes looks for a PV that:

   - Has **enough capacity**
   - Supports the **requested access mode**

3. PVC gets **bound** to that PV
4. Pod mounts the PVC
5. Data persists even if the Pod restarts

```text
Pod → PVC → PV → Storage (disk / hostPath / cloud volume)
```

---

## PVC Scope (Important)

- **PVC is namespace-scoped**
- **PV is cluster-scoped**

That’s why:

- Multiple namespaces can use the same PV (via different PVCs)
- Pods only see PVCs, never PVs directly

---

## What Happens If Pod Dies?

- Pod deleted ❌
- PVC still exists ✅
- Data still exists ✅
- New Pod can reuse the same PVC

That’s the **main benefit of persistent storage**.

---

## PVC vs EmptyDir (Quick Comparison)

| Feature          | emptyDir     | PVC          |
| ---------------- | ------------ | ------------ |
| Pod restart      | ❌ data lost | ✅ data kept |
| Pod delete       | ❌ data lost | ✅ data kept |
| External storage | ❌           | ✅           |
| Production ready | ❌           | ✅           |

---

## Key Takeaways ✅

- PVC is a **storage request**
- Pods **never talk to PVs directly**
- PVC makes storage **portable, reusable, and persistent**
- Essential for **databases, uploads, logs, stateful apps**

If you want, I can next:

- Show **PVC → Pod mounting example**
- Explain **PVC binding states**
- Compare **Static PV vs Dynamic Provisioning**

---

## To check the stroage class by following commend

The storage class is another concpetes, which we have in kubernetes to give administrators fine grain cotrol over how stroage is managed and how volumes can be configured. It's an advanced concept.

```sh
kubectl get sc
```

```sh
kubectl get sc
(Or)
kubectl get storageclass

NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  18d # This is defalut stroage class
```

### To create our PV and PVC Recource:

```sh
$ kubectl apply -f host-pv.yaml
persistentvolume/host-pv created
```

```sh
$ kubectl apply -f host-pvc.yaml
persistentvolumeclaim/host-pvc created
```

```sh
$ kubectl apply -f deployment.yaml
deployment.apps/story-deployment created
```

```sh
$ kubectl apply -f service.yaml
service/story-service created
```

### To get Persistent Volume

```sh
$ kubectl get pv
NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM              STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
host-pv   1Gi        RWO            Retain           Bound    default/host-pvc   standard       <unset>                          3m58s
```

### To get PersistentClaim Volume

```sh
$ kubectl get pvc
NAME       STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
host-pvc   Bound    host-pv   1Gi        RWO            standard       <unset>                 3m45s
```
