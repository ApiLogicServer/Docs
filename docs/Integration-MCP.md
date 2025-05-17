!!! pied-piper ":bulb: TL;DR - MCP: Enable Bus Users to use NL to create multi-service execution flows"

	MCP enables Business Users to use Natural Language to create declarative execution flows across multiple business-rule-enforced API services.  MCP is an open protocol than enables:
	
	1. **MCP Client Executors** to leverage LLMs to tranlate NL queries into multi-step execution flows called **Tool Context Blocks.**. 
	2. The MCP Client Executor executes the Tool Context block steps, making calls on the  **MCP Server Executors.**
	
		* MCP Server Executors are commonly provided via **logic-enabled JSON:APIs.**  (Note the logic is critical in maintaining integrity and security.)
	
	In some cases, you may have a database, but neither the APIs nor the logic.  GenAI-Logic API Logic Server can **mcp-ify existing databases** by:
	
	3. Creating JSON:APIs for existing databases with a single CLI command
	4. Enabling you to [declare business logic](Logic.md), which can be used via the APIs in MCP executipn flows.

 

## Architecture:

![Intro diagram](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/MCP_Arch.png?raw=true)  

1. MCP Client Executor Startup

	* Calls *wellknown* endpoint to load schema
	* This schema is similar to `docs/db.dbml` (already created by als)

2. MCP Client Executor sends Bus User ***NL query + schema*** (as prompt or tool definition) to the external LLM, here, ChatGPT (requires API Key).  LLM returns an ***MCP Tool Context*** JSON block.

	* An MCP Client Executor might be similar in concept to installed/Web ChatGPT (etc), but those *cannot* be used to access MCPs since they cannot issue http calls.  This is an internally developed app (or, perhaps an IDE tool)

		* We are using a test version: `integration/mcp/mcp_client_executor.py`
	* Tool definitions are OpenAI specific, so we are sending the schema (in each prompt)

		* Note this strongly suggests this is a **subset** of your database.  
	* This schema is derived from `docs/db.dbml` (already created by als)
 

3. MCP Client Executor iterates through the Tool Context, calling the JSON:API Endpoint that enforces business logic.

Here is a typical `https://localhost:5656/.well-known/mcp.json` response (not yet implemented):

```json
{
  "tool_type": "json-api",
  "base_url": "https://crm.company.com",
  "resources": [
    {
      "name": "Customer",
      "path": "/Customer",
      "methods": ["GET", "PATCH"],
      "fields": ["id", "name", "balance", "credit_limit"],
      "filterable": ["name", "credit_limit"],
      "example": "List customers with credit over 5000"
    }
  ]
}
```


&nbsp;

## Example: send emails for pending orders


The **basic_demo** sample enables you to create orders with business logic to check credit by using rules to roll-up item amount to orders / customers.  Setting the `date_shipped` indicates payment is received, and the customer balance is reduced.

In this example, we want a new service to:

1. Find Orders placed over 30 days ago that are not shipped
2. Send an Email encouraging prompt payment

We want to do this without troubling IT by enabling business users, while maintaining integrity.  MCP meets this need.

&nbsp;

### Setup

There are 2 projects we have used for testing:  

1. **basic_demo:** preferred, since has update - from Dev Source, run run config: `Create blt/genai_demo_ as IS_GENAI_DEMO`

2. **NW:** In the Manager, open `samples/nw_sample_nocust`, and explore `integration/mcp`. This has been successfully used to invoke the server, including with authorization.

3. Create in manager

4. Run `als add-cust` to load mcp tests

5. Run `python integration/mcp/mcp_client_executor.py`


You will need a ChatGPT APIKey.

&nbsp;
### Prompt

Here is a NL prompt using *basic_demo:*

```
List the orders created more than 30 days ago, and send a discount offer email to the customer for each one.

Respond with a JSON array of tool context blocks using:
- tool: 'json-api'
- JSON:API-compliant filtering (e.g., filter[CreatedOn][lt])
- Use {{ order.customer_id }} as a placeholder in the second step.
- Include method, url, query_params or body, headers, expected_output.
```

%nbsp;

### Sample Flow

#### MCP Client Executor

![0-MCP-client-executor](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/0-MCP-client-executor.png?raw=true) 

#### 1 - Discovery

![1-discovery-from-als](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/1-discovery-from-als.png?raw=true) 

#### 2 - Tool Context from LLM

![2-tool-context-from-LLM](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/2-tool-context-from-LLM.png?raw=true) 

#### 3 - Invoke MCP Server

![3-MCP-server response](https://github.com/ApiLogicServer/Docs/blob/main/docs/images/integration/mcp/3-MCP-server-response.png?raw=true) 


&nbsp;

### Status: Work In Progress

This is an initial experiment, with a number of ToDo's: real filtering, update, etc.  That said, it might be an excellent way to explore MCP.

We welcome participation in this exploration. Please contact us via [discord](https://discord.gg/HcGxbBsgRF).

This exploration is changing rapidly. For updates, replace `integration/mcp` from [integration/msp](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/api_logic_server_cli/prototypes/nw_no_cust/integration/mcp){:target="_blank" rel="noopener"}.

&nbsp;
## Appendix 1: Exposing Corp DB to public MCP

TBD - investigate exposing a corp db to MCP so it can be discovered and used in a choreography.

&nbsp;
## Appendix 2: MCP Background

  

For more information:

  

- [see MCP Introduction](https://modelcontextprotocol.io/introduction)

- [and here](https://apilogicserver.github.io/Docs/Integration-MCP/)

- [and here](https://www.youtube.com/watch?v=1bUy-1hGZpI&t=72s)

- and this [N8N link](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-langchain.mcptrigger/?utm_source=n8n_app&utm_medium=node_settings_modal-credential_link&utm_campaign=%40n8n%2Fn8n-nodes-langchain.mcpTriggerlangchain.mcpTriggerlangchain.mcpTrigger)

- and this [python sdk](https://github.com/modelcontextprotocol/python-sdk)

- and [this video](https://www.youtube.com/shorts/xdMVgZfZ1yg)