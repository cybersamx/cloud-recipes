# Docker Best Practices

Here are some best practices for building Docker containers for production.

## Base Image

Pick the right Docker base image depending on your needs.

* Tag with slim means light version of the base OS distro.
* In general if the size of the container is important, use an Alpine base image.
* If you want to go extreme with security and size, use distroless.

## Be Specific on Base Image Version

Usually specifying the docker image, eg. `FROM golang` without a tag is bad because this will always retrieve the latest version of node. In practice, it is good to be specific on the version of image (and even with the base OS distro). For example:

```dockerfile
FROM golang:1.14.9-alpine3.12
```

By being explicit, we can guarantee that the container is running the same code we expect it to be.

## Reduce Number of Layers

Every statement in a Dockerfile creates a layer in the Docker container, which takes up space. With more layers, the size of the Docker image increases. 

The following example creates 3 layers.

```dockerfile
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y libgcc
```

Whereas the following the accomplishes the same thing creates 1 layer (and a slightly smaller image size).

```dockerfile
RUN apt-get update && \
    apt-get install -y gcc libgcc
```

## Order of Statements to Optimize Layer Caching

Docker builds images by reading the statements from a Dockerfile. A Docker image is comprised of a series of read-only layers that correspond to the statements in a Dockerfile - `COPY`, `ADD`, and `RUN` commands create layers.

To make the operation more efficient, Docker caches the resultant layer when executing each statement in the Dockerfile. Docker will determine if anything is changed by comparing the actual content with the cached content and reuse the content from the previous build as much as possible.

* For `COPY` and `ADD` commands, the contents of the files that are copied to the image are examined and a checksum is determined for each file. That checksum is compared to the checksum of the files in the cache.
* For `RUN`, only the statement is compared. The files associated or produced by the `RUN` command isn't used to determine a cache hit.

"Once the cache is invalidated, all subsequent Dockerfile commands generate new images and the cache is not used." In other words, it is best to put `RUN`, `COPY`, or `ADD` commands that are subjected to less change at the beginning of the Dockerfile so that they will be reused more frequently. So instead of copying the entire directory and then install/build the project, we generally break the build process this way:

1. Copy the `package.json` over so that we have a manifest for installing the required packages.
1. Install the packages.
1. Copy the application source code over.
1. Build the application.

The rationale is that the installation of packages is long and the dependencies don't change as often as the application source code. We want to cache the former as much as possible. For node.js Dockerfile, here's  how the Dockerfile looks like:

```dockerfile
WORKDIR /app
COPY package*.json ./
RUN npm ci --production && npm clean cache --force
COPY src/ ./
```

## Package Version Pinning

When caching a `RUN` statement, . As a result, we want to include a version to the package. This way when we get to retrieve the version we specify in the Dockerfile and not what was cached.

Here're the handy links to common package repositories:

* [Alpine](https://pkgs.alpinelinux.org/packages)
* [Debian](https://packages.debian.org/index)

### Alpine

For Alpine, the syntax for package version pinning is:

* package_name=a.b.c - Package named package_name with the exact version a.b.c
* package_name>a.b.c - Package named package_name with the minimum version a.b.c

```dockerfile
RUN apk add --no-cache \
    git \
    gcc=10.2.0-r5
```

According to Alpine, they can drop any package version from any branch in the official Alpine package - see [this thread](https://gitlab.alpinelinux.org/alpine/abuild/-/issues/9996). There's a real risk of pinning to an exact version of a package as that exact package may not be available in the future, which can potentially cause issue for your Dockerfile. It might be a good idea to set a minimum package version.

### Debian

For Debian, the syntax for package version pinning is:

* package_name=a.b.c - Package named package_name with the exact version a.b.c

```dockerfile
RUN apt-get install -y \
    git \
    gcc-10=10.2.0-6
```

## Use Multistage

Say we have the following Dockefile that builds and runs the Node.js application.

```dockerfile
FROM node:alpine
WORKDIR /app
COPY --chown=node:node package.json index.js ./
RUN npm install
USER node
EXPOSE 8080
CMD ["node", "/app/index.js"]
```

We can use multistage Docker to build a smaller Docker image. All the layers in the build stage will be copied over to the last stage as 1 layer.

```dockerfile
FROM node:alpine as build
WORKDIR /app
COPY package.json index.js ./
RUN npm install

FROM node:alpine
COPY --from=build --chown=node:node /app /app
USER node
EXPOSE 8080
CMD ["node", "/app/index.js"]
```

## Signal Handling

We want the Node.js application running in the container to receive the system signals SIGTERM (through `docker stop`) and SIGINT (CTRL-C), and then shuts itself down gracefully. Docker waits for a grace period 10 seconds for the application to shut down before resorting to sending a SIGKILL signal to kill the process running the application. We should avoid SIGKILL as much as possible as it can unwanted errors and interruptions. It's always desirable to shut an application down gracefully so that we can close any existing connections (to the database or other hosts) and resources.

The best way to handle SIGINT and SIGTERM are:

1. Implement system signal handlers in the application code.
1. If we don't have access to the source code:
   1. Install the program `tini` which will forward SIGINT and SIGTERM to the application.
   1. Run the Docker container using `--init` argument, ie. `docker run --init -d [docker-image]`.

Starting the application through the `CMD` command ensures that application receives the system signals.

> **Note**
>
> While running Docker container using `docker-compose up`, you press CTRL-C. This sends a SIGINT to the running application, which is effectively the same as `docker-compose stop`. If your application implements code for handling the receiving SIGTERM and logs the event, you won't see any messages printed on the console. This is by design, "docker-compose stop piping logs into console at this time, so don't expect to read any container output trapping termination signal." The signal is still received by the application. To see the message, run `docker logs [container-name]`. See [here](https://github.com/docker/compose/issues/7135) for details.

## Use .dockerignore

The `.dockerignore` file is great for controlling what files get excluded in a `COPY` or `ADD` command during the Docker build phase. This not only helps to control the size of Docker image by excluding non-relevant files, but prevent sensitive files eg. `.env` and `.aws` being copied over to the Docker image.

## Run as Non-Privileged User

Always run the application in the container as a non-root user. Most base Docker images have already created a nonroot user.

## Application Logging

There's no one solution to application logging with Node.js Docker container. One of the easiest setup with the most effective outcome is to simply log the application to stdout and stderr in a structural format. Typically, a Docker container will be deployed to run on a platform like Kubernetes, AWS ECS, or GCP Cloud Run, where it will redirect the log output and consolidate them into a centralized persistent storage.

## Pass Configurations Using Environment Variables

[The Twelve-factor app](https://12factor.net/config) advocates storing the configuration in environment variables. A Node.js application running in a Docker container is no different, every configuration should be passed or overridden by an environment variables. This way we keep the configurations separate from the code, and we can inject the configurations at deployment or runtime.

## Avoid Updating the Base OS

According to [Docker Best Practices with Node.js](https://medium.com/@nodepractices/docker-best-practices-with-node-js-e044b78d8f67), it's recommended not updating the local binaries during Docker build ie. `apt-get update` or `apk update`. It creates inconsistent images every time it runs. Instead, use base images that are updated frequently.

## References

* [Official Best Practices for Writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [Google Cloud: Best Practices for Building Containers](https://cloud.google.com/solutions/best-practices-for-building-containers)
* [Best Practice](https://medium.com/@nodepractices/docker-best-practices-with-node-js-e044b78d8f67)
* [Alpine Packages Search](https://pkgs.alpinelinux.org/packages)
* [Debian Packages Search](https://packages.debian.org/index)
