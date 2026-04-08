---
title: Integration EAI
do_process_code_block_titles: True
version: 1.4  4/7/2026
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

!!! pied-piper ":bulb: TL;DR - Kafka Integration: Async Messaging"

    APIs are useful for application integration, but do not deal with the reality that the receiving system might be down.

    Message Brokers like Kafka address this with guaranteed ***async delivery*** of messages.  The Broker stores the message, delivering it (possibly later) when the receiver is up.

    Message Brokers also support multi-cast: you ***publish*** a message to a "topic", and other systems ***subscribe***.  This is often casually described as "pub/sub".

    GenAI-Logic provides AI-driven support for both directions:

    * **Publish** — rules trigger outbound Kafka messages when row state changes
    * **Subscribe** — inbound messages are consumed, validated, and committed using the same reusable logic as your APIs



# Overview

## APIs and Messages

GenAI-Logic provides multiple approaches for integrations:

* Ad hoc access via automatically created self-serve APIs
* Custom APIs
* Kafka integrations — both outbound publication and inbound message subscription (pub/sub).

&nbsp;

![demo_kafka](images/integration/demo_kafka.png)

These approaches are typically more efficient than ETL-based integrations:

| Requirement | Poor Practice | Good Practice | Best Practice | Ideal
| :--- |:---|:---|:---|:---|
| **Ad Hoc Integration** | ETL | APIs | **Self-Serve APIs** |  **Automated** Self-Serve APIs |
| **Custom APIs** | | | Coded APIs | **Create with AI** |
| **Messages** | | | Coded Pub/Sub | **Create with AI** |
| **Logic** | Logic in UI | | **Reusable Logic** - any source | **Declarative Rules**<br>.. Extensible with Python |

* **APIs should be self-serve:** not requiring continuing server development — they avoid the overhead of nightly Extract, Transfer and Load (ETL)

* **Logic should be re-used** over the UI and API transaction sources — logic embedded in UI controls cannot be shared with APIs and message consumers

&nbsp;

## AI-based creation

Traditional API/Kafka integrations are fiddly — extensive hand-code or complex metadata.  With AI, you provide a message shape and name the exceptions; the system maps the rest:

1. **Sample message:** AI reads the JSON shape and auto-maps obvious fields silently — no entry needed for direct name matches
2. **FIELD_EXCEPTIONS — exceptions only:** specify renames, dot-notation joins (`Customer.name`), and child collections; everything else is inferred
3. **`_unresolved` guard:** fields AI can't map block server start — no silent failures

> For full working examples, see [Sample-Basic-EAI.md](Sample-Basic-EAI.md){:target="_blank" rel="noopener"}.

&nbsp;

# Publish — Outbound Kafka Messages

GenAI-Logic supports two publish patterns:

| Pattern | What's sent | How |
|---------|-------------|-----|
| **Key only** | `{"id": 42}` | Default — describe topic + trigger condition |
| **By-example** | Shaped message: selected fields, joins, child collections | Describe desired JSON sample → AI auto-matches obvious fields, adds `# TODO` on uncertain ones, blocks server start on unresolved |

!!! note "By-example"
    If all sample fields map with no ambiguity, no `_unresolved` list is generated and `FIELD_EXCEPTIONS` may be empty — the file is just `SAMPLE` + the rule.

&nbsp;

## Key Only — Event Notification

The default publish — just the primary key.  Consumer calls back to fetch current data.

```text title="🧑 You prompt"
Publish the Order to Kafka topic 'order_shipping' when date_shipped is set (key only).
```

**🤖 AI generates `logic/logic_discovery/order_shipping.py`:**

```python title="logic/logic_discovery/order_shipping.py (AI-generated)"
import integration.kafka.kafka_producer as kafka_producer
from logic_bank.exec_row_logic.logic_row import LogicRow
import models

def send_order_to_kafka(row: models.Order, old_row: models.Order, logic_row: LogicRow):
    if row.date_shipped is not None and row.date_shipped != old_row.date_shipped:
        kafka_producer.publish_kafka_message(
            topic="order_shipping",
            logic_row=logic_row)
        # → publishes: {"id": 42}

Rule.after_flush_row_event(on_class=models.Order, calling=send_order_to_kafka)
```

