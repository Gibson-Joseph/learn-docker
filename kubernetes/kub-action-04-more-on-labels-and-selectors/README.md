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
