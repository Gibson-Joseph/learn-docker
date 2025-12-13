# Imperative Approch

## To create a new deployment object

**_NOTE_ :** Before creating the deployment you have to push your image into the docker hub

```sh
kubectl create deployment <deployment_name> --image=<your_image_name>
```

```sh
kubectl create deployment first-app --image=kub-first-app
```

## To check the deployment

```sh
kubectl get deployments

NAME        READY   UP-TO-DATE   AVAILABLE   AGE
first-app   0/1     1            0           14s
```

# To check the pods

```sh
kubectl get pods

NAME                        READY   STATUS             RESTARTS   AGE
first-app-7bc4c5754-frjcc   0/1     ImagePullBackOff   0          82s
```

# To delete the deployment

```sh
kubectl delete deployment <deployment_name>
```

```sh
kubectl delete deployment first-app

deployment.apps "first-app" deleted from default namespace
```

---
