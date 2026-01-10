# **Using DNS for Pod-to-Pod Communication in Kubernetes**

---

## 📌 What is DNS in Kubernetes?

Kubernetes provides a **built-in DNS system (CoreDNS)** that allows Pods to discover and communicate with each other **using names instead of IP addresses**.

Instead of doing this ❌:

```bash
http://10.244.1.12:3000
```

You do this ✅:

```bash
http://users-service
```

DNS automatically resolves the name to the correct IP.

---

## 🧠 Why DNS Is the Best Way for Pod Communication

Pods are **ephemeral**:

- They restart
- They scale
- Their IPs change

DNS solves this by:

- Providing **stable names**
- Automatically updating when Pods change
- Load-balancing traffic

👉 This is why **DNS is the default & recommended method** in Kubernetes.

🔹 Core Concept

👉 Pods never talk to Pods directly in production.
👉 Pods talk to Services using DNS names.

```sh
Pod → Service DNS → Service IP → Backend Pods
```

---

## 🔹 How Kubernetes DNS Works (High Level)

1. A Pod makes a request using a service name
2. The request goes to **CoreDNS**
3. CoreDNS resolves the service name to a **ClusterIP**
4. `kube-proxy` forwards traffic to one of the backend Pods

---

## 🔹 CoreDNS (Important Component)

CoreDNS runs as Pods in:

```bash
$ kubectl get namespace
NAME                   STATUS   AGE
kube-system            Active   21d
... and so on
```

Check it:

```bash
kubectl get pods -n kube-system | grep coredns
(Or)
kubectl get pods -n kube-system

NAME                               READY   STATUS    RESTARTS         AGE
coredns-66bc5c9577-jk7nq           1/1     Running   6 (3h30m ago)    21d
coredns-66bc5c9577-r78j6           1/1     Running   6 (3h30m ago)    21d

```

If CoreDNS is down → **service discovery breaks**.

---

## 🔹 Basic Service DNS Name

For a Service:

```yaml
metadata:
  name: users-service
```

### DNS name inside the same namespace:

```sh
users-service
```

That’s it. No IPs. No ports (default port used).

---

## 🔹 Full DNS Format (Fully Qualified Domain Name – FQDN)

```sh
<service-name>.<namespace>.svc.cluster.local
```

Example:

```sh
users-service.default.svc.cluster.local
```

### When to use FQDN?

- Cross-namespace communication
- Explicit resolution
- Debugging

---
