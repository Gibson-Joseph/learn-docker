```bash
$ docker ps
$ docker ps -a
```

```bash
$ docker --help
$ docker ps --help
$ docker run --help
```

### When docker run create a new container.

```bash
$ docker start <container_name | container_id>
```

# Run the container in detachecd mode (in background)

```bash
$ docker run -p <hostport>:<imageport> -d <imageid>
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker run -p 3001:8000 -d  63d5f0a41071
3f38de9b0e00ac156462e741a47a3253d9128f8a03d138e7e6b732f1c988d4a9
3.12.4 (base) gibson@gibbs-yavar:~$
```

We can attach ourself to a detached container again by running

```bash
$ docker container attach <container_name>
```

# using the logs commant we can see the past logs

```bash
$ docker logs <container_name>
    gibson
    joseph
    this was just an example
    Want to learn docker
$
```

# using the -f flag in the logs to print the all logs and attach the process

```bash
$ docker logs -f <container_name>
    gibson
    joseph
    this was just an example
    Want to learn docker
```

# We can restart our container with attached mode

```bash
$ docker start -a <container_name>
```

# Attaching to an already-running Container

By default, if you run a Container without -d, you run in "attached mode".

If you started a container in detached mode (i.e. with -d), you can still attach to it afterwards without restarting the Container with the following command:

docker attach CONTAINER
attaches you to a running Container with an ID or name of CONTAINER.
