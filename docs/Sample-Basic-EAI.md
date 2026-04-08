---
title: basic_demo_EAI
do_process_code_block_titles: True
version: 1.3 from docsite, for readme 4/7/2026
source: docs/Sample-Basic-EAI.md
Propagation: see api_logic_server_cli/sample_mgr/create_readme.py
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

!!! pied-piper ":bulb: TL;DR - Kafka Integration: Async Messaging"

    APIs are useful to application integration, but do not deal with the reality that the receiving system might be down.

    Message Brokers like Kafka address this with guaranteed ***async delivery*** of messages.  The Broker stores the message, delivering it (possibly later) when the the receiver is up.

    Message Brokers also support multi-cast: you ***publish*** a message to a "topic", and other systems ***subscribe***.  This is often casually described as "pub/sub".

    This sample presumes you are familiar with basic GenAI-Logic services, as illustrated in the Basic Demo tutorial.



## Overview


<br>

```bash title='🤖 Bootstrap Copilot by pasting the following into the chat'
Please load `.github/.copilot-instructions.md`
```

> **Important:** be sure CoPilot is in "Agent" Mode.  "Ask" will not work.  Also, we get consistently good results with `Claude Sonnet 4.6`.

&nbsp;

**System Requirements**

This app illustrates using IntegrationServices for B2B push-style integrations with APIs, and internal integration with messages.  

&nbsp;

![demp_kafka](images/integration/demo_kafka.png)

The **demo_kafka API Logic Server** provides APIs *and logic*:

1. **Order Logic:** enforcing database integrity and application Integration (alert shipping)

2. A **Custom API**, to match an agreed-upon format for B2B partners

3. **Standard APIs** for ad-hoc integration, user interfaces, etc

The **Shipping API Logic Server** listens on kafka, and processes the message.<br><br>

<br>

## 1. Create From Existing DB

<br>

<details markdown>

<summary> Create the Customer, Orders and Product Project [typically already done using Manager]</summary>

<br>

```bash title="In the Manager: Create a project from an existing database (probably already done)"
genai-logic create --project_name=demo_eai --db_url=sqlite:///samples/dbs/basic_demo.sqlite
```

<br>

</details>

<br><br>

## 2. Declare Business Logic

Logic (multi-table derivations and constraints) is a significant portion of a system, typically nearly half.  GenAI-Logic provides **spreadsheet-like rules** that dramatically simplify and accelerate logic development.

Rules are declared in Python, simplified with IDE code completion.  The screen below shows the 5 rules for **Check Credit Logic.**

**1. Stop the Server** (Red Stop button, or Shift-F5 -- see Appendix)

**2. Add Business Logic**

```bash title="Check Credit Logic (instead of 220 lines of code)"
on Placing Orders, Check Credit    
    1. The Customer's balance is less than the credit limit
    2. The Customer's balance is the sum of the Order amount_total where date_shipped is null
    3. The Order's amount_total is the sum of the Item amount
    4. The Item amount is the quantity * unit_price
    5. The Item unit_price is copied from the Product unit_price

Use case: App Integration
    1. Send the Order to Kafka topic 'order_shipping' if the date_shipped is not None.
```

![Nat Lang Logic](images/sample-ai/copilot/copilot-logic-vibe.png)

<br>

## 3. Message Formats — Define Before You Prompt

AI generates integrations **by example** — provide a sample message shape and it auto-maps obvious field names silently, lists exceptions you specify, and blocks server start on anything unresolvable.  Save your formats now; they double as test fixtures.

```bash title="Create message format specs"
cat > integration/kafka/message_formats/order_b2b.json << 'EOF'
{
  "Account": "Alice",
  "Notes": "Kafka order from sales",
  "Items": [
    { "Name": "Widget",  "QuantityOrdered": 1 },
    { "Name": "Gadget",  "QuantityOrdered": 2 }
  ]
}
EOF

cat > integration/kafka/message_formats/order_shipping.json << 'EOF'
{
  "order_id": 1,
  "order_date": "2026-04-06",
  "customer_name": "Alfreds Futterkiste",
  "total": 100.00,
  "items": [
    { "quantity": 2, "product_name": "Chai", "unit_price": 25.00 }
  ]
}
EOF
```

