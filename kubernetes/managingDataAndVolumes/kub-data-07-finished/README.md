# Environment Variables & ConfigMaps in Kubernetes

## Overview

In Kubernetes, applications often need configuration values such as:

- Folder names
- Database URLs
- Feature flags
- API endpoints

Hard-coding these values inside container images is a bad practice.  
Instead, Kubernetes provides **ConfigMaps** to externalize configuration and inject it into Pods using **environment variables** or **files**.

---

## What is a ConfigMap?

A **ConfigMap** is a Kubernetes resource used to store **non-sensitive configuration data** as key-value pairs.

- It is managed by Kubernetes
- It can be reused across multiple Pods
- It keeps configuration separate from application code

👉 **Important:**  
ConfigMaps are **not encrypted**. For sensitive data like passwords or tokens, use **Secrets** instead.

---

## Example ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: data-store-env
data:
  folder: 'story'
```

---

# Using ConfigMap with Environment Variables in Kubernetes

## 📌 Why Use ConfigMaps for Environment Variables?

Using ConfigMaps allows you to:

- Externalize configuration from application code
- Change configuration **without modifying Deployment YAML**
- Reuse the same config across multiple pods
- Manage environment-specific values cleanly

---

## 📦 Environment Variable via ConfigMap

### Deployment Snippet

```yaml
spec:
  containers:
    - name: story
      image: gibsonjoseph/kub-data-demo:2
      env:
        - name: STORY_FOLDER
          valueFrom: # Indicates that the value is not hardcoded. Kubernetes will fetch the value from an external source
            configMapKeyRef: # Tells Kubernetes to read the value from a ConfigMap
              name: data-store-env # The name of the ConfigMap
              key: folder # This ConfigMap must already exist in the same namespace
```
