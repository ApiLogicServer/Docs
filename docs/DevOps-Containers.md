Containers are a best practice for deployment.  They *also* offer several advantages for development.  This page outlines a typical scenario for API Logic Server projects.

## Containers: What and Why

![Container Overview](images/docker/container-dev-deploy.png)

As shown above, you can

1. Use the Docker CLI (Command Language Interface) to `build` images.  An image might be an API Logic Server, or a DBMS.  In either case, it is:

     * *self-contained* - includes all its dependencies (you identify these in the `dockerfile` which is input to the `build` command), and 

     * *isolated* - containers are protected from incoming and outgoing access except through well-defined network and file access

2. These images can be `pushed` to Docker Hub as `repositories`, where they can be shared with other developers, and for production deployment.

3. Developers can `run` an image, whether on Windows, Macs or Linux systems - a running image is called a `container`.

Containers provide significant well-known advantages for development and deployment:

* simplified __development__ by eliminating an otherwise complex install (Python, packages, etc)

* popular runtime __deployment__ platform, based on a standard Linux base

* __isolation__ - in both cases, Docker applications encapsulate their environment, eliminating external dependencies.  Likewise, Docker applications will not affect other applications running on the same hardware.

    * Avoid the *install A breaks B* problem

* __performance__ - containers are very light-weight (e.g., do not contain overhead for Operation System), so start quickly and minimize resource consumption.  For example, my laptop has 3 DBMSs; they start in a second, and consume little overhead.

* __sharing__ - containers are easy to share between developers (e.g., a test DBMS) via Docker Hub

* __portable__ - containers can run on Windows, Macs and Unix systems.

ApiLogicServer therefore provides support for building images, and for dev containers.

&nbsp;

## Dev: Local, Container, Cloud

You can [install](../Install-Express){:target="_blank" rel="noopener"} API Logic Server either:

* As a **Local** `pip` install,
* Or, use **Dev Containers,** by running the pre-supplied API Logic Server image
    * This avoids the sometimes tricky Python install.
    * This image contains Python and all the packages used by API Logic Server.
    * You can use it with VSCode `.devcontainer` support as described in the [install guide](../Install-Express){:target="_blank" rel="noopener"}.   This provides full IDE support: code editing, debugging, source control, etc.
    * For more information, see [Dev Containers](../DevOps-Docker){:target="_blank" rel="noopener"}.
* Or, run in the cloud using **Codespaces** - no install at all

In any case, you'll be using a source control system such as `git`, so it's possible to mix and match these configurations among developers.

&nbsp;

## API Logic Server Containers

API Logic Server pre-supplies several [repositories](https://hub.docker.com/repositories/apilogicserver){:target="_blank" rel="noopener"} (images available on Docker Hub):

* [Several DBMSs](../Database-Connectivity){:target="_blank" rel="noopener"}, so you can explore connectivity and as a quick-start for development

* API Logic Server itself (here is the [dockerfile](https://github.com/valhuber/ApiLogicServer/blob/main/docker/api_logic_server.Dockerfile){:target="_blank" rel="noopener"}):   

![API Logic Server Intro](images/docker/docker-container.png)

You can use it in 2 ways:

   * for dev - as described in [Dev Containers](../DevOps-Docker){:target="_blank" rel="noopener"}

   * to build images - to share with developers, or deploy to cloud providers (e.g., Microsoft Azure, Amazon AWS, etc)

For more information, see [Architecture](../Architecture-What_Is).

&nbsp;

## Container-ready projects

Projects you create with API Logic Server are container-ready:

* they contain the `.devcontainer` directory to enable Dev Container use

* they contain `devops/docker/build-container.dockerfile` for building your container for deployment ("MyApp", above)