# Volumes

Volumes help us to persisting the data.

Volumes are folders on your host machine hard drive which are mounted ("made available", mapped) into containers.

If you add a file on your host machine, it is accessible inside of the container, and if the container adds a file in that mapped path, it is available outside of the container, in the host machine as well.

Volume persist if a container shuts down. If a container (re-)starts and mounts a volume, any data inside of that volume is available in the container.

The volume will not be removed, when a container is removed, it survivies, and therefore the data in a volume survives.

---

# Type of volumes

1. Anonymous volumes
2. Named volumns

Docker sets up a folder/path on your host machine, exact location is unknown to you (=dev). Managed vie docker `volume commands`

# Anonymous volumes

```docker
VOLUME['/app/feedback'];
```

or

```bash
docker run -v <container-path> <image>
```

# To list all volumes

```bash
$ docker volume ls
DRIVER    VOLUME NAME
local     1b867d0bd9fc06f782ca8b25e59ba8823aac042c8ee0a57e5f889020681495a7
```

this anonymous volume won't exists if we remove the container. Its actually only exists as longs as our container exists.

---

# Named volumns

A defined path in the container is mapped to the created volume / mount.
eg./some-path on your hosting machine is mapped to /app/data.

With named volumns, that will be the case. Volumes will survive container's shoutdown(deleted). The folders on your hard drive will sruvive. But which you don't need to edit or view directly.

We can't create a named volume inside of our docker file.

### syntax

```bash
$ docker run -v <volume-name>:<container-path> <image>

```

```bash
 $ docker run -p 3000:3000 --rm -d --name feedback-app -v feedback:/app/feedback feedback-node:volumes
```

```bash
$ docker volume ls
DRIVER    VOLUME NAME
local     feedback
```

After stop the running container and run the same image with create volume, we can see our persisted data.

```bash
 $ docker run -p 3000:3000 --rm -d --name feedback-app -v feedback:/app/feedback feedback-node:volumes
```

---

# Removing Anonymous Volumes

We saw, that anonymous volumes are removed automatically, when a container is removed.

This happens when you start / run a container with the `--rm` option.

If you start a container **without that option**, the anonymous volume would NOT be removed, even if you remove the container (with `docker rm ...`).

Still, if you then re-create and re-run the container (i.e. you run `docker run ...` again), a new anonymous volume will be created. So even though the anonymous volume wasn't removed automatically, it'll also not be helpful because a different anonymous volume is attached the next time the container starts (i.e. you removed the old container and run a new one).

Now you just start piling up a bunch of unused anonymous volumes - you can clear them via docker volume rm VOL_NAME or docker volume prune.

---

# Bind mounts (Managed by us)

We define a folder / path on our host machine. And since that is the case, and containers cannot just write to volumnes, but also read from there.

Great for persistent, editable (by us) data (e.g source code).

### Basic syntax

```bash
docker run -v <host-path>:<container-path> <image>
```

Here we have overwrite the app folder inside of the container with our local folder.

```bash
$ docker run -d -p 3000:3000 --rm --name feedback-app -v feedback:/app/feedback -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app feedback-node
```

or

If our path containse any special character or whitspce we have to wrap it up with double quoute (e.g: "<host-path>").

```bash
$ docker run -d -p 3000:3000 --rm --name feedback-app -v feedback:/app/feedback -v "/home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app" feedback-node
```

If you run run the above comment you will get the following error, because we have overwrite the app folder with our host folders, our host folder doesn't include the node_module folder

```bash
$ docker logs feedback-app
internal/modules/cjs/loader.js:934
  throw err;
  ^

Error: Cannot find module 'express'
Require stack:
- /app/server.js
    at Function.Module._resolveFilename (internal/modules/cjs/loader.js:931:15)
    at Function.Module._load (internal/modules/cjs/loader.js:774:27)
    at Module.require (internal/modules/cjs/loader.js:1003:19)
    at require (internal/modules/cjs/helpers.js:107:18)
    at Object.<anonymous> (/app/server.js:5:17)
    at Module._compile (internal/modules/cjs/loader.js:1114:14)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:1143:10)
    at Module.load (internal/modules/cjs/loader.js:979:32)
    at Function.Module._load (internal/modules/cjs/loader.js:819:12)
    at Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:75:12) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [ '/app/server.js' ]
}
```

Here we have persisting our node_modules folder

```bash
$ docker run -d -p 3000:3000 --rm --name feedback-app -v feedback:/app/feedback -v "/home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app" -v /app/node_modules feedback-node
```

Maps your local folder → container /app

Meaning:

1. Local code changes instantly update inside the container
2. Perfect for development
3. No need to rebuild the image

This folder becomes the main working project folder inside the container.

Now we can change and run our code instantly without rebuilding the image in between.

# Bind Mounts - Shortcuts

Just a quick note: If you don't always want to copy and use the full path, you can use these shortcuts:

macOS / Linux: `-v $(pwd):/app`

Windows: `-v "%cd%":/app`

---

# Read only volumes

By default volumes are read and write, which means the container is able to read data from there and write data to them. But you can restrict that.

A read-only volume is a Docker volume (or bind mount) that the container can read but cannot write to.
This protects your local files or mounted data from accidental modification by the container.

## Syntax

### Bind Mount (Host → Container)

```bash
$ -v /path/on/host:/path/in/container:ro
```

## Named Volume

```bash
$ -v volume_name:/path/in/container:ro
```

## Anonymous Volume (read-only)

```bash
$ -v /path/in/container:ro
```

```bash
$ docker run -d --rm -p 3000:3000 --name feedback-app -v feedback:/app/feedback -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app:ro -v /app/node_modules feedback-node:volumes
```

