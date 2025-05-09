Model Context Protocol is a way for:

* LLMs to chorograph multiple MCP servers in a chain of calls.  MCPs support shared contexts and goals, enabling the LLM to use the result from 1 call to determine whether the goals has been reached, or which service is appropriate to call next.

* Chat agents to *discover* and *call* external servers, be they databases, APIs, file systems, etc.  MCPs support shared contexts and goals, enabling the LLM

For tech background, see Appendix 2.


This is to explore:

| Explore                                                           | Status |
| ----------------------------------------------------------------- | ------ |
| ALS Access via MCP                                                | Runs   |
| Nat Lang ALS Access from simple driver                            | Runs (simple query from test driver using `openai.ChatCompletion.create`) |
| Nat Lang ALS Access from LangChain                            | Blocked: import version issues |
| Nat Lang access from Chat (eg, ChatGPT) to (tunnelled) ALS Svr | Blocked - See Appendix 1<br>* MCP unable to pre-register resource schemas inside its system |
| ALS Svr can be choroegraphed by LLM (1 in a chain of calls)       | TBD    |
|

A value prop might be summarized: *instantly mcp-fy your legacy DB, including critical business logic and security*.

&nbsp;


## Status: Technology Exploration

This is an initial experiment, without automation.  Many substantive issues need to be addressed, including but not limited to security, update, etc.

We welcome participation in this exploration.  Please contact us via [discord](https://discord.gg/HcGxbBsgRF).

&nbsp;

## ALS Access via MCP 

In the Manager, open `samples/nw_sample_nocust`, and explore `integration/mcp`.  This has been successfully used to invoke the server, including with authorization.

Local testing:
1. Run `integration/mcp/3_executor_test_agent.py`


&nbsp;

## Access ALS with Nat Lang Query

The goal is *Nat Lang access from Chat*.  We begin with *Nat Lang ALS Access from simple driver.*

&nbsp;


### Nat Lang ALS Access from simple driver

Here we use a simple driver to simulate Chat access.

&nbsp;

#### Tunnel to local host with ngrok

Requires tunnel to local host such as [ngrok](https://ngrok.com/downloads/mac-os?tab=download), then

```
ngrok config add-authtoken <obtain from https://dashboard.ngrok.com/get-started/setup/macos>
```

then
```
ngrok http 5656
```

You should see:

![ngrok](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/ngrok.png?raw=true)

and note the url like: `https://mcp_url_eg_bca3_2601.ngrok-free.app -> http://localhost:5656`

We'll call it `mcp_url`.

&nbsp;

#### Use natlang_to_api

```
pip install openai==0.28.1
```

Fix API Keys and URLS, then run `natlang_to_api.py` (gateway not required).  Observe json result.

&nbsp;

### Nat Lang ALS Access from LangChain (not working)

Blocked on many import / version issues.  See `1_langchain_loader.py`.

&nbsp;

### Nat Lang access from Chat (not working)

This investigation has failed for 2 reasons:

1. Non-standard JSON:API: MCP insists on *strict* compliance.  We investigated a proxy to help.
2. See Appendex 1

For details:

1. From the Manager install, use: `samples/nw_sample_nocust`
2. Replace `integration/mcp` from [integration/msp](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/api_logic_server_cli/prototypes/nw_no_cust/integration/mcp){:target="_blank" rel="noopener"} 

&nbsp;


## Appendix 1: OpenAI Feedback

It appears that OpenAI is missing an enabling feature:

📢 Feedback: Unlocking Swagger-Based JSON:API Support in MCP
Summary:
As a developer, I have a fully functional REST API with a Swagger 2.0 spec and a proxy layer that emits strict JSON:API compliant responses. 

However, MCP fails to parse the results due to a ValueError, seemingly because the resource type ("type": "Customer") isn't known to MCP’s internal schema registry — even though it is fully defined in my Swagger spec.

Details:

The server replies with correct Content-Type: application/vnd.api+json
* Every item includes "type", "id", and "attributes"
* The response includes jsonapi and links
* Swagger 2.0 spec clearly defines the resource fields

Issue: MCP does not ingest the Swagger schema to understand new resource types or field structures, making machine-integration impossible — despite the API being fully compliant with both Swagger and JSON:API standards.

Request: Please support one (or more) of the following:

1. Auto-ingesting Swagger (OpenAPI) specs for schema understanding
2. Allowing users to register or upload resource types
3. Relaxing strict JSON:API parsing to tolerate unfamiliar types that are structurally valid
4. Benefit: This would unlock powerful real-world MCP integrations with actual APIs — enabling developers to query their real data using natural language, with minimal friction and zero backend changes.

&nbsp;

## Appendix 2: Tech Notes

Info courtesy ChatGPT...

&nbsp;

### LangChain

What LangChain Does:

* Chains together prompts, tools, memory, and agents
* Helps you call APIs, query databases, or browse documents using LLMs
* Provides standard components like:
* Prompt templates
* Retrieval (RAG)
* Agents (autonomous or guided)
* Tool wrappers (e.g., OpenAPI, SQL, Python functions)
* Memory modules

⸻

💡 Example Use Case:

“Build an agent that answers business questions using a SQL database + OpenAI.”

LangChain can:
1.	Accept a question from a user
2.	Convert it into a SQL query (via GPT)
3.	Run it on your database
4.	Return and explain the result

***See:*** `integration/mcp/1_langchain_loader.py`

&nbsp;

### MCP

![Intro diagram](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/MCP_Arch.png?raw=true)


For more information:

* [see mcp introduction](https://modelcontextprotocol.io/introduction)
* [and here](https://www.youtube.com/watch?v=1bUy-1hGZpI&t=72s)