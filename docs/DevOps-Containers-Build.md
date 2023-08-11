[Containers](../DevOps-Containers){:target="_blank" rel="noopener"} are a best practice for deployment, *and* offer several advantages for development.  This outlines a typical scenario for building images for API Logic Server projects.

!!! pied-piper ":bulb: TL;DR - edit/use the pre-built dockerfile to `build` and `push` your project"

    `devops/docker-image/build-image.dockerfile` is pre-built into your project.  Alter it for your organization and project name.  It contains instructions for using it via the command line to `build` and `push` your image.


![Container Overview](images/docker/container-dev-deploy.png)

The diagram above identifies 3 important images you can build, described below.

&nbsp;

## MyApp: containerize project

This is the image you will deploy for production.  It includes Python, API Logic Server, any additional packages your require, and your app (Python and logic).  These are defined by a `dockerfile`. 

API Logic Projects[^1] include a `devops/docker-image/build-image.dockerfile` for containerizing your application, shown are right in the diagram below. [Click here to see the key files](https://github.com/ApiLogicServer/demo/tree/main/devops/docker-image){:target="_blank" rel="noopener"}.

A key aspect of images is that you can *extend* an existing image: add new software to build another image.  See the line:

```
FROM --platform=linux/amd64 apilogicserver/api_logic_server
```

This builds your projects' image, starting with API Logic Server image, for amd (Intel) platforms.

![Docker Repositories](images/docker/container-creation.png)

To build an image for your ApiLogicProject:

1. On Docker Hub, create a docker repository under your docker account. 
2. Create / customize your project as your normally would
3. Edit `build-image.sh`: change `your_account/your_repository` as appropriate
    * Here is [an example](https://github.com/ApiLogicServer/demo/blob/main/devops/docker/build_image.sh){:target="_blank" rel="noopener"}
4. In terminal (not in VSCode docker - docker CLI is not installed there), <br>`cd < your-project>`
5. Run `build-image.sh`: <br> `sh devops/docker/build_image.sh .   # builds the image locally`
    * Test the image locally - [see Run Container](../DevOps-Containers-Run)

6. Deploy to Docker Hub

```bash
docker tag your_account/your_repository your_account/your_repository:1.00.00
docker login
docker push your_account/your_repository:1.00.00
```

To run your project container, see the next page.

&nbsp;

## MyPkgs: Containerize Packages

Your project may require additional packages not already included with API Logic Server.  You have 2 choices how to include these:

* Standard `pip` - per Python standards, your project includes a `requirements.txt` file; update it with your dependencies.

* If your team is using Dev Containers for development, it is a best practice to establish dependencies in a new image `MyPkgs`, then build your `MyApp` container from that.

&nbsp;

## MyDB: Test Databases

One of the great things about Docker is the ability to install popular databases, with no hassle.  Follow the procedures described in [Connection Examples](../Database-Connectivity/#docker-databases){:target="_blank" rel="noopener"}.

If you wish, you can add your own database / test data to the pre-supplied [repositories](https://hub.docker.com/repositories/apilogicserver){:target="_blank" rel="noopener"}, and then build an image from the updated result.

> [See here](../Tech-Docker/#preparing-a-database-image-for-self-contained-databases){:target="_blank" rel="noopener"} for notes on how to update / save a docker image.

In most cases, images are code, not data.  The DBMS images, however, include their own data.  This enables fellow developers to `run` the image and get started, without having to understand and setup volumes for DBMS data.


[^1]:
    Several changes were made as of release 9.01.17.  It is available as preview; [click here](../#preview-version){:target="_blank" rel="noopener"}
    