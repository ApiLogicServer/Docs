---
title: webgenai
source: docs/WebGenAI-Install.md
notes: gold is proto (-- doc); alert for apostrophe
do_process_code_block_titles: True
version: 0.24 from docsite, for readme 7/11/2025
---

!!! pied-piper ":bulb: WebGenAI - Installing the Docker Container"

      WebGenAI is a web app that creates database systems from a Natural Language prompt.  For background, [see Why WebGenAI](https://www.genai-logic.com/publications/webgenie){:target="_blank" rel="noopener"}.
      
      You can access WebGenAI as a docker container, as described here.

      This is particularly good way to jump-start vibe-coding:
      
      1. Use WebGenAI to create a database and API - *with logic*
      2. Extend with your IDE
      
          * Download the project to extend logic and APIs, and 
          * Use your IDE AI Coding Tools for custom UIs
      
&nbsp;

## WebGenAI Docker Installation

If you have installed API Logic Server (recommended, but not required), the [Manager Readme](Manager.md){:target="_blank" rel="noopener"} includes install instructions.

![webg-install](images/manager/mgr-webgenai.png)

Otherwise, you can run it locally as shown below:

```bash title="Run the WebGenAI Docker Container"
mkdir ApiLogicServer
cd ApiLogicServer
mkdir webgenai
cd webgenai
docker run -it --rm --name webgenai apilogicserver/web_genai
```

This will guide you through the registration process.  You will need to update the docker-compose file with keys for GenAI-Logic and ChatGPT.

After installing, [verify WebGenAI operation](WebGenAI-verify.md){:target="_blank" rel="noopener"}.
  
> Note: the *Suggestion: ApiLogicServer start* is for API Logic Server users [using the Manager with the Docker images](Manager.md#manager-using-docker){:target="_blank" rel="noopener"}; you can ignore this message).

&nbsp;

### Install API Logic Server

You can iterate WebGenAI projects, for example to tune the data model and add logic.

If you want to customize further with Python, then install API Logic Server.  Use the `ApiLogicServer` directory you created above, and proceed as described in [Express Install](Install-Express.md){:target="_blank" rel="noopener"}.

&nbsp;

### Import WebGenAI Project

The projects you create in WebGenAI can be customized in your IDE.  For more information, see [Export / Customize](WebGenAI.md#export-customize).

&nbsp;

### Concurrent WebGenAI and API Logic Server

You can continue using both WebGenAI and API Logic Server on the same project - see [IDE-Import-WebGenAI](IDE-Import-WebGenAI.md){:target="_blank" rel="noopener"}.
