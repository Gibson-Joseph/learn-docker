# ARGuments & ENVironment varibles

Docker supports build-time ARGuments and runtime ENVironment varibles

## ARG

Available inside of Dockerfile, NOT accessible in CMD or any application code
Set on image build (docker build) via `--build-arg`

## ENV

Available inside of Dockerfile & in application code.
Set vai ENV in Dockerfile or via `--env` on `docker run`.

Docker gives you two ways to pass values into your image/container:
| Feature | `ARG` | `ENV` |
| --------------------------------------- | ------------------- | ----------------------- |
| Available during | **Build time only** | **Runtime (container)** |
| Accessible inside Dockerfile | Yes | Yes |
| Accessible inside running container | ❌ No | ✔️ Yes |
| Can be overridden using `--build-arg` | ✔️ Yes | ❌ No |
| Can be overridden using `-e` or `--env` | ❌ No | ✔️ Yes |
| Appears in `docker history` | ✔️ Yes | ✔️ Yes |

# ENV – Environment Variables (Runtime)

Use ENV for values needed when the container is running.

```dockerfile
ENV PORT=3000
EXPOSE ${PORT}
```

Override at runtime:

```bash
$ docker run --env PORT=4000 my-app
```

```bash
$ docker run -d --rm -p 3000:8000 --env PORT=8000 --name feedback-app -v feedback-files:/app/feedback -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app:ro -v /app/temp -v /app/node_modules feedback-node:env

```

1. Available to your application
2. Available inside container shell
3. Can be overridden using `-e` or `--env`

# What is --env-file in Docker?

`--env-file` lets you load multiple environment variables from a file while starting a container.
It works only at runtime, same as `-e` / `--env`.

Example `.env` file:

```ini
PORT=3000
DB_HOST=localhost
DB_USER=admin
DB_PASS=secret123
# You can add comments like this
```

Using --env-file

Basic syntax:

```shell
$ docker run --env-file .env my-app
```

```shell
$ docker run -d -p 3000:8000 --env-file .env --name feedback-app -v feedback-files:/app/feedback -v /home/gibson/Documents/gibson/learning/learn-docker/data-volumes-01-starting-setup:/app:ro -v /app/node_modules feedback-node:env
6dbe3660340c3554c3a5669ab2f8a090e03c2de4f71d5bf5c6d80db139cfd711

```

# Environment Variables & Security

One important note about **environment variables and security**: Depending on which kind of data you're storing in your environment variables, you might not want to include the secure data directly in your `Dockerfile`.

Instead, go for a separate environment variables file which is then only used at runtime (i.e. when you run your container with `docker run`).

Otherwise, the values are "baked into the image" and everyone can read these values via `docker history <image>`.

For some values, this might not matter but for credentials, private keys etc. you definitely want to avoid that!

If you use a separate file, the values are not part of the image since you point at that file when you run `docker run`. But make sure you don't commit that separate file as part of your source control repository, if you're using source control.

---

# ARG – Build-time Arguments

Use `ARG` **when the value is needed only while building the image**.
It CANNOT be used by the running container unless you copy it into `ENV`.

## What is --build-arg in Docker?

`--build-arg` is used to **pass build-time variables** to a Docker image during `docker build`.

It works **only** during the build process — NOT when the container is running.

These values are accessed inside the Dockerfile using `ARG`.

```dockerfile
FROM node:14

ARG DEFAULT_PORT=3000

WORKDIR /app

COPY package.json .

RUN npm install

COPY .  .

ENV PORT=${DEFAULT_PORT}

EXPOSE ${PORT}

CMD [ "npm", "start" ]
```

Good for temporary build values

```bash
$ docker build -t feedback-node:web-app .
```

```bash
$ docker build -t feedback-node:dev --build-arg DEFAULT_PORT=8000 .
```
