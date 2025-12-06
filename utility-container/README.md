# 📘 Utility Containers & Executing Commands in Docker

## 🧩 What Are Utility Containers?

A utility container is a Docker container used only for running tools or one-off commands, not for running your main application.

Think of them like temporary “tool boxes”.

## ⭐ Examples

Running database commands (mongo shell, psql, mysql)
Running scripts (Node, Python, Go)
Doing quick checks (curl, ping, ls)
Running migration tools
Running commands in your dev environment without installing them locally

## 🚀 Why Use Utility Containers?

✔ No need to install tools on your machine
✔ Same version of tools for everyone on the team
✔ Great for debugging and one-off commands
✔ Safe and reproducible

## 🛠️ Executing Commands in Containers

Docker gives three main ways to run commands.

### 1#️⃣ Run a New One-Off Container

Use this when you want to quickly run a tool or script.

```sh
docker run --rm -it node:20 node --version
```

- --rm → remove container after exit
- -it → interactive terminal
- node:20 → image name
- node --version → command to run

### 2 Run Commands in an Already Running Container

```sh
$ docker run -it -d node
b24ae28305a284d8ea8c657c9053d7c797811e3926156a611f62b4d4dd73d012
```

First, see running containers:

```sh
$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
1490901d848d   node      "docker-entrypoint.s…"   16 seconds ago   Up 16 seconds             cranky_pasteur
```

Then exec inside:
`docker exec` commend allow us to execute certain commends inside of our running container.

```sh
$ docker exec <continer_name> node -v
v25.2.1
```

---

# Building a First Utility container

```dockerfile
FROM node:14-alpine
WORKDIR /app
```

create the image

```sh
$ docker build -t node-util .
```

Run the container

```sh
$ docker run -it -v /home/gibson/Documents/gibson/learning/learn-docker/utility-container:/app node-util npm init
```

Once we were we done, we can see the package.json file appear on our host machine.

And now I could totaly uninstall node in my host machine.
And I could still create project with help of npm init with help of this utility continer. And it can be really useful actually you don't have to install all extra tools like node on your machine.