This ensures that docker will now not able to write into this `/app` or any of its sub-folders. Of course, we on our hosting machine stil wil be able to change these files, this does not affect us. Its only affects the container and the application running in the container.

```bash
$ docker run -d --rm -p 3000:3000 --name feedback-app -v feedback:/app/feedback -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app:ro -v /app/temp -v /app/node_modules feedback-node:volumes
```

---

Here is a **clear, line-by-line explanation** of your Docker run command:

---

# ✅ **Your Command**

```bash
docker run -d --rm -p 3000:3000 --name feedback-app \
  -v feedback:/app/feedback \
  -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app:ro \
  -v /app/temp \
  -v /app/node_modules \
  feedback-node:volumes
```

---

# 🔍 **Breakdown & Explanation**

## **1️⃣ `docker run -d --rm`**

- `-d` → run in **detached** (background) mode
- `--rm` → remove container automatically when stopped

✔ Keeps your system clean.

---

## **2️⃣ `-p 3000:3000`**

Maps:

```
HOST: 3000 → CONTAINER: 3000
```

✔ Allows you to open the app in your browser at `http://localhost:3000`.

---

## **3️⃣ `--name feedback-app`**

Gives your container a friendly name:

```
feedback-app
```

✔ Easier to stop/remove/log.

---

# 🧊 **Volumes (Most Important Part)**

## **4️⃣ `-v feedback:/app/feedback`**

A **named volume** called `feedback`.

```
Docker Volume: feedback  --->  /app/feedback (inside container)
```

✔ Keeps user feedback or app data
✔ Persistent even if the container is removed
✔ NOT stored in your project folder

---

## **5️⃣ `-v /home/.../data-volumes-01-starting-setup:/app:ro`**

This is a **bind mount**.

```
Your Local Folder → Mounted to → /app (inside container)
```

`ro` → **read-only**

✔ Container **CAN read** your source code
✘ Container **CANNOT edit** or delete it
✔ Protects your project files

---

## **6️⃣ `-v /app/temp`**

This is an **anonymous volume**.

Meaning:

```
Create a Docker-managed temp volume → mount it on /app/temp
```

✔ Container can write temporary files
✔ They won’t appear in your project folder
✔ You don’t need to manage them manually

---

## **7️⃣ `-v /app/node_modules`**

Another **anonymous volume**, mounted on `/app/node_modules`.

Purpose:

✔ Prevents node_modules from being overwritten
✔ Avoids the “node_modules created in my project folder” problem
✔ Ensures all packages stay inside Docker

This is the **correct pattern** for Node.js development.

---

## **8️⃣ `feedback-node:volumes`**

This is the **image name** you are running.

---

# 🎯 **What This Setup Achieves**

### ✔ Safe: your source code is mounted read-only

### ✔ Clean: node_modules stored inside Docker, not on your host

### ✔ Persistent: feedback data stored in named volume

### ✔ Easy development: code changes reflect immediately inside container

### ✔ No pollution: your project folder stays clean (no node_modules, no temp folders)

---

## Docker volumn list

```bash
$ docker volume ls
```

```bash
$ docker volume ls
DRIVER    VOLUME NAME
local     6af8f13a92ac0aaf0cc93a26094221ae78967ac0059c1b5fe24c12188190d259 # Anonymous volume
local     e8e07dd24a0c3b468b1898db71e5b7ac5034750d27dbec5a1d8b19553b7e94b9 # Anonymous volume
local     feedback # Named volume
```

The bind mount does not show up in this list, because the bind mount is not a volume managed by Docker, this binds a local folder which we know to a folder inside of the container. And of course there fore docker does not manage this. it's our known folder on our host machine, docker is not in control over that. But the other volumnes are managed by Docker.

And managed by Docker also means that docker will create this volume if it doesn't exist yet, when you run a container.

## Create volume through comments

```bash
$ docker volume create <volume_name>
```

```bash
$ docker volume create feedback-files
feedback-files
$ docker volume list
DRIVER    VOLUME NAME
local     6af8f13a92ac0aaf0cc93a26094221ae78967ac0059c1b5fe24c12188190d259
local     e8e07dd24a0c3b468b1898db71e5b7ac5034750d27dbec5a1d8b19553b7e94b9
local     feedback
local     feedback-files
```

And we can use our new volume here

```bash
$ docker run -d --rm -p 3000:3000 --name feedback-app -v feedback-files:/app/feedback -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app:ro -v /app/temp -v /app/node_modules feedback-node:volumes
```

## To remove a volume

Using the following comment we can delete our unused volumes.

```bash
$ docker volume rm <volume_name>
```

```bash
$ docker volume rm feedback
feedback
```

To remove all anonymous volume

```bash
$ docker volume prune
```

To remove all volume including the anonymous and named volume

```bash
$ docker volume prune -a
```

## To inspect our volume

```bash
$ docker volume inspect <volume_name>
```

```bash
$ docker volume inspect feedback-files
[
    {
        "CreatedAt": "2025-11-29T16:44:01+05:30",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/snap/docker/common/var-lib-docker/volumes/feedback-files/_data",
        "Name": "feedback-files",
        "Options": null,
        "Scope": "local"
    }
]

```

---

# Adding more to the .dockerignore File

You can add more **"to-be-ignored"** files and folders to your .dockerignore file.

For example, consider adding the following to entries:

`Dockerfile`
`.git`
This would ignore the `Dockerfile` itself as well as a potentially existing `.git` folder (if you are using Git in your project).

In general, you want to add anything which isn't required by your application to execute correctly.

---
