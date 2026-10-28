<!--
DRAFT. Audience: senior architects, industry analysts, dev managers.
Headline: legacy code modernized, to rules. One sample only.

OPEN ITEM (resolve before publishing): the rebuild step (3) was run against the ORIGINAL
requirements (samples/requirements/demo_eai), not the distilled ones from step 2
(samples/requirements/demo_eai_modernize/demo_eai/requirements.md).
Re-run step 3 from the distilled file, then delete this note and the bracketed line in
"What this doesn't claim".
-->

<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

# Legacy Code, Modernized to Rules

## The problem

Legacy systems enforce business policy, but the policy lives in the code.  The requirements are gone, or never existed, and the one person who could say what the system does has moved on (see [What Did the AI Build?](https://apilogicserver.github.io/Docs/Tech-RTP/)).

Modernizing that code usually means reading it, guessing at intent, and rewriting it.  We tried to automate all three.

&nbsp;

## The experiment

One small system, three steps.  The tool for steps 2 and 3 was an AI assistant (Antigravity) with GenAI-Logic's context engineering loaded.

1. **The legacy system.**  We had AI build the *demo_eai* order system as a conventional application, with no GenAI-Logic: SQLAlchemy session hooks for the business logic, a REST API, a Kafka consumer and producer, Keycloak security.  Then we removed every document.  What remained was code and tests: a legacy system.
2. **Recover the requirements.**  The AI read the code and wrote down what it does, in plain language: six sections covering the data model, the business rules, shipping notifications, B2B intake, security and the API contract.
3. **Rebuild as rules.**  From the recovered requirements, the AI generated a new system: declarative business rules, tests, and a traceability report.

![How the projects were created](images/articles/Modernization/modernization_process.svg)

*The numbers match the list above.  Orange is the legacy side, green is the modernized result.  The reference implementation is the same requirements built directly with GenAI-Logic; box 5 was compared with it.  Boxes 1 to 4 and the reference are folders under the Manager's `samples/`; box 5 is created at the Manager root.*

&nbsp;

### Running step 3

Step 3 is a short script, pasted to the AI assistant.  It creates the project, then implements the requirements named on line 7, the ones recovered from the legacy code, and goes on to the tests and the report.

![The creation script and the requirements recovered from the legacy code](images/articles/Modernization/create_script.png)

*Left: the creation script.  Right: the requirements it implements, recovered from `samples/native_ai/demo_eai_legacy`.*

&nbsp;

## What came out

| | Legacy | Modernized |
|---|---|---|
| **Where the policy lives** | Session hooks in `app/logic.py` | Five declarative rules in `check_credit.py` |
| **Written requirements** | None | Recovered from the code, then traced to rules |
| **Judgment calls** | Invisible | Listed in an ad-libs report for review |
| **Evidence** | Tests | 13 of 13 scenarios passing, each embedding the engine's log of the rules that ran |
| **Governance** | Read the code | A Requirements Traceability Report: each requirement beside its rules and tests |

The rules for the credit policy:

```python
Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
Rule.formula(derive=models.Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
Rule.sum(derive=models.Order.amount_total, as_sum_of=models.Item.amount)
Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total,
         where=lambda row: row.date_shipped is None)
Rule.constraint(validate=models.Customer,
                as_condition=lambda row: row.balance is None or row.credit_limit is None
                                         or row.balance <= row.credit_limit,
                error_msg="balance ({row.balance}) exceeds credit limit ({row.credit_limit})")
```

We compared the result with a hand-built reference implementation of the same requirements.  Same schema, same five credit rules, same Kafka and security behavior.

&nbsp;

## Extraction finds things

The extraction step is more than a transcription.  Reading the legacy code, the AI noted that `Product.count_suppliers` exists in the schema, but no rule ever updates it.  A column that looks maintained and isn't.  Nobody had asked.

Once the policy is written down as requirements, this kind of gap is visible.  In the code, it was not.

&nbsp;

## Why rules

Modernization has an old failure mode: the rewrite is as unreadable as the original, so the problem is renewed, not solved.  Rules are the part that changes it.  They are close to the requirement's own level, executed by an engine that fires on every commit, and the report lists each requirement beside the rules that implement it.  The next system is one you can read.

&nbsp;

## What this doesn't claim

This is one small sample, run once.  It shows what the process does, not how often, and not at scale.  The legacy system was built by AI for this experiment; a real one will have years of undocumented decisions, and the extraction step will miss some.  The AI's recovered requirements describe what the code does, which is not always what the business meant; a human review of that document is the step that matters.  [Draft note: the rebuild in step 3 ran from the original requirements; a re-run from the recovered document is pending.]

&nbsp;

## Conclusion

Legacy code in, readable rules out, with the requirements recovered along the way and a report that shows the work.  Start with the recovered requirements, then the rules in `check_credit.py`, then the ad-libs report, then the traceability report.

> **Rules are the governance**<br> - Enforcement You Can Trust<br> - Documentation You Can Read

[GenAI-Logic](https://www.genai-logic.com/) — free to use, source available.