&nbsp;

## By-Example — Event-Carried State Transfer

For B2B or cross-org scenarios, publish a compound message so the consumer is self-contained.

```text title="🧑 You prompt — describe the outbound message"
Publish to Kafka topic 'order_shipping' when an Order is shipped (date_shipped is set).

The outbound message should look like this example:
{
  "order_id": 1,
  "order_date": "2026-04-06",
  "customer_name": "Alfreds Futterkiste",
  "total": 100.00,
  "items": [
    {
      "quantity": 2,
      "product_name": "Chai",
      "unit_price": 25.00
    }
  ]
}
```

**🤖 AI generates two files:**

- `integration/kafka/kafka_publish_discovery/order_shipping.py` — mapper config (SAMPLE, FIELD_EXCEPTIONS, `_unresolved` guard)
- `logic/logic_discovery/place_order/app_integration.py` — adds the `Rule.after_flush_row_event` that calls it

The AI matches sample fields to model columns by name.  Three outcomes:

| Outcome | What AI does | Server starts? |
|---------|-------------|----------------|
| ✅ Obvious match | Silent — no entry in `FIELD_EXCEPTIONS` | ✅ |
| ⚠️ Plausible guess | Entry in `FIELD_EXCEPTIONS` with `# TODO: verify` | ✅ — verify at test time, remove TODO when satisfied |
| ❌ No candidate | Added to `_unresolved` list — **server will not start** | ❌ — must fix first |

**AI also reports in chat immediately at generation time:**

> ✅ Generated `integration/kafka/kafka_publish_discovery/order_shipping.py` — **1 must-resolve**: `region` (no matching column found in Order, Customer, or Item). Fix `_unresolved` before starting the server.

```python title="integration/kafka/kafka_publish_discovery/order_shipping.py (AI-generated)"
from integration.system.EaiPublishMapper import serialize_row

# ✅ High-confidence auto-matches (no entry needed):
#   order_id    → Order.id
#   order_date  → Order.order_date
#   quantity    → Item.quantity
#   unit_price  → Item.unit_price

FIELD_EXCEPTIONS = {
    "customer_name": "Customer.name",   # TODO: verify — join via Customer relationship
    "total":         "amount_total",    # TODO: verify — rename from amount_total
    "items":         "ItemList",        # child collection: relationship name
    "product_name":  "Product.name",    # TODO: verify — join via Product from Item
}

# ❌ MUST RESOLVE — server will not start until this list is empty.
# For each entry: add correct mapping to FIELD_EXCEPTIONS above, then remove from here.
_unresolved = [
    "'region': no matching column found in Order, Customer, or Item",
]
if _unresolved:
    raise NotImplementedError(
        f"order_shipping.py: resolve before use:\n  " + "\n  ".join(_unresolved))

SAMPLE = {
    "order_id": None,
    "order_date": None,
    "customer_name": None,
    "total": None,
    "items": [
        { "quantity": None, "product_name": None, "unit_price": None }
    ]
}

def row_to_dict(row):
    return serialize_row(row, sample=SAMPLE, exceptions=FIELD_EXCEPTIONS)
```

```python title="logic/logic_discovery/place_order/app_integration.py (AI-generated addition)"
from integration.kafka.kafka_publish_discovery import order_shipping
import integration.kafka.kafka_producer as kafka_producer
from logic_bank.exec_row_logic.logic_row import LogicRow
import models

def send_order_to_kafka(row: models.Order, old_row: models.Order, logic_row: LogicRow):
    if row.date_shipped is not None and row.date_shipped != old_row.date_shipped:
        kafka_producer.publish_kafka_message(
            topic="order_shipping",
            logic_row=logic_row,
            mapper=order_shipping)

Rule.after_flush_row_event(on_class=models.Order, calling=send_order_to_kafka)
```

