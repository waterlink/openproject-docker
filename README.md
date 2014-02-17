# OpenProject Docker

A Dockerfile that installs OpenProject.
Actually it installs `sshd`, `memcached`, `mysql server`, `rbenv`, `ruby 2.1`, `passenger`,and a fresh `openproject` development snapshot.

Please keep in mind, that we do **not** recommend to use the produced Docker image in production.
Why?
Because the docker team says that docker ["should not be used in production"](https://www.docker.io/learn_more/)

## Installation

First [install docker](https://www.docker.io/). Then do the following to build an openproject image (this may take some time):

```
$ git clone https://github.com/opf/openproject-docker.git
$ cd openproject-docker
$ docker build -t="openproject_evaluation" .
```

**NOTE:** depending on your docker installation, you might need to prepend `sudo ` to your `docker` commands

## Usage

To spawn a new instance of openproject:

```bash
$ docker run -p 8080 -d openproject_evaluation
```

The `-d` flag lets docker start the image in the background and prints the container id to stdout.
You'll see an ID output like:
```
d404cc2fa27b
```

Use the container ID to check the port it's on:
```bash
$ docker port <container-id> 8080
```

which gives you something like:
```
0.0.0.0:49190
```

We see that `49190` is the port the webserver is located at (it is probably different for you!).
You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:<port>
```

## Get a shell on your OpenProject image

Concurrently with the OpenProject server, we start an ssh deamon which listenes on the default port 22.
To connect to your OpenProject image, you have to tell docker to connect that port.
Start your image with the additional port:

```bash
$ docker run -p 8080 -p 20 -d openproject_evaluation
```

You may find out which of your local ports is mapped to the image-22-port with `docker port` and connect to your image:

```bash
$ ssh -p <port> openproject@localhost
$ openproject@localhost's password:
```

Well, we need a password now. The openproject account is secured with a random password.
We set that password during the image setup - watch for a line like `ssh openproject password: <random password>`
during the `docker build -t="openproject_evaluation" .` step.

