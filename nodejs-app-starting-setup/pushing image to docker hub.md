# Naming & Tagging Containers and Images

```bash
$ docker run -p <host_port>:<container_port> -d --rm --name <container_name> <image_id>
```

```bash
gibson@gibbs-yavar:~$ docker run -p 3000:8000 -d --rm --name goalsapp ed98432dc055
f07384f417eb62696ce9e1984ec4840ecbb8dd3c5825e70f386a8efb7b1e1b14
```

Now you can see the name in the continer list

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker container ls
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                         NAMES
f07384f417eb   ed98432dc055   "docker-entrypoint.s…"   31 seconds ago   Up 30 seconds   0.0.0.0:3000->8000/tcp, [::]:3000->8000/tcp   goalsapp

```

Setting a image name consists two parts. Its the acutal name, also called repository of your image and then a tag seperated by a colon.

```bash
<name>:<tag>
```

### name

Defines a group of, possible more specialized, images
Example: 'node'

### tag

Defines a specialized image within a group of images
Example: 14

```bash
$ docker build -t <name>:<tag> .
```

```bash
$ docker build -t goals:latest .
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED             SIZE
goals        latest    c5ca80671e87   4 seconds ago       1.14GB
```

Side-note: If you want to remove ALL images incl. tagged images, you need to run

```bash
$ docker image prune -a
```

# Renaming the image name and tag

```bash
$ docker tag <old_name>:<old_tag> <new_name>:<new_tag>
```

```bash
$ docker tag goals:v1 gibsonjoseph/node-hello-world
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$  docker images
REPOSITORY                      TAG       IMAGE ID       CREATED          SIZE
gibsonjoseph/node-hello-world   latest    8febca245d42   23 minutes ago   1.14GB
goals                           v1        8febca245d42   23 minutes ago   1.14GB
```

When you rename an image you don't get rid of the old image.

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker push gibsonjoseph/node-hello-world
Using default tag: latest
The push refers to repository [docker.io/gibsonjoseph/node-hello-world]
8ea2707d9037: Preparing
e1b06cda0da8: Preparing
96c870841581: Preparing
61e5cc310d78: Preparing
24a579b6fc5b: Preparing
c02242ab715a: Waiting
f72483486738: Waiting
b596c0acdee6: Waiting
79cc03b0939f: Waiting
fdc431a0f571: Waiting
95dbc77126e3: Waiting
9400805d96a1: Waiting
denied: requested access to the resource is denied
3.12.4 (base) gibson@gibbs-yavar:~$
```

First of all we need to login. To establish the connection we can run

```bash
$ docker login
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker login

USING WEB-BASED LOGIN

i Info → To sign in with credentials on the command line, use 'docker login -u <username>'


Your one-time device confirmation code is: HVHF-KKFV
Press ENTER to open your browser or submit your device code here: https://login.docker.com/activate

Waiting for authentication in the browser…

```

```bash
$ docker login -u <username>
```

of course we have a log out command

```bash
$ docker logout
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker login -u gibsonjoseph

i Info → A Personal Access Token (PAT) can be used instead.
         To create a PAT, visit https://app.docker.com/settings

Password:
```

After enter the personal token

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker login -u gibsonjoseph

i Info → A Personal Access Token (PAT) can be used instead.
         To create a PAT, visit https://app.docker.com/settings


Password:

WARNING! Your credentials are stored unencrypted in '/home/gibson/snap/docker/3377/.docker/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
3.12.4 (base) gibson@gibbs-yavar:~$
```

To pusing image to docker hub repo

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker push gibsonjoseph/node-hello-world
Using default tag: latest
The push refers to repository [docker.io/gibsonjoseph/node-hello-world]
8ea2707d9037: Pushed
e1b06cda0da8: Pushed
96c870841581: Pushed
61e5cc310d78: Pushed
24a579b6fc5b: Mounted from library/node
c02242ab715a: Mounted from library/node
f72483486738: Mounted from library/node
b596c0acdee6: Mounted from library/node
79cc03b0939f: Mounted from library/node
fdc431a0f571: Mounted from library/node
95dbc77126e3: Mounted from library/node
9400805d96a1: Mounted from library/node
latest: digest: sha256:3f9a69b6322eb32933b21939e23897716e3594a6b40271131eae8ac7b390f602 size: 2836
3.12.4 (base) gibson@gibbs-yavar:~$
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker logout
Removing login credentials for https://index.docker.io/v1/
```

To pull the image from the docker hub repo

```bash
$ docker pull <repository_name>
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker pull gibsonjoseph/node-hello-world
Using default tag: latest
latest: Pulling from gibsonjoseph/node-hello-world
708274aafe49: Already exists
8cdff261ed5c: Already exists
078b2eece9b2: Already exists
a1208d53eb06: Already exists
78c780840163: Already exists
435cbc1d6a03: Already exists
29dd662fc17f: Already exists
73d86704c819: Already exists
ef1d1914d2f5: Already exists
56b21f3b9ad3: Already exists
33024abea4c0: Already exists
39990ae31fef: Already exists
Digest: sha256:3f9a69b6322eb32933b21939e23897716e3594a6b40271131eae8ac7b390f602
Status: Downloaded newer image for gibsonjoseph/node-hello-world:latest
docker.io/gibsonjoseph/node-hello-world:latest
```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$  docker images
REPOSITORY                      TAG       IMAGE ID       CREATED          SIZE
gibsonjoseph/node-hello-world   latest    8febca245d42   47 minutes ago   1.14GB

```
