!!! pied-piper ":bulb: WebGenAI - Installing the Docker Container"

      GenAI is a web app that creates database systems from a Natural Language prompt.  For background, [see Why WebGenAI](https://www.genai-logic.com/publications/webgenie){:target="_blank" rel="noopener"}.
      
      You can access WebGenAI either at:
      
      * the [public trial site](https://apifabric.ai/admin-app/){:target="_blank" rel="noopener"}, or 
      * as a docker container - described here
      
&nbsp;

## WebGenAI Docker Installation

If you have installed API Logic Server (recommended, but not required), the [Manager Readme](Manager.md){:target="_blank" rel="noopener"} includes install instructions.

Otherwise, you can run it locally as follows:

```bash title="Run the WebGenAI Docker Container"
mkdir webgenai
cd webgenai
docker run -it --rm --name webgenai apilogicserver/web_genai
```

This will guide you through the registration process.  

After installing, [verify WebGenAI operation](WebGenAI-verify.md){:target="_blank" rel="noopener"}.
  
> Note: the *Suggestion: ApiLogicServer start* is for API Logic Server users [using the Manager with the Docker images](Manager.md#manager-using-docker){:target="_blank" rel="noopener"}; you can ignore this message).