> See [Integration EAI](Integration-EAI.md#ai-based-creation){:target="_blank" rel="noopener"} for how AI uses these.

> **Tip — mappings belong here too.**  If you have complex or non-obvious field mappings, save them alongside the format file — in any structure that's clear to you and AI: a CSV, a plain-text table, extra comments in the JSON.  AI will read whatever you reference in the prompt.  Keeping mappings here (rather than embedded in the prompt) means they're versioned, reusable, and self-documenting.

&nbsp;

<br>

## 4. Custom API - B2B Orders

To fit our system into the Value Chain,
we need a **Custom API** to accept orders from B2B partners, and forward paid orders to shipping via Kafka.

``` bash title="Create the Custom B2B API Endpoint"
Create a B2B order API called 'OrderB2B' that accepts orders from external partners.

The external message format is in `integration/kafka/message_formats/order_b2b.json`.

Field mappings:
- 'Account' → find Customer by name, set customer_id
- 'Notes' → order notes
- 'Items' array → Item rows: 'Name' → find Product, 'QuantityOrdered' → item quantity

The API should create complete orders with automatic lookups and inherit all business logic rules.
```

The Kafka logic was created earlier, so we are ready to test — see Section 6.

<br>

## 5. EAI Subscribe — Inbound Kafka Message

The format file was already saved in Section 3.  Now prompt AI, referencing it:

```text title="Subscribe to sales message - Kafka Enterprise Application Integration"
Subscribe to Kafka topic `order_b2b` (JSON format).

The message format is in `integration/kafka/message_formats/order_b2b.json`.

Target tables: Order, Item (from models.py).

Field mappings:
- `Account` → look up Customer by Customer.name, set Order.customer_id
- `Notes` → Order.notes
- `Items` array → Item rows: `Name` → look up Product by Product.name, set Item.product_id; `QuantityOrdered` → Item.quantity
```

!!! note "Why mappings here but not in Section 7?"
    These mappings are **FK lookups** — `Account` isn't a column, it's a search key to find the right `Customer` row.  AI can't infer that from field names alone.  For publish (Section 7), the mappings are purely name-matching between the format file and `models.py` — something AI can do itself.

&nbsp;

<details markdown>

<summary>What Got Built?  The 2-Message Pattern</summary>

**Two-Message Pattern**

A single-transaction consumer loses data if parsing fails mid-flush — the raw payload is gone. Instead:

```
topic: order_b2b
  → Consumer 1:  save raw JSON blob → OrderB2bMessage  (Tx 1 — always commits)
  → row_event:   blob insert → publish to order_b2b_processed
  → Consumer 2:  parse → Order + Items, resolve FKs, LogicBank rules  (Tx 2)
```

Parse failures leave `is_processed = False` on the blob row — queryable and retryable.

**Key Files**

See the module docstring in [integration/kafka/kafka_subscribe_discovery/order_b2b.py](../integration/kafka/kafka_subscribe_discovery/order_b2b.py) for design details, field mapping, and test instructions. Supporting files:

| File | Role |
|------|------|
| `logic/logic_discovery/place_order/order_b2b_consume.py` | `row_event` bridge — publishes blob to `order_b2b_processed` (no inline parse) |
| `integration/OrderB2bMapper.py` | JSON → Order + Items (3-tier mapping contract) |
| `api/api_discovery/order_b2b_kafka_consume_debug.py` | `/consume_debug/order_b2b` — test without Kafka |
| `integration/kafka/message_formats/order_b2b.json` | Message format spec / test fixture |
| `test/order_b2b_reset.sh` | Reset Kafka topics + log between runs |

**Quick Test (no Kafka needed)**

```bash
curl 'http://localhost:5656/consume_debug/order_b2b?file=integration/kafka/message_formats/order_b2b.json'
```

</details>

<br>

## 6. Test

Observe that the API and message listener use the same underlying logic.

`integration/kafka/kafka_subscribe_discovery/order_b2b.py` illustrates unit testing:

```bash title="Test stand-alone, and with Kafka"
Debug / test (no Kafka required):
  APILOGICPROJECT_CONSUME_DEBUG=true is set in config/default.env
  1. Start server: python api_logic_server_run.py
  2. curl 'http://localhost:5656/consume_debug/order_b2b?file=integration/kafka/message_formats/order_b2b.json'
  3. Verify DB: sqlite3 database/db.sqlite "SELECT * FROM order_b2b_message; SELECT * FROM 'order'; SELECT * FROM item;"

Live Kafka:
  1. docker compose -f integration/kafka/dockercompose_start_kafka.yml up -d
  2. Enable KAFKA_CONSUMER + KAFKA_PRODUCER in config/default.env
  3. bash test/order_b2b_reset.sh       # recreates topics + clears log
  4. Start server; publish sample JSON to order_b2b topic
```


<br>

## 7. Publish — Outbound Kafka Messages (By-Example)

In Section 2, the logic prompt already generated a **key-only** publish rule: when `date_shipped` is set, it sends `{"id": 42}` — a notification that tells the consumer to call back for the current data.

Now let's upgrade that to **by-example**: a shaped message that carries all the data the consumer needs, so it never has to call back.  AI will replace the key-only rule in `app_integration.py` with the mapper-based version.  The outbound format was saved in Section 3 — just reference it:

```text title="Prompt for by-example publish"
Upgrade the order_shipping publish to by-example.

The desired outbound message format is in `integration/kafka/message_formats/order_shipping.json`.
```

!!! note "No mappings needed in the prompt"
    AI reads the format file and `models.py` and maps by name.  Direct matches are silent; uncertain ones get `# TODO: verify` in `FIELD_EXCEPTIONS`; anything unresolvable is added to `_unresolved` and **blocks server start** — reported to you in chat immediately.  Only add exceptions to the prompt if you want to override AI's inference.

For full details and generated code examples, see [Integration EAI — Publish](Integration-EAI.md#publish--outbound-kafka-messages){:target="_blank" rel="noopener"}.
