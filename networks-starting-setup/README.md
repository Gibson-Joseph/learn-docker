# Making container ot Host Communication

To communicate with your host machine's server from a Dockerized application, the method depends on your OS and what exactly you’re trying to reach (API, database, local server, etc.). Here is the clear breakdown.

# Linux-only - Using Host Mode Networking

This makes the container use the host network directly:

```bash
$ docker run --network host my-app

(Or)

$ docker run --network="host" my-app
```

Then `localhost` inside the container == host’s `localhost`.

# On Windows / macOS — Use host.docker.internal

Docker Desktop provides a special DNS name:

`http://host.docker.internal:5000`

This works directly on Windows & macOS.

---

# Container-to-Container Communication

## Introducing Docker Networks

When working with multiple Docker containers—databases, APIs, frontends—you need them to **talk to each other reliably**.
Docker Networks provide a **clean, isolated, and automatic way** for containers to communicate **without exposing ports to the host** unnecessarily.

Why Docker Networks?

Without Docker networks:

1. Containers cannot talk to each other automatically.
2. You must expose ports manually via `-p 3000:3000`.
3. Internal communication becomes messy.

With Docker networks:

1. Containers communicate using **DNS names (service names)** instead of IPs.
2. Docker automatically assigns internal IPs.
3. Containers remain isolated from the host unless explicitly exposed.
4. Cleaner, secure, production-ready communication.

## Creating a Custom Docker Network

```sh
$ docker network create my-net
```

Now any container attached to this network can communicate with others using their container names.

## Running Containers on the Same Network

Example: running a Node.js app that needs to connect to a MongoDB container.

1. Run MongoDB

```sh
$ docker run -d --name mongo --network my-net mongo
```

2. Run Node.js app

```sh
$ docker run -d --name node-app --network my-net node-app-image
```

```bash
$ docker network --help
Usage: docker network COMMAND

Manage networks

Commands:
connect Connect a container to a network
create Create a network
disconnect Disconnect a container from a network
inspect Display detailed information on one or more networks
ls List networks
prune Remove all unused networks
rm Remove one or more networks

Run 'docker network COMMAND --help' for more information on a command.
```

```sh
$ docker network create favorites-net
0473426f9d2de2cee7f89fc232e3c899e5b53795c10e675485c894f1bc62e60e
```

This is Docker's internel networks, which you can use on Docker containers to let them talk to each otheres.

## To list all created networks

```sh
$ docker network ls
```

```sh
$ docker network ls
NETWORK ID     NAME            DRIVER    SCOPE
6355b18f8650   bridge          bridge    local
0473426f9d2d   favorites-net   bridge    local
7dfb0ff5b536   host            host      local
e9b39b3abe43   none            null      local
```

To use our own network that was created by us.

```sh
$ docker run -d --name mongodb --network favorites-net mongo
873631dcd81658871944eb62420216b773d6f763d1a06e3c1e6baabf9bac420d
```

## How They Communicate?

To communicate we can use the container name

Inside your Node.js app, instead of using:
`mongodb://localhost:27017`

you simply use:
`mongodb://mongodb:27017`

```js
mongoose.connect(
  'mongodb://mongodb:27017/swfavorites',
  { useNewUrlParser: true },
  (err) => {
    if (err) {
      console.log(err);
    } else {
      app.listen(3000);
    }
  }
);
```

Docker's internal DNS automatically resolves `mongodb` → the container’s internal IP.

```bash
$ docker run --name favorites --network favorites-net -d --rm -p 3000:3000 favorites-node
8bc7284c4623317e6da1b774e38dc687c863dccf65bb0ceb619bda3984ea63b2
```

Both container is part of the same network, in order to talk each others.

---

# Docker Network Drivers

Docker Networks actually support different kinds of **"Drivers"** which influence the behavior of the Network.

The default driver is the **"bridge"** driver - it provides the behavior shown in this module (i.e. Containers can find each other by name if they are in the same Network).

The driver can be set when a Network is created, simply by adding the `--driver` option.

```sh
$ docker network create --driver bridge my-net
```

Of course, if you want to use the "bridge" driver, you can simply omit the entire option since "bridge" is the default anyways.

Docker also supports these alternative drivers - though you will use the "bridge" driver in most cases:

**host**: For standalone containers, isolation between container and host system is removed (i.e. they share localhost as a network)

**overlay**: Multiple Docker daemons (i.e. Docker running on different machines) are able to connect with each other. Only works in "Swarm" mode which is a dated / almost deprecated way of connecting multiple containers

**macvlan**: You can set a custom MAC address to a container - this address can then be used for communication with that container

**none**: All networking is disabled.

**Third-party plugins**: You can install third-party plugins which then may add all kinds of behaviors and functionalities

As mentioned, the **"bridge"** driver makes most sense in the vast majority of scenarios.
