!!! pied-piper ":bulb: WebGenAI - Installing the Docker Container"

      WebGenAI is a web app that creates database systems from a Natural Language prompt.  For background, [see Why WebGenAI](https://www.genai-logic.com/publications/webgenie){:target="_blank" rel="noopener"}.
      
      You can access WebGenAI either at:
      
      * the [public trial site](https://apifabric.ai/admin-app/){:target="_blank" rel="noopener"}, or 
      * as a docker container - described here
      
&nbsp;

## WebGenAI Docker Installation

If you have installed API Logic Server (recommended, but not required), the [Manager Readme](Manager.md){:target="_blank" rel="noopener"} includes install instructions.

Otherwise, you can run it locally as shown below:

```bash title="Run the WebGenAI Docker Container"
mkdir ApiLogicServer
cd ApiLogicServer
mkdir webgenai
cd webgenai
docker run -it --rm --name webgenai apilogicserver/web_genai
```

This will guide you through the registration process.  

> This is particularly good way to jump-start vibe-coding: use WebGenAI to create a database and API - *with logic* - and then your IDE AI Coding Tools for custom UIs.

After installing, [verify WebGenAI operation](WebGenAI-verify.md){:target="_blank" rel="noopener"}.
  
> Note: the *Suggestion: ApiLogicServer start* is for API Logic Server users [using the Manager with the Docker images](Manager.md#manager-using-docker){:target="_blank" rel="noopener"}; you can ignore this message).

&nbsp;

### Install API Logic Server

You can iterate WebGenAI projects, for example to tune the data model and add logic.

If you want to customize further with Python, then install API Logic Server.  Use the `ApiLogicServer` directory you created above, and proceed as described in [Express Install](Install-Express.md){:target="_blank" rel="noopener"}.

&nbsp;

### Concurrent WebGenAI and API Logic Server

You can continue using both WebGenAI and API Logic Server on the same project - see [IDE-Import-WebGenAI](IDE-Import-WebGenAI.md){:target="_blank" rel="noopener"}.
