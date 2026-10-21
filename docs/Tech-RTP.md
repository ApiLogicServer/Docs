# The Report Nobody Wrote

I heard of a large company that kept a developer whose real job was reading the code to find out what the business policy actually was.  The documentation was hopeless, so he was the documentation.  A human parser.

Now AI writes the code.  The volume went up, and the author went away.  So who reads it now?

That question is where enterprise AI stalls.  The demo is stunning; then someone asks who signs off.  Ask CIOs what stands between AI and production and governance is the answer you keep hearing — not as a vague anxiety, but as a concrete problem: a system nobody can say for certain what it does.

&nbsp;

## Two answers that don't close the gap

The tooling market mostly presumes one of two answers.

**More process.**  Review gates, sign-offs, documentation standards.  But process governs artifacts, and the artifact here is a few hundred lines of generated code per use case, plus documents that start drifting from the code the day they're written.  Methodology applied to an unreadable representation is ceremony: the review happens, the reading doesn't.

**Better models.**  The next model will generate better code.  Probably true, and beside the point: a better model generates the same volume, faster.  What you have to read doesn't shrink, and your trust still rests on reading it.  The problem is the representation, not the capability.

&nbsp;

## Change the representation

A requirement says too little — we *want* AI to fill in details, so the prompt no longer says what the system does.  Code says too much: in [an A/B test](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md) on a small order system, a five-line credit policy became about 200 lines of AI-generated procedural code, with two bugs in the change paths it missed.

There is a representation in between: declarative rules — close to the requirement's own level, but complete and deterministic.  Here is that credit policy, in full:

```python
Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
Rule.formula(derive=models.Item.amount,
             as_expression=lambda row: row.quantity * row.unit_price)
Rule.sum(derive=models.Order.amount_total, as_sum_of=models.Item.amount)
Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total,
         where=lambda row: row.date_shipped is None)
Rule.constraint(validate=models.Customer,
    as_condition=lambda row: row.balance <= row.credit_limit,
    error_msg="balance ({row.balance}) exceeds credit limit ({row.credit_limit})")
```

AI still does the writing — the rules are generated from the requirement.  But now review means reading five rules, not auditing 200 lines.  And the engine runs them on every commit — API, UI or agent, insert, update or delete — so what you read is what runs.  (The architecture behind that is covered in [You Can't Govern What You Can't Read](Tech-Surtax.md).)

&nbsp;

## The report

Change the representation, and something else becomes possible: the governance document can be *generated*.

Every project includes a [Requirements Traceability Report](Behave-Logic_Report-bd-eai.md) — produced from the project's own files and its last test run, nothing written by hand.  Each requirement is listed beside the rules that implement it, the tests that exercise it, and the engine's own log of the rules firing, old and new values included.

From the sample linked above, a B2B order-integration system:

- 5 requirements, all implemented; 4 tested — the report names the gap (Security)
- 8 rules: 5 declarative, 3 Python events
- 14 of 14 test scenarios passed; 7 of 8 rules shown running in a test log — and why the 8th can't be matched
- 6 integration channels (Kafka topics and HTTP endpoints); 2 flagged because no test mentions them

Note that half of that list is gaps.  That's deliberate.  A governance report you can believe is one that reports its own holes — and because it's regenerated, not maintained, it can't drift into flattery.

&nbsp;

## Parseable: what readable can't do

Readable gets a human through a review.  The stronger property is **parseable**: the description of the system can be computed from the system.

Everything in that report was derived by parsing the declarations: the rules list, the requirement-to-rule coverage in both directions, the derived-column map, the role-by-permission security matrix, the untested requirements, the untested channels, the dependency diagram.  Nobody wrote any of it, and nobody has to keep it current.

With procedural code, each of those is an inference — someone, or something, reading 200 lines and guessing at the dependency graph.  That's the human parser again.  With declared logic there is nothing to infer: the dependencies aren't mined from the code, they *are* the code.  Platforms are investing heavily right now in harvesting metadata from systems after the fact and inferring how the pieces relate.  Declared logic skips the inference — the metadata is the source, so it's exact.

The reader doesn't have to be human, either.  Ask an AI to audit five declared rules and it can check each against the requirement's own words.  Ask it to audit 200 lines of procedural code — even code it wrote itself — and it's back to inference.

&nbsp;

## What this doesn't claim

The parseable part is the declarative rules.  The Kafka handlers in the sample are Python events, and the report can only quote their docstrings — its own summary line says so: *5 declarative, 3 Python events*.  The report also states what it cannot show: whether a published message actually reached the broker, whether an event's run had an effect, or whether the requirements themselves are right.  Those limits are printed in the report, not buried here.

&nbsp;

## The point

Governance isn't a stage you add, and it isn't a model release you're waiting for.  It's a property of the representation.  Make the logic declared, and reading it becomes feasible — and parsing it becomes automatic: the policy, the coverage, and the gaps, in one document nobody wrote.

See the generated report [here](Behave-Logic_Report-bd-eai.md) — from a [sample app](Sample-Basic-EAI.md) for [GenAI-Logic](https://www.genai-logic.com/), free to use, source available.
