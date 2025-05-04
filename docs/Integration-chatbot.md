**ChatBots** are extensions to team collaboration systems (Microsoft Teams, Slack, DIscord) that can interface to other systems, such as OpenAI Functions for data inquiry / update.

>For example, in large companies, users spend significant time in such systems to the point it becomes their central UI.  So, enabling access to key corporate systems, with a Natural Language interface, is a natural way to simpify business.

This is to explore:

| Explore          | Status |
| ---------------- | ------ |
| ChatBot to Slack | --     |
|                  |        |

A value prop might be summarized: *instantly expose legacy DBs to Natural Language from collaboration tools, including critical business logic and security, to simplify user discovery and operation.*

<br>

## Status: Technology Evalution

We are solicting reactions to such a capability.

We welcome participation in this exploration.  Please contact us via [discord](https://discord.gg/HcGxbBsgRF).

<br>

## Example

✨ Flow example: “Create order for ALFKI with 2 bottles of Chai”:

1. User sends message in Slack/Teams
2. Bot passes message to backend
3. Backend sends message to GPT function-calling endpoint
4. GPT returns function call:

→ POST /Order { customer_id: "ALFKI", items: [{product_id: "CHAI", quantity: 2}] }

5. Backend sends API request to your OpenAPI endpoint
6. Backend replies in Slack:

→ “✅ Created order #1024 for ALFKI with 2 items”