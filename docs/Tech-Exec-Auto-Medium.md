
## GenAI-Logic Governance architecture

AI is fast, it's simple, but a little scary - where's the Governance?

We created an architecture for governance:

1. **Context Engineering** directs AI to generate Data Rules — not procedural code.  Intent becomes declarations.
2. **Data Rules** distill path-dependent logic into path-independent rules on data. See them below— `Rule.constraint, Rule.sum`. No missed paths. Every path inherits them automatically.
3. The **Commit Listener** hooks into the ORM commit. Every transaction — API, agent, workflow — passes through one control point.  Nothing bypasses it.
4. The **Rule Engine** computes dependency order from the Data Rules at startup — deterministically. No pattern-matching, no subtle ordering bugs.

![doc](images/architecture/logic-architecture.png)

&nbsp;

## Why This Matters

Based on current research, the top 5 CIO concerns in 2026 listed below.  This architecture directly addresses the hilit items:

**1. AI Governance & Operationalizing Agentic AI**<br>
AI takes the NASCIO number one spot for the first time, overtaking cybersecurity which held the top position for 12 straight years. The concern isn't adopting AI — it's governing it responsibly at scale.

2. Cybersecurity & Risk Management<br>
For the third year running, cybersecurity and risk management stands out as the number one focus area for enterprise CIOs Evanta — now made more complex by AI expanding the attack surface.

**3. Data Quality & Governance**<br>
Foundational to everything else — AI is only as good as the data it runs on. Data sovereignty and compliance are increasingly prominent.

4. Technical Debt & Modernization<br>
Legacy ERP platforms, brittle data architectures, and custom applications that cannot scale or integrate with modern tools Itexecutivescouncil are blocking AI readiness.

5. Workforce Transformation<br>
Reskilling teams for an AI-augmented environment — redefining roles, not just adding tools.

&nbsp;

## Fallout: Executable Requirements

This enables AI to fully deliver on its promise - executable requirements.  The process below creates a running system - some setup, and then a prompt for logic, custom APIs, Messaging, and Security.

&nbsp;

### Initial Creation

The setup below creates a project from an existing database.  It creates a project you can open in your IDE (standard Python) and run, providing:

* **JSON:API:** an endpoint for each table, with pagination, optimistic locking, filtering, sorting, etc.  With Swagger.

    * In minutes, you have an MCP-discoverable API.  Vibe custom APIs.

* **Admin App:** a multi-table admin app, providing master detail, lookups, etc.


```bash title="Establish Initial State, Execute Requirements"
# A - Create project from existing database
genai-logic create --project_name=demo_eai --db_url=sqlite:///samples/dbs/basic_demo.sqlite

# B - In created project, get these requirements
$ cp -r ../samples/requirements/demo_eai/ .

# C - Optionally, configure security
$ (cd devops/keycloak; docker compose up -d)
$ genai-logic add-auth --provider-type=keycloak --db-url=localhost

# D - Create system from requirements
implement requirements docs/requirements/demo_eai
```

The following is the exact prompt (steps 1-6) you can then submit to create logic, custom APIs, Messaging, and Security.  AI uses the Context Engineering create executable software.

&nbsp;

**1. Business Logic — Check Credit**

```gherkin
Feature: Check Credit

  Scenario: Place an order
    Given a customer with a credit limit
    When an order is placed
    Then copy the price from the product
    And multiply by quantity to get the item amount
    And sum item amounts to get the order total
    And sum unpaid order totals to get the customer balance
    And reject if balance exceeds the credit limit
```

**2. B2B API — Accept orders from external partners**

```gherkin
Feature: B2B Order Integration

  Scenario: Accept order from external partner
    Given an inbound B2B order in partner format (message_formats/order_b2b.json)
    When the order is received via a Custom API endpoint named OrderB2B
    Then map Account to Customer by name
    And map Items.Name to Product by name
    And map Items.QuantityOrdered to Item.quantity
    And create the order with all Check Credit rules enforced
```

**3. Kafka Subscribe — Inbound orders from sales channel**

```gherkin
Feature: Kafka Subscribe Order Integration

  Scenario: Accept inbound orders from sales channel
    Given an inbound order message in JSON format (message_formats/order_b2b.json)
    When the message is received from Kafka topic order_b2b
    Then use the 2-message pattern
    And save the raw payload as a blob in the first transaction
    And parse and persist the order in the second transaction
    And map Account to Customer by name
    And map Items.Name to Product by name
    And map Items.QuantityOrdered to Item.quantity
    And create the order with all Check Credit rules enforced
```


**4. Kafka Publish — Notify shipping on dispatch**

```gherkin
Feature: Kafka Publish Shipping Notification

  Scenario: Notify shipping when an order is dispatched
    Given an Order exists
    When date_shipped is set
    Then publish to Kafka topic order_shipping
    And use message_formats/order_shipping.json as the message shape
    And use by-example publish rather than key-only publish
```


**5. Security**

```gherkin
Feature: Row-Level Security
  Scenario: Sales role sees limited customers
    Given a user with the sales role
    When querying the Customer list
    Then only return customers where credit_limit >= 3000 or balance > 0
```

**6. How to Test**

Test without Kafka (automatically created debug endpoint bypasses Kafka entirely):

`curl "http://localhost:5656/consume_debug/order_b2b?file=docs/requirements/demo_eai/message_formats/order_b2b.json"`

Kafka is optional. To test with live Kafka:

  1. Start Docker: `docker compose -f integration/kafka/dockercompose_start_kafka.yml up -d`
  2. Reset topics: `bash integration/kafka/order_b2b_reset.sh`
  3. Restart the server (after Docker is up, so it picks up Kafka env vars and subscribes to topics)
  4. Send a test message using the curl command above


## More On Rules

So how does this really run?

As shown below, AI (directed by context engineering) generates "data rules" in Python.  Ai works with a variety of formats - Gherkin (above), or plain text (below).

![distill rules](images/ui-vibe/assistant/$2%20Distill%20Rules.png)


Constrast this AI without context engineering - those same 5 rules generate over 200 lnes of code - 40X.  This is not just unwieldy - it introduces significant **correctness issues**.

AI pattern matching introduces subtle errors.  When we asked AI to create logic without rules, we identified several errors.  This provoked AI - *on its own* - to document this.  To see the study, [click here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/logic/procedural/declarative-vs-procedural-comparison.md){:target="_blank" rel="noopener"}

* The Governance Architecture addresses this by delegating dependency management to the rules engine.  Dependencies are automatically computed on startup, deterministically.  Note how automatic invocation and ordering directly simplify maintenance.

&nbsp;

**Beyond correctness, rules confer signficant advantage:**

**Readable**<br>
The rule is the requirement. Business and IT read the same artifact. No translation layer no gap between specification and implementation.  Your intent is not lost.

**Auditable**<br>
Every transaction traces to the rule that governed it. Rules fire automatically on every path, without exception — so the audit trail is complete by construction. Requirement → rule → execution log. Compliance can prove governance, not just assert it.

**Maintainable**<br>
Change the business logic, change the rule. Self-ordering - no archaeology, no missed paths, no ripple analysis, no regression surprises.

**Familiar tools**<br>
Python, your IDE, your debugger, your source control, deploy as container. Rules live in the repo like everything else. No proprietary lock-in, no new stack to learn.

**Enduring**<br>
New agents, new endpoints, new developers. All inherit the same rules automatically. Governance doesn't erode as the system grows.

**Optimized**<br>
Non-RETE engine, purpose-built for transactional performance at commit.. When the rule is the requirement, governance becomes a strategic asset — not a discipline you enforce, but an architecture you deploy.



## Real World

1. Allocation: 1 prompt (vs. 4 devs x 2 years)
2. Customs: XR vs months with traditional framework