# Environment Variables in Kubernetes

## 📌 What are Environment Variables?

Environment variables are **key–value pairs** used to configure applications at runtime **without changing the application code**.

In Kubernetes, environment variables are commonly used to:

- Pass configuration values
- Control application behavior
- Define paths, modes, or feature flags
- Avoid hardcoding values inside images

---

## 📦 Example Deployment

Below is a Kubernetes Deployment that demonstrates how environment variables are configured for a container.
Environment variables are defined at the container level using the env field.
This variable will be available inside the container at runtime.
Inside the container, the application can access the variable like this:

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
          image: gibsonjoseph/kub-data-demo:2
          env:
            - name: STORY_FOLDER # Environment variable name
              value: 'story' # Value assigned to the variable
          volumeMounts:
            - mountPath: /app/story
              name: story-volume
      volumes:
        - name: story-volume
          persistentVolumeClaim:
            claimName: host-pvc
```

## To check the Config Map

```sh
$ kubectl get configmap
```

```sh
$ kubectl get configmap
NAME               DATA   AGE
data-store-env     1      84s
kube-root-ca.crt   1      20d
```
