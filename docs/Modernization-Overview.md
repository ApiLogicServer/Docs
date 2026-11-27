<!--
Audience: senior architects, industry analysts, dev managers.
Landing page for the Modernization section: the idea, the steps, why rules, and the two experiments.
Pages: Tech-Modernization-Automation.md (controlled sample, demo_eai), Tech-Modernization-ERPNext.md (ERPNext credit control).
-->

<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

# Modernization: Recover the Requirements, Rebuild as Rules

!!! pied-piper ":bulb: A tech port moves the code to a new stack, with the business logic still buried in it.  <br>A modernization recovers the requirements and rebuilds them as rules you can read, trust, and maintain."

    An AI rewrite is a port too, only faster: it recovers the requirements, then buries them again in new procedural code, and the documentation drift starts over.

    Modernization is three steps:

    1. **Recover:** use AI to extract the requirements from the legacy system
    2. **Rebuild:** use GenAI-Logic to rebuild it as declarative rules: spreadsheet-like statements such as `balance <= credit_limit`, run by an engine on every commit
    3. **Review:** a person confirms the judgment calls the AI recorded where the requirements stopped

    The result is rules you can:

    * **read:** rules are far more concise than the code they replace ([~40x in our credit-check comparison](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md){:target="_blank" rel="noopener"}), and the engine manages the dependencies
    * **trust:** rules run automatically at commit time: every transaction source, every path, no bypass
    * **maintain:** rules are self-ordering, so you add a rule without execution-path archaeology and trust it will run, in the right order.  [More on why rules](Tech-Modernization-Automation.md#why-rules){:target="_blank" rel="noopener"}

The process also produces documents for managing it:

* The ad-libs report lists every judgment call the AI made, so a person can confirm them
* The Requirements Traceability Report lists the extracted requirements and their rules, plus the tests the system created, and confirms which rules ran

The rebuild covers the database, API, messaging, security, and business logic.  It does not address deployment or database migration.

We have run this twice, on small systems.  The results are encouraging.  We have not shown that a rebuild behaves the same as the original: see [what we can and cannot say](#what-we-can-and-cannot-say).

&nbsp;

## The process

![Legacy to requirements to modernized system](images/articles/Modernization/modernization_overview.svg){: style="height:500px"; align=right }

Three steps:

**1. Recover.**  AI reads the legacy code and writes down what it does, in plain language: the data, the business rules, the integrations, the security.  The result is a requirements document.  It describes what the code does, which is not always what the business meant, so a person should read it.  It often records behavior nobody had written down.

**2. Rebuild.**  The requirements go to GenAI-Logic, which builds a new system from them: the database and API, messaging, declarative rules for the business logic, tests generated from the rules, logic diagrams, and a Requirements Traceability Report that shows each requirement beside the rules and tests that implement it.  The AI follows a short script, one line per task.

**3. Review.**  Wherever the requirements stopped and the AI had to decide, it records the decision in an *ad-libs* report, with the ones a person must check marked.  The more the AI infers, the more this list matters.  A person decides each item.

For more on the automated reports, see ["What did AI Build"](Tech-RTP.md){:target="_blank" rel="noopener"}.

&nbsp;

## Sample Reference System

The source is `demo_eai_legacy`: an order-entry system with business logic in procedural code (SQLAlchemy session hooks), a REST API, Kafka, and Keycloak security, with its documents removed [^1].  The full experiment is [here](Tech-Modernization-Automation.md){:target="_blank" rel="noopener"}.

Both systems are included in your Manager, under `samples/modernization/`, so you can open each step's result:

| Step | Open |
|---|---|
| 1. Recover | `demo_eai_legacy/app/logic.py` (the legacy code) and `demo_eai_legacy/requirements_from_antigravity.md` (the recovered requirements) |
| 2. Rebuild | `demo_eai_modernized/logic/logic_discovery/` (the rules) and `demo_eai_modernized/docs/requirements/Requirements Traceability Report.md` |
| 3. Review | `demo_eai_modernized/docs/requirements/demo_eai/ad-libs.md` (the decisions for review) |

&nbsp;

### 1. Recover

The legacy code holds the policy in procedural session hooks.  An excerpt:

![legacy logic](images/articles/Modernization/extract.png)

AI read the code and wrote down what it does, in plain language.  An excerpt of the recovered requirements:

> 4. **Customer Balance Rollup (Unshipped Orders Only)**: `Customer.balance` is recalculated as the sum of `Order.amount_total` across all **unshipped** orders (`date_shipped IS NULL`) for that customer whenever affected orders or items change, an order is reassigned to a different customer, `date_shipped` is set/cleared, or an order is deleted.
>
> 5. **Credit Limit Enforcement**: Whenever a customer's `balance` is recalculated or an existing customer's `credit_limit` is updated, the system verifies `balance <= credit_limit`.  If exceeded, `CreditError` is raised (`"{name}: balance {balance} exceeds credit limit {limit}"`), aborting the transaction.

Plain statements of behavior, with no code.

&nbsp;

### 2. Rebuild


The rebuild is driven by a script like this, pasted to the AI assistant:

![The creation script and the requirements recovered from the legacy code](images/articles/Modernization/create_script.png)

*Left: the creation script.  Right: the requirements it implements, recovered from the legacy code.*
```
Check for Docker or Podman. If neither is running, continue in degraded mode (SQL security, simulated Kafka) and tell me so up front.

create project demo_eai_modernized from samples/dbs/basic_demo.sqlite

add security (degrade to SQL if Keycloak is not available)

implement requirements samples/requirements/demo_eai_modernize/demo_eai

verify message subscriptions (all topics)

create logic diagram for each requirement (skip if graphviz is not available)

create tests from rules, using default names

run the tests

run the requirements traceability report
When the report is done, print this verbatim: "Next: scan these two files: logic/logic_discovery/check_credit.py (the rules) and docs/requirements/demo_eai/ad-libs.md (the judgment calls the AI made). Then open the report: demo_eai_modernized/docs/requirements/Requirements Traceability Report.md (in VS Code: open the file, then Cmd/Ctrl+Shift+V for the rendered preview)."
```

"implement requirements" names the requirements recovered in step 1:

The AI turns each requirement into rules.  The credit policy, which was procedural code in the legacy system, becomes:

```python
Rule.copy(derive=models.Item.unit_price, from_parent=models.Product.unit_price)
Rule.formula(derive=models.Item.amount, as_expression=lambda row: row.quantity * row.unit_price)
Rule.sum(derive=models.Order.amount_total, as_sum_of=models.Item.amount)
Rule.sum(derive=models.Customer.balance, as_sum_of=models.Order.amount_total,
         where=lambda row: row.date_shipped is None)
Rule.constraint(validate=models.Customer,
                as_condition=lambda row: row.credit_limit is None or row.balance <= row.credit_limit,
                error_msg="{row.name}: balance {row.balance} exceeds credit limit {row.credit_limit}")
```

&nbsp;

### 3. Review

Where the requirements stopped, the AI decided, and recorded each decision in the ad-libs report.  A person confirms each one.  An excerpt:

<!-- TODO (Val): ad-libs excerpt image from samples/modernization/demo_eai_modernized/docs/requirements/demo_eai/ad-libs.md -->
![Ad-libs report excerpt: decisions the AI made beyond the requirements](images/articles/Modernization/ad_libs_excerpt.png)

*Decisions for review, for example: the shipping message is now published before the commit, not after; the `sales` role now comes from the token, not a configured username.*

&nbsp;

#### Governance

The requirements to rules report (for the full report, [click here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/manager/samples/modernization/demo_eai_modernized/docs/requirements/Requirements%20Traceability%20Report.md){:target="_blank" rel="noopener"}) documents each requirement, a set of tests, and rules that ran for each test:

![Rules Rpt](images/articles/Modernization/rules-rpt.png)

&nbsp;

## Vibe User Interfaces

The process above will create a server, including API and Logic, and a default "Admin UI".  Use [Vibe tools](Admin-Vibe-Sample.md){:target="_blank" rel="noopener"} to recreate user interfaces.  You can put them in the same project.  Be sure to remind API to access data via the API.

Many such tools can create apps from screen shots or code of your existing apps.

&nbsp;

## The experiments

| | Example 1: [Controlled sample](Tech-Modernization-Automation.md){:target="_blank" rel="noopener"} | Example 2: [ERPNext](Tech-Modernization-ERPNext.md){:target="_blank" rel="noopener"} |
|---|---|---|
| **Source** | An order-entry system AI built for the experiment, with its documents removed | The credit control in ERPNext, an open-source business application we did not write |
| **Policy** | Customer balance against a credit limit; shipping messages; partner orders | A customer's credit limit, enforced on four kinds of document with different bypass logic |
| **What it tests** | The process under controlled conditions, with a reference implementation to compare against | The process on real, unfamiliar, framework-heavy code, checked against the repository's own tests |
| **Rebuild starts from** | A sample database | An empty database: the AI designed the schema |
| **Result** | 8 rules, 35 of 35 scenarios passing, 6 decisions for review | 32 rules, 52 scenarios passing, 12 decisions for review |

Each page ends with an assessment of what that experiment does and does not show.

&nbsp;

## What we can and cannot say

It is hard to predict how this will go on your system.  The variety of legacy systems is virtually infinite: languages, frameworks, age, size, quality, how much of the policy lives in code, in the database, or in people's heads, and how well it is tested.  Two experiments tell us what happened in those two cases.  They do not tell us what to expect in yours.

What we can say:

- The process ran end to end both times, and produced a governed system: rules, tests, a traceability report, and a list of decisions for review.
- Extraction recorded behavior nobody had written down, and the review list surfaced places where the AI had guessed.
- The more the AI infers (an empty database, a vague requirement), the more the ad-libs report matters.

What we cannot say:

- That the rebuilt system behaves the same as the original.  Both experiments used the same family of AI assistants end to end, and we compared against the recovered requirements and, for ERPNext, the repository's tests by reading.  We did not run the original and the rebuild side by side.
- That it scales.  Both systems are small, and each was run once.
- That it works on old code.  Neither source is decades old.
- That it covers deployment or database migration.  Neither is addressed here.

The test we would most like to see is an older, messier codebase, recovered independently by a second model, with the results compared.  If you have one, that is the experiment worth running.

[^1]: We built the **[legacy system](https://github.com/ApiLogicServer/ApiLogicServer-src/tree/main/api_logic_server_cli/prototypes/manager/samples/modernization/demo_eai_legacy){:target="_blank" rel="noopener"}** using "native Claude" ***without GenAI-Logic***, from the same requirements as **[Basic Demo EAI](Sample-Basic-EAI.md){:target="_blank" rel="noopener"}** (so, with code not rules).  We then removed the docs.