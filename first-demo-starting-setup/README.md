# To create a docker image

```bash
$ docker build .
```

# To run docker image as container

```bash
$ docker run -p <image_port>:<host_port> <image_id>
```

# To list the docker container list

```bash
$ docker ps
```

# Using the following commant we can interact with node container

```bash
$ docker run -it node
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker run -it node
Welcome to Node.js v25.2.1.
Type ".help" for more information.
> .exit
3.12.4 (base) gibson@gibbs-yavar:~$ node -v
v22.16.0
3.12.4 (base) gibson@gibbs-yavar:~$

```
