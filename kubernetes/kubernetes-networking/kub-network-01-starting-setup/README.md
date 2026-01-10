# Pod-Interal Communication

For pod-internal communication, so when two containers run in the same pod, and that's important, only then, kubernetes allows you to send a request to the localhost address and then using the port which is expossed by that other container.
So the localhost is the magic address you can use inside of a pod.

So If you have one container running in a pod, which executes some code which also runs on the server side so to say, inside of the pod, and that code needs and address you can use a localhost as an address if you wanna send the request to another container running in the same pod.
