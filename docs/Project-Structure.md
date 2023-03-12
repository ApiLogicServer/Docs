
## Project Structure

When you create an ApiLogicProject, the system creates a project like this that you customize in your IDE:

<figure><img src="https://github.com/valhuber/apilogicserver/wiki/images/generated-project.png?raw=true"></figure>

[Explore the Tutorial Project](https://github.com/valhuber/Tutorial-ApiLogicProject#readme), and observe that the projects are rather small.  That is because the system creates _models_ that define _what, not now_.  Explore the project and you will find it easy to understand the API, data model, app and logic files.

Note the entire project is file-based, which makes it easy to perform typical project functions such as source control, diff, merge, code reviews etc.


### IDE Friendly

The project structure above can be loaded into any IDE for code editing, debugging, etc.  For more information on using IDEs, [see here](https://github.com/valhuber/ApiLogicServer/wiki#using-your-ide).

### Tool-friendly - file-based

All project elements are files - no database or binary objects.  So, you can store objects in source control systems like git, diff/merge them, etc.

## Customizing ApiLogicProjects

You will typically want to customize and extend the created project.  Edit the files described in the subsections below.

The 2 indicated files in the tree are the Python files that run for the Basic Web App and the API Server.

Projects are created from a [system-supplied prototype](https://github.com/valhuber/ApiLogicServer/tree/main/api_logic_server_cli/project_prototype).  You can use your own prototype from git (or a local directory) using the ```from_git``` parameter.

## Architecture

The resultant projects operates as a (typically containerized) 3-tiered architecture, as [described here](../Architecture-What-Is).