[Containers](DevOps-Containers.md){:target="_blank" rel="noopener"} are a best practice for deployment, *and* offer several advantages for development.  This outlines a typical scenario for running and testing API Logic Server projects prior to deployment.

![Container Overview](images/docker/container-dev-deploy.png)

## Running Containers

You can run your container locally, or from DockerHub.  Running locally is clearly a good choice for development.

&nbsp;

### Local Testing

You will typically want to test your image before pushing it to DockerHub.  Use the [run-image](https://github.com/ApiLogicServer/tutorial/blob/main/3.%20Logic/devops/docker/run_image.sh), as shown below[^1].

For example, to run your project container directly, you can 

```bash
sh devops/docker-image/run_image.sh run_image.sh
```

&nbsp;

#### `environment` variables

Note you can use **env variables** to configure your servers and ports.  For more information, [click here](DevOps-Container-Configuration.md#overridden-by-env-variables){:target="_blank" rel="noopener"}.

&nbsp;

#### Arm machines

The procedures described here presume a team that uses amd (Intel) machines.  Docker has different procedures to deal with arm-based Macs (M1, M2...).

If you use the procedures above, Docker will create images for amd.  Such images will run slowly on arm, but in most cases that's fine for dev testing.

&nbsp;

#### Multi-architecture images

You can build images that operate under either environment.  

However, this is not done using the `docker build` command shown here.  Instead, you use `docker buildx`, which must be performed in the context of a build environment.  For an excellent article showing how to do this, [click here](https://medium.com/geekculture/docker-build-with-mac-m1-d668c802ab96#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjY3NmRhOWQzMTJjMzlhNDI5OTMyZjU0M2U2YzFiNmU2NTEyZTQ5ODMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2ODk1Mzk1NjgsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwOTU2MTk5NTc1MzE3MTM0NTcyOSIsImVtYWlsIjoidmFsamh1YmVyQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJuYW1lIjoiVmFsIEh1YmVyIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FBY0hUdGZFeFUxNTllcVNUSGpXYm9qS2pfaG5WY3VZRjRxeXUtMkN6SGRzc1dTZmNvVT1zOTYtYyIsImdpdmVuX25hbWUiOiJWYWwiLCJmYW1pbHlfbmFtZSI6Ikh1YmVyIiwiaWF0IjoxNjg5NTM5ODY4LCJleHAiOjE2ODk1NDM0NjgsImp0aSI6Ijc0YWM4NGQ3YzhjNWEwZTE3YjMzMDdjYjRlOTJhMzFjNDMzZjdiMWQifQ.VvCoA5Dd2KYhOvlkh8ejR_gp-vt83rpSbKYfL5xImYxj_99fdZOaEJJVNfP3mzzzyRhiQousI2aPVEdv51TKwG4FxVAnTOikjYp88y1WE3cOk_46ci-kavsHH0vN3zK3CI3-FK889yxIPbna8Wo_A8USwbLZcwTRucG7dKceRL9J0UcVgLk4JRv5ZQ1TJ_y5yLcddvSo_79x4O7fIX6WmrDHOfK16EqPYtsqyE1PuSnJtdddyP_ZLsRcDJflb5iHAIuNkQz1soL4fdOlh5T57pl734igWdbJNSufSKpLm9RzVN_E-Dvkk7ND6tEuOMs09DUdXhArcS_PTprQmYqE2g).


&nbsp;

### Team Testing

Once you have `pushed` images to DockerHub, your fellow developers can run them in their local environments.

&nbsp;

### Cloud Testing

Cloud container testing is significantly more challenging that in an IDE.  There are some steps we recommend that can make it easier[^1]:

1. Test with `env` variables - cloud containers pass parameters using `env` variables, typically not with command line arguments.  These typically identify your database locations etc.

    * A VSCode Run configuration `ApiLogicServer ENV` is provided for this, so you can begin testing in your IDE.<br>

2. Use the `VERBOSE` env variable to activate logging

3. Then test  by running your container locally, setting env variables per your OS.  See the CLI examples shown above.


## ApiLogicServer Container upgrades

You can update your image to a new version:

```bash
docker pull apilogicserver/api_logic_server
```

If you update your ApiLogicServer container to a new version, your existing VSCode projects may appear to be damaged.  You can fix them easily:

1. Click the Dev Container button (in the lower left)
1. Choose **Rebuild Container**


&nbsp;

## Start docker and load/run API Logic Project from `GitHub`

The `api_logic_server` image supports startup arguments so you can control the `api_logic_server` container, by running a startup script.  You can run your own script, or use the pre-supplied script (`/home/api_logic_server/bin/run-project.sh`) to load/run a git project.  For example:

```bash
docker run -it --name api_logic_server --rm --net dev-network -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost apilogicserver/api_logic_server sh /home/api_logic_server/bin/run-project.sh https://github.com/valhuber/Tutorial-ApiLogicProject.git /localhost/Project-Fixup.sh
```

will load the pre-built sample project from git, and run it.  Prior to execution it runs `/localhost/Project-Fixup.sh`, which in this case resets ui/admin files, like this:

```bash
#!/bin/bash

echo " "
echo "Project-Fixup script running"
pwd; ls
echo " "

cp ui/admin/admin_custom_nw.yaml ui/admin/admin.yaml
```

Instead of using a startup script, you can also use environment variables to achieve the same effect:

```bash
docker run -it --name api_logic_server --rm --net dev-network -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost   -e APILOGICSERVER_GIT='https://github.com/valhuber/Tutorial-ApiLogicProject.git' -e APILOGICSERVER_FIXUP='/localhost/Project-Fixup.sh' apilogicserver/api_logic_server
```


[^1]:
    Several changes were made as of release 9.01.17.  It is available as preview; [click here](index.md#getting-started){:target="_blank" rel="noopener"}
    


