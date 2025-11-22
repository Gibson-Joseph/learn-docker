## When we run the container its by default attached with container so we can listen to output printed by the continer, but we're not attached to it in the sense of being able to enter anything, we can't input anything into the container.

```bash
$ docker run <image_id>
```

```bash
gibson@gibbs-yavar:~$ docker run 6a083297fa4b
Please enter the min number: Traceback (most recent call last):
  File "/app/rng.py", line 3, in <module>
    min_number = int(input('Please enter the min number: '))
                     ~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
EOFError: EOF when reading a line
gibson@gibbs-yavar:~$

```

So we need fix this

```bash
$ docker run -it <image_id>
(or)
$ docker run -i -t <image_id>
```

We can restart with attached mode.

```bash
3.12.4 (base) gibson@gibbs-yavar:~$ docker start -a elegant_antonelli
Please enter the min number: 10
sldfs
gibson
joseph
```

But its only once ask the input from the user

So we can able to restart the container and being able to input something again.

```bash
$ docker start -at <container_name>
(or)
$ docker start -a -t <container_name>
```

```bash
gibson@gibbs-yavar:~$ docker start -a -i elegant_antonelli
Please enter the min number: 1
Please enter the max number: 42
37
gibson@gibbs-yavar:~$

```
