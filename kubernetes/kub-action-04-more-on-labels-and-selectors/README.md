If you want to **create mulitple resouces**

```sh
kubectl apply -f=<DEPLOYMENT_FILE_NAME.yaml>,<SERVICE_FILE_NAME.yaml>
(Or)
kubectl apply -f=<DEPLOYMENT_FILE_NAME.yaml> -f=<SERVICE_FILE_NAME.yaml>
```

# More on Labes & Selectors

We can also delete resources by selector. By adding the `-l` flag for label, you can select objects by lagel, which should be deleted.

```sh
kubectl delete <RESCOURCE>,<RESOURCE> -l <METADATA_LABEL_KEY=METADATA_LABEL_VALUE>
```

```sh
kubectl delete  deployments,services -l group=example

deployment.apps "second-app-deployment" deleted from default namespace
service "backend" deleted from default namespace
```

---

Sure 👍 Let’s break **`livenessProbe`** down in **simple, practical terms**, using _your exact YAML_ as context.

---

## What is a `livenessProbe`?

A **liveness probe** tells **Kubernetes how to check if your container is still “alive”**.

👉 If the probe **fails repeatedly**, Kubernetes assumes:

> “This container is stuck or unhealthy”

and it will **automatically restart the container**.

This is very useful when:

- Your app is running but **frozen / deadlocked**
- The process didn’t crash, but **stopped responding**

---

## Your `livenessProbe` configuration

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8080
  periodSeconds: 10
  initialDelaySeconds: 5
```

Let’s explain **line by line**.

---

## 1️⃣ `httpGet`

```yaml
httpGet:
  path: /
  port: 8080
```

Kubernetes will:

- Send an **HTTP GET request**
- To: `http://<pod-ip>:8080/`

### What Kubernetes expects

- **HTTP 200–399** → ✅ container is healthy
- **HTTP 400+ / timeout / connection refused** → ❌ failure

So your Node app **must be listening on port 8080** and respond on `/`.

---

## 2️⃣ `initialDelaySeconds: 5`

```yaml
initialDelaySeconds: 5
```

➡️ Kubernetes waits **5 seconds after the container starts**
➡️ Then it runs the first liveness check

### Why this matters

Most apps:

- Need time to start (Node, DB connections, configs)

Without this:

- Kubernetes may think the app is dead **before it even starts**

---

## 3️⃣ `periodSeconds: 10`

```yaml
periodSeconds: 10
```

➡️ Kubernetes checks the container **every 10 seconds**

So the check schedule is:

```
Start container
↓ wait 5s
Check #1
↓ 10s
Check #2
↓ 10s
Check #3
...
```

---

## What happens if the probe fails?

If the probe:

- Fails **several times in a row** (default: 3)

Kubernetes will:

1. ❌ Mark the container as unhealthy
2. 🔁 **Kill the container**
3. 🚀 **Restart it automatically**

⚠️ Only the **container** is restarted — not the Pod object.

---

## Simple real-world example

Think of it like a **heartbeat monitor** ❤️

- Kubernetes: “Are you alive?”
- App: “Yes” → HTTP 200
- App freezes → no response
- Kubernetes: “No heartbeat → restart!”

---

## Liveness vs Readiness (important difference)

| Probe Type         | Purpose                                                               |
| ------------------ | --------------------------------------------------------------------- |
| **livenessProbe**  | Is the container alive? Restart if not                                |
| **readinessProbe** | Is the container ready to receive traffic? Remove from Service if not |

⚠️ A failing **liveness probe restarts the container**
⚠️ A failing **readiness probe does NOT restart it**

---

## Common best practices (important)

### ✅ Good

- Use `/health` or `/live` endpoint
- Keep logic **simple and fast**

### ❌ Avoid

- Heavy DB checks in liveness probe
- Expensive operations

Bad example:

```text
Check DB → Check cache → Call external API ❌
```

Good example:

```text
Return 200 if app loop is running ✅
```

---

## Summary (one glance)

- `livenessProbe` = **“Should Kubernetes restart this container?”**
- Uses HTTP GET to `/` on port `8080`
- Starts checking after **5s**
- Checks every **10s**
- Failing repeatedly → **container restart**

---
