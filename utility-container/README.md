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

---

# Utilizing Entrypoint

## 🚀 ENTRYPOINT vs CMD (Simple Explanation)

Docker gives you two instructions to control what runs inside your container:

| Instruction    | Purpose                                                                   |
| -------------- | ------------------------------------------------------------------------- |
| **ENTRYPOINT** | Defines the **main command** that _always_ runs                           |
| **CMD**        | Defines **default arguments** or a default command that can be overridden |

Here is a **clean, simple, beginner-friendly `README.md`** explaining **ENTRYPOINT**, **CMD**, and how to use them.
You can **copy-paste** this directly into your repo.

---

## 🧩 What Are ENTRYPOINT and CMD?

Docker uses **ENTRYPOINT** and **CMD** inside a `Dockerfile` to decide **what command runs when the container starts**.

They look similar but serve different purposes.

---

# 🚀 ENTRYPOINT

**ENTRYPOINT defines the main command that will always run.**
It is treated as the container’s _primary executable_.

### Example

```dockerfile
ENTRYPOINT ["python"]
```

This means when the container runs, Docker will always use `python` as the base command.

Running:

```bash
docker run myimage app.py
```

Actual command executed:

```
python app.py
```

---

# 📦 CMD

**CMD provides default arguments** (or a default command) that can be overridden.

### Example

```dockerfile
CMD ["app.py"]
```

Running:

```bash
docker run myimage
```

This will run:

```
app.py
```

But if you pass your own argument:

```bash
docker run myimage test.py
```

It overrides the CMD.

---

# 🔥 ENTRYPOINT + CMD (Most Common & Useful)

You can combine both to create flexible containers.

### Example

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

Default behavior:

```
python app.py
```

Override only CMD:

```bash
docker run myimage script.py
```

Runs:

```
python script.py
```

---

# 🧠 Simple Difference

| ENTRYPOINT                 | CMD                                |
| -------------------------- | ---------------------------------- |
| Always runs                | Only runs if user doesn’t override |
| Defines the _main program_ | Defines default arguments          |
| Harder to override         | Easy to override                   |
| Good for fixed behavior    | Good for optional behavior         |

---

# 🎯 When to Use What?

### Use ENTRYPOINT when:

- You want a fixed executable
- Example: `python`, `node`, `npm`, `mongosh`

### Use CMD when:

- You want default args
- Example: default script name, default port, default behavior

### Use both when:

- You have a main program + default arguments
- Example:

  - Main program → ENTRYPOINT
  - Default script/command → CMD

---

# 🧰 Real Example: Node Utility Container

```dockerfile
FROM node:20

ENTRYPOINT ["node"]
CMD ["app.js"]
```

Default:

```
node app.js
```

Custom:

```bash
docker run mycontainer server.js
```

Runs:

```
node server.js
```

---

# 📝 Summary

✔ **ENTRYPOINT = Main command (mandatory)**
✔ **CMD = Default arguments (optional)**
✔ CMD can be overridden easily
✔ ENTRYPOINT cannot be overridden unless using `--entrypoint`

Together they make your container flexible and easy to use.

---

```dockerfile
FROM node:14-alpine

WORKDIR /app

ENTRYPOINT [ "npm" ]
```

```sh
$ docker build -t mynpm .
```

```sh
$ docker run -it -v /home/gibson/Documents/gibson/learning/learn-docker/utility-container:/app mynpm init
```

```sh
$ docker run -it -v /home/gibson/Documents/gibson/learning/learn-docker/utility-container:/app mynpm install
```

```sh
$ docker run -it -v /home/gibson/Documents/gibson/learning/learn-docker/utility-container:/app mynpm install express
```

---

# Using Docker Compose

Utility containers are helpful when you want to use tools like Node.js, Python, Mongo shell, etc., **without installing them on your machine**.

It does not run your main application.
It is used as a toolbox.

```dockerfile
FROM node:14-alpine
WORKDIR /app
ENTRYPOINT [ "npm" ]
```

```yml
services:
  npm:
    build: ./
    volumes:
      - ./:/app
```

We can run the single service through the follwing command

```sh
docker compose run <service_name> <CMD>
```

```sh
docker compose run npm init
(Or)
docker compose run --rm npm init # this will automatially remove the container
```

```sh
docker compose run npm init
This utility will walk you through creating a package.json file.
...
rest of the process
...
```
