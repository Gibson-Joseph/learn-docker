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

---

# Deleting Images & Containers

To deleting the contianer you can follow the comments

```bash
$ docker rm <container_name>
```

We will get an error if try to delete the running container

```bash
gibson@gibbs-yavar:~$ docker rm upbeat_lamport
Error response from daemon: cannot remove container "upbeat_lamport": container is running: stop the container before removing or force remove
gibson@gibbs-yavar:~$
```

We can delete the stoped container

```bash
gibson@gibbs-yavar:~$ docker rm upbeat_lamport
upbeat_lamport
gibson@gibbs-yavar:~$

```

To delete all stoped container

```bash
$ docker rm <container_name> <container_name> <container_name>
```

Alternatively, We can also run `$ docker container prune ` to remove all stopeed containers at once.

```bash
gibson@gibbs-yavar:~$ docker container prune

WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
e06f6eb15f33c78b7e53b459ebab0fde89c2e19ed4ce102598961a6bdf6fd8f8
6fc3a803b7fb90281d801c2283f70704d8e72e6efdb7625af457421f16892058
39c6e5e36e105760307f5d8867fabb46d0141479a2c5d1c195c8e0727b143744
4c48f8c475d953cbd9d56dfb5e29d88e7e20a8ec8fb1b1fdacd42ceefcc0b85b
64fdd64bcd087240e39ad3367027f69d00eb96614568c057e21ccba6c49e2a4f
4b5e7d391585b2b5fc9870835be68a8627e639d550953828f8f46570f191716c
3f38de9b0e00ac156462e741a47a3253d9128f8a03d138e7e6b732f1c988d4a9

Total reclaimed space: 81.77kB
gibson@gibbs-yavar:~$

```

# To remove the images

```bash
$ docker rmi <image_id>
(or)
$ docker rmi <image_id> <image_id> # To delete the multiple images at same time.
(or)
$ docker image prune
```

You can only remove the imgaes if they're not getting used by any container anymore and that includes stoped container.

```bash
gibson@gibbs-yavar:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED             SIZE
<none>       <none>    d10881e4c969   12 minutes ago      1.14GB
<none>       <none>    6a083297fa4b   40 minutes ago      1.12GB
<none>       <none>    63d5f0a41071   About an hour ago   1.14GB
node         latest    9ebdc6b5e95f   4 days ago          1.13GB
3.12.4 (base) gibson@gibbs-yavar:~$ docker rmi d10881e4c969
Deleted: sha256:d10881e4c9693b41a11dba73234b1ac8d43c83f469960e2e73acb2085ced5f63

gibson@gibbs-yavar:~$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED             SIZE
<none>       <none>    6a083297fa4b   40 minutes ago      1.12GB
<none>       <none>    63d5f0a41071   About an hour ago   1.14GB
node         latest    9ebdc6b5e95f   4 days ago          1.13GB

gibson@gibbs-yavar:~$ docker rmi 6a083297fa4b 63d5f0a41071
Deleted: sha256:6a083297fa4b27a9ca5409207628c0bee381a3c09de1fb5ff588645328ef3db4
Deleted: sha256:63d5f0a410711fb221966069e65e0909415cea04826d540615a0553e7eced5b6

gibson@gibbs-yavar:~$

```

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
deleted: sha256:aa1414ae0b2edcb3bcaa641dfa4c9ceeae2f5b06c9a4eead6352b248a2f202ec
deleted: sha256:4e6e4f93dfc3d45c351e06b200429205bc9c391527b0224126a2d9329c2d9396

Total reclaimed space: 0B
3.12.4 (base) gibson@gibbs-yavar:~$

