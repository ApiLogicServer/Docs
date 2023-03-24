[Containers](../DevOps-Containers){:target="_blank" rel="noopener"} are a best practice for deployment, *and* offer several advantages for development.  This outlines a typical scenario for running and testing API Logic Server projects prior to deployment.

![Container Overview](images/docker/container-dev-deploy.png)

## Running Containers

Once you have `pushed` images to DockerHub, your fellow developers can run them in their local environments.

For example, to run your project container directly...

```bash
docker run -it --name your_project --rm --net dev-network -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost your_account/your_repository

# start the image, but open terminal (e.g., for exploring docker container)
docker run -it --name your_project --rm --net dev-network -p 5656:5656 -p 5002:5002 -v ${PWD}:/localhost your_account/your_repository bash
```

&nbsp;

### Testing

Cloud container testing is significantly more challenging that in an IDE.  There are some steps we recommend that can make it easier:

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