!!! note
    Publish mapper files are named after the topic (`order_shipping.py`) and live in `integration/kafka/kafka_publish_discovery/`, symmetric to `kafka_subscribe_discovery/` for subscribe.  `publish_kafka_message` with no `mapper` sends key-only.  The `EaiPublishMapper` engine handles dot-notation joins (`Customer.name`), child collection traversal, type serialization, and None-safe access.

&nbsp;

# Subscribe — Inbound Kafka Messages

Inbound Kafka messages are consumed, parsed, and committed using the same reusable business logic as your APIs.  This means credit checks, derivations, and constraints all fire — regardless of whether the transaction originates from a UI, an API call, or a Kafka message.

## What You Do

Describe the topic, the expected JSON payload, the target tables, and the field mappings:

```text title="🧑 You prompt — describe the inbound message"
Subscribe to Kafka topic `order_b2b` (JSON format).

The payload is a single order with items:
{
  "Account": "Alice",
  "Notes": "Kafka order from sales",
  "Items": [
    { "Name": "Widget",  "QuantityOrdered": 1 },
    { "Name": "Gadget", "QuantityOrdered": 2 }
  ]
}

Target tables: Order, Item (from models.py).

Field mappings:
- `Account` → look up Customer by Customer.name, set Order.customer_id
- `Notes` → Order.notes
- `Items` array → Item rows: `Name` → look up Product by Product.name, set Item.product_id; `QuantityOrdered` → Item.quantity
```

## What the System Does — The Two-Message Pattern

A single-transaction consumer loses data if parsing fails mid-flush — the raw payload is gone. Instead, the system generates a **two-message pattern** for reliability:

```
topic: order_b2b
  → Consumer 1:  save raw JSON blob → OrderB2bMessage  (Tx 1 — always commits)
  → row_event:   blob insert → publish to order_b2b_processed
  → Consumer 2:  parse → Order + Items, resolve FKs, LogicBank rules  (Tx 2)
```

Parse failures leave `is_processed = False` on the blob row — queryable and retryable.  The raw message is never lost.

The AI generates these key files:

| File | Role |
|------|------|
| `integration/kafka/kafka_subscribe_discovery/order_b2b.py` | Consumer logic — design details, field mapping, registration |
| `logic/logic_discovery/place_order/order_b2b_consume.py` | `row_event` bridge — publishes blob to `order_b2b_processed` (no inline parse) |
| `integration/OrderB2bMapper.py` | JSON → Order + Items (3-tier mapping contract) |
| `api/api_discovery/order_b2b_kafka_consume_debug.py` | `/consume_debug/order_b2b` — test without Kafka |
| `integration/kafka/message_formats/order_b2b.json` | Message format spec / test fixture |
| `test/order_b2b_reset.sh` | Reset Kafka topics + log between runs |

## Testing

Because the subscriber is wired to a debug endpoint, **no running Kafka instance is needed** for initial development and testing.

```bash title="Quick test — no Kafka required"
# APILOGICPROJECT_CONSUME_DEBUG=true must be set in config/default.env
python api_logic_server_run.py
curl 'http://localhost:5656/consume_debug/order_b2b?file=integration/kafka/message_formats/order_b2b.json'
sqlite3 database/db.sqlite "SELECT * FROM order_b2b_message; SELECT * FROM 'order'; SELECT * FROM item;"
```

```bash title="Live Kafka test"
docker compose -f integration/kafka/dockercompose_start_kafka.yml up -d
# Enable KAFKA_CONSUMER + KAFKA_PRODUCER in config/default.env
bash test/order_b2b_reset.sh       # recreates topics + clears log
# Start server; publish sample JSON to order_b2b topic
```

!!! note "Shared Logic"
    The subscribe consumer and your API endpoints use the **same** underlying logic rules.  There is no need to duplicate validation or derived-field logic for the messaging path.
