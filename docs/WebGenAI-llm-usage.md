!!! pied-piper ":bulb: WebGenAI - Installing the Docker Container"

      LLM (Large Language Model) usage is currently based on OpenAI, for:

      * Creating SQLAlchemy data models
      * Translating NL (Natural Language) logic into Python rules
      
&nbsp;

## Learning

When you install the [Manager](Manager.md){:target="_blank" rel="noopener"}, it creates the structures shown below.  These are used to "train" ChatGPT about how to create models, and how to translate logic.

![call_chatGPT](images/web_genai/internals/configure_chatGPT.png)

&nbsp;

## Invocation

The `api_logic_server_cli/genai` files are called by the CLI (which is called by WebGenAI) to create projects, iterate them, repair them, and so forth.  `api_logic_server_cli/genai/genai_svcs.py` is a collection of common services used by all, including the function `call_chatgpt()` shown below.  

![call_chatGPT](images/web_genai/internals/call_chatGPT.png)

&nbsp;

### ChatGPT Results: WGResult

Initially, we called ChatGPT and got the standard response, which in our case was a text file of code.  We parsed that to find the code we wanted, and merged it into the project.

That proved to be an unstable choice.  So, we now train ChatGPT results to return smaller code snippets, in json format.  This is defined by `WGResults`.It also contains the definitions of the `WGResult` objects.  Note these are defined both in the learnings, *amd* in `genai_svcs.py`.

&nbsp;

### `docs`: requests and responses

Requests and responses are stored in the project, which can be used for subsequent requests and error correction.  They can be stored in the location noted below (both the `docs` directory and its sub-directories):

![call_chatGPT](images/web_genai/internals/docs_dir.png)

Observe that a typical call the ChatGPT is a "conversation" - a list of `messages` (requests and responses) provided as an argument to ChatGPT.