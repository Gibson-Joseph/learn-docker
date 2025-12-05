# To run the Mongo db

```sh
$ docker run --name mongodb -v data:/data/db --rm -d --network goals-net -e MONGO_INITDB_ROOT_USERNAME=gibbs -e MONGO_INITDB_ROOT_PASSWORD=secret mongo

```

# To run backend application

```sh
$ docker run --name goals-backend -v /home/gibson/Documents/gibson/learning/learn-docker/multi-01-starting-setup/backend:/app -v logs:/app/logs -v /app/node_modules -e MONGODB_USERNAME=gibbs -e MONGODB_PASSWORD=secret -d --rm -p 8000:8000 --network goals-net goals-node
1f0705ce16abc84361a20f85a64fd9cb8947170c23a66019e8ae9d91e312ad88
```
