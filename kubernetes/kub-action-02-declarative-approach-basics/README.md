# [Autocomplete Kubernetes YAML files in VSCode](https://blog.gripdev.xyz/2017/11/09/autocomplete-kubernetes-yaml-files-in-vscode/)

It’s nice and easy to get autocomplete setup for the Kubernetes YAML using this awesome extension [YAML Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

## Setup

- Install the Extension

- Add the following to your settings

```yaml
'yaml.schemas': { 'Kubernetes': '*.yaml' }
```

- Reload the editor

---

`apiVersion`

In **Kubernetes**, the `apiVersion` field is a required key in every object's configuration (YAML or JSON) file that specifies which version of the Kubernetes API schema should be used to create or manage that object

---

# To run the kubernetes yaml file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: second-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: second-app
      tier: backend
  template:
    metadata:
      labels:
        app: second-app
        tier: backend
    spec:
      containers:
        - name: second-node
          image: gibsonjoseph/kub-first-app:2
        # - name: ...
        #   image:
```

```sh
kubectl apply  -f <K8S_YAML_FILE>
```

```sh
kubectl apply  -f deployment.yaml
deployment.apps/second-app-deployment created
```

Now you can see the deployment object and pods.

```sh
kubectl get deployment
NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
second-app-deployment   1/1     1            1           108s
```

```sh
kubectl get pod
NAME                                     READY   STATUS    RESTARTS   AGE
second-app-deployment-65db7746bd-fj8fw   1/1     Running   0          114s
```
