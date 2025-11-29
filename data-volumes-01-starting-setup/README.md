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