```

# Removingg stopped containers Automatically

--rm flag automatically remove the container when it exists

```bash
$ docker run -p <host_port>:<container_port> -d --rm <image_id>
```

# Look behind the scenes: Inspecting Images

```bash
$ docker image inspect <image_id>
```

```bash
gibson@gibbs-yavar:~$ docker image inspect ed98432dc055
[
    {
        "Id": "sha256:ed98432dc055ff2dda9325ec0249cbfdab9be13b2814809e75bc5431c937317d",
        "RepoTags": [],
        "RepoDigests": [],
        "Parent": "",
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2025-11-22T18:12:29.00466982+05:30",
        "DockerVersion": "",
        "Author": "",
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 1141395987,
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/snap/docker/common/var-lib-docker/overlay2/otxky2sfq96kyunc8x5ng567o/diff:/var/snap/docker/common/var-lib-docker/overlay2/liuihcuz5tg9cg4a2b4l3s3xj/diff:/var/snap/docker/common/var-lib-docker/overlay2/ihc43sh2206qcmz3gv7d0tu7k/diff:/var/snap/docker/common/var-lib-docker/overlay2/5a85f322232e8d56459993b933824bcab4805f4621f1a990e9eadfbf1e0f1db1/diff:/var/snap/docker/common/var-lib-docker/overlay2/a2716531f94d37aff4809ebde485b8e2e4482fd954f88d4df7e5b54aabf3b06b/diff:/var/snap/docker/common/var-lib-docker/overlay2/de3b5d411f36a98dcadc762dd6a71cde2c7b2089cceac5414f3baf6d76ec6589/diff:/var/snap/docker/common/var-lib-docker/overlay2/23479e373616be4de391d2e824ef5201fc8a5a1d8c630cc3a50b073af9021310/diff:/var/snap/docker/common/var-lib-docker/overlay2/aa556197d8835bed3d2cf1fd8a4b8eddf130780b9c6db043121d885e1b046443/diff:/var/snap/docker/common/var-lib-docker/overlay2/9f548ec1f448046524fbd71eb771a22455bf501adb6b30460dd05a0d6ffe91e5/diff:/var/snap/docker/common/var-lib-docker/overlay2/75bfcff709dfb84013eaa9f22fdecc95ac1b0a3df906588590ea2b843e2afc99/diff:/var/snap/docker/common/var-lib-docker/overlay2/afedcdbdd2e88ec83c7cd33d666cc3e4476e9a178331557a02aeddccb2f24255/diff",
                "MergedDir": "/var/snap/docker/common/var-lib-docker/overlay2/ry2s8zjui1mt9g5ih6z46ad8r/merged",
                "UpperDir": "/var/snap/docker/common/var-lib-docker/overlay2/ry2s8zjui1mt9g5ih6z46ad8r/diff",
                "WorkDir": "/var/snap/docker/common/var-lib-docker/overlay2/ry2s8zjui1mt9g5ih6z46ad8r/work"
            },
            "Name": "overlay2"
        },
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:9400805d96a1f8e975412ac9e084d2e0ccc0885624753ddac7f0c8750fbcb1b3",
                "sha256:95dbc77126e33abedcd2e4a5543c9d522cf04575256873ac99b0dae9feeaae6d",
                "sha256:fdc431a0f571f3c0c1a54ed899153d81655dbc4d48ed3ceba7ae7fc880b7a5b7",
                "sha256:79cc03b0939fa0786fabeef97cf2e9bc7b2ab0ed35ef46f6f9695a924c1cd083",
                "sha256:b596c0acdee607e0a60b97a3e0079118dc8a53b90821bda4f8dfaebb8f575ef2",
                "sha256:f724834867380e33ee575a14a7908560822a1f5d48932a246bfa7486045a01c3",
                "sha256:c02242ab715aea442491fe76cba3b3920240ff8a941bd89b196ee77e0a84c953",
                "sha256:24a579b6fc5b41e4baac3ef9c5d26ee9ae3d5b002f063d7ac7aeac0ccda72e11",
                "sha256:61e5cc310d787c6a62e93c4af41807c66a780cb48885692d1a47ec0b8281cad1",
                "sha256:96c870841581c5900e777d4eec77a72da672ff7a96e45ccdd54143d1e691699f",
                "sha256:e1b06cda0da826b53fe1c6efe8fcd2809ba9cc22a21a6c64d2e78a684d9a395a",
                "sha256:87a42f5d3cc556ee68eff01333fa30fd0662e11b5bd4eb609230c63f017c15c2"
            ]
        },
        "Metadata": {
            "LastTagTime": "0001-01-01T00:00:00Z"
        },
        "Config": {
            "ArgsEscaped": true,
            "Cmd": [
                "node",
                "server.js"
            ],
            "Entrypoint": [
                "docker-entrypoint.sh"
            ],
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NODE_VERSION=25.2.1",
                "YARN_VERSION=1.22.22"
            ],
            "ExposedPorts": {
                "8000/tcp": {}
            },
            "Labels": null,
            "OnBuild": null,
            "User": "",
            "Volumes": null,
            "WorkingDir": "/app"
        }
    }
]
gibson@gibbs-yavar:~$
```

# Copying Files Into & From A Container

First you need create following folder inside the project folder.

```bash
dummy/
└── text.txt

1 directory, 1 file

```

```bash
$ docker cp <source_path> <container_name:destination_path>
```

```bash
$ docker cp dummy/. <containerName>:test
```

```bash
$ docker cp dummy/. dreamy_rosalind:/test
Successfully copied 2.56kB to dreamy_rosalind:/test
```

And Delete the test from the dummy folder

```bash
$ docker cp dreamy_rosalind:/test dummy
```

```bash
$ docker cp dreamy_rosalind:/test dummy
Successfully copied 2.56kB to /home/gibson/Documents/gibson/learning/learn-docker/nodejs-app-starting-setup/dummy
```

Now the folder structure will be like

```bash
dummy/
└── test
    └── test.txt

2 directories, 1 file
```

This commant would allow you to add something to a container without restarting the container and rebuiding the image.

---
