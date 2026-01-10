# [Pod-to-Pod Communication with IP Addresses & Environment Variable.](https://www.udemy.com/course/docker-kubernetes-the-practical-guide/learn/lecture/22627933#overview)

With service, you get stable IP addresses. And one service has it's own IP address, and that IP address will not change, and through that IP address, the pod that are controlled by that service can be reached.

So that means we need to find out which IP address this service has. Now one way of doing that is;

```sh
$ kubectl apply -f auth-service.yaml -f auth-deployment.yaml
service/auth-service created
deployment.apps/auth-deployment created
```

```sh
$ kubectl get services
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
auth-service    ClusterIP      10.101.18.151   <none>        80/TCP           42s
kubernetes      ClusterIP      10.96.0.1       <none>        443/TCP          21d
users-service   LoadBalancer   10.110.4.213    <pending>     8080:30583/TCP   64m
```

Now you can see the Cluster IP address, which is now available inside of the cluster. So you will not be able to use that IP address on you local machine. It's only available inside of the cluster. And we could use this IP address there as a value.

But of course manually getting this IP address, is a bit annoying. The good news is that it's stable, it won't change all the time, so we could do that. But still it is a bit annoying.

There is a more convenient way. Kubernetes will give you automatically generated environment variables. In your programs, with information about all the services, which are running in your cluster. So we got `auth-service` and `user-service` up and running basically, and we automatially get environment variables. In our code, by kubernetes, if we got these services. And through tese eviroment variables, Kubernetes will automatically give us information like the IP addresses of the different services.

# Service Environment Variables (Recommended Way)

When you create a Service, Kubernetes automatically injects environment variables for it.

`Example Service`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: users-service
spec:
selector:
  app: users
ports:
  - port: 80
    targetPort: 3000
```

Auto-created environment variables

**Inside other Pods:**

```sh
USERS_SERVICE_SERVICE_HOST=10.96.120.45
USERS_SERVICE_SERVICE_PORT=80
```

**Usage:**

```sh
curl http://$USERS_SERVICE_SERVICE_HOST:$USERS_SERVICE_SERVICE_PORT
```

✅ Stable
✅ No IP change
✅ Kubernetes-managed

# Naming Convention (Very Important)

If your Service name is:

```sh
metadata:
  name: users-service
```

Kubernetes converts it to:

```sh
USERS_SERVICE
```

Then creates environment variables like:

```sh
USERS_SERVICE_SERVICE_HOST
USERS_SERVICE_SERVICE_PORT
```

# How Applications Use These Variables

Node.js example

```sh
const host = process.env.USERS_SERVICE_SERVICE_HOST;
const port = process.env.USERS_SERVICE_SERVICE_PORT;

fetch(`http://${host}:${port}/health`);
```
