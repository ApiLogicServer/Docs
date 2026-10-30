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

!!! pied-piper ":bulb: TL;DR - Recover the requirements from legacy code, rebuild as rule-based systems"

    Modernization seeks to upgrade the technology of legacy systems to modern software architectures.  That's valuable - better performance, easier to find developers, etc.

    But legacy systems are typically opaque: business policy is hidden behind code written long ago.  Governance requires we clearly understand how our systems enforce our business policy, and provide a sound basis for evolving it.  A technology modernization moves the opacity to a new stack; it doesn't remove it.
    
    Recent technology enables:
    
    1. Using **AI to Extract Requirements** from legacy systems
    2. Using **GenAI-Logic to create rule-based systems**
   
    The resultant systems is not only modernized - it is governed by declarative, spreadsheet like rules you can:

    * **read:** rules are ~40x more concise, and automate complex dependency management
    * **trust:** rules are automatically run at commit time - every transaction source, every path, no bypass
    * **maintain:** rules are self-ordering, so you can add new rules without execution-path archaeology.  Just add new rules, and you can trust they will always be run, in the right order.  

      * Without that, a rewrite recovers the requirements and then buries them again in new procedural code, and the documentation drift starts over.  [More on why rules](Tech-Modernization-Automation.md#why-rules){:target="_blank" rel="noopener"}.
    
    The process creates documentation for understanding and managing the process:
    
    *  The Ad-Lib report lists every judgment call it made, so a person can confirm them
    *  The Requirement Traceability Report lists all the extracted requirements, and their associated rules.  It also list tests - created by the system - and confirms which rules ran.

    We have run this twice.  The results are encouraging, but results on your system are hard to predict: see [what we can and cannot say](#what-we-can-and-cannot-say).

&nbsp;

## The problem

Modernization seeks to upgrade the technology of legacy systems to modern software architectures.  That's valuable - better performance, easier to find developers, etc.

But legacy systems are typically opaque: business policy is hidden behind code written long ago.  Governance requires we clearly understand how our systems enforce our business policy, and provide a sound basis for evolving it.  A technology modernization moves the opacity to a new stack; it doesn't remove it.

Recent AI technology is starting to extract - recover - business logic from legacy code bases.  In short, the business requirements.

GenAI-Logic can turn requirements into rule based systems, where the rules _are_ the governance: executable documentation you can read, trust and maintain.  See [this companion article](Tech-RTP.md){:target="_blank" rel="noopener"}.

&nbsp;

## The process

![Legacy to requirements to modernized system](images/articles/Modernization/modernization_overview.svg)

Three steps.

**1. Recover.**  AI reads the legacy code and writes down what it does, in plain language: the data, the business rules, the integrations, the security.  The result is a requirements document.  It describes what the code does, which is not always what the business meant, so a person should read it.  It often records behavior nobody had written down.

**2. Rebuild.**  The requirements go to GenAI-Logic, which builds a new system from them: the database and API, declarative rules for the business logic, tests generated from the rules, logic diagrams, and a Requirements Traceability Report that shows each requirement beside the rules and tests that implement it.  The AI follows a short script, one line per task.

**3. Review.**  Wherever the requirements stopped and the AI had to decide, it records the decision in an *ad-libs* report, with the ones a person must check marked.  The more the AI infers, the more this list matters.  A person decides each item.

&nbsp;

### What the script and the requirements look like

The rebuild is driven by a script like this, pasted to the AI assistant:

```
create project demo_eai_modernized from samples/dbs/basic_demo.sqlite

add security (degrade to SQL if Keycloak is not available)

implement requirements samples/requirements/demo_eai_modernize/demo_eai

verify message subscriptions (all topics)

create logic diagram for each requirement (skip if graphviz is not available)

create tests from rules, using default names

run the tests

run the requirements traceability report
```

"implement requirements" names the recovered requirements.  An excerpt:

> 4. **Customer Balance Rollup (Unshipped Orders Only)**: `Customer.balance` is recalculated as the sum of `Order.amount_total` across all **unshipped** orders (`date_shipped IS NULL`) for that customer whenever affected orders or items change, an order is reassigned to a different customer, `date_shipped` is set/cleared, or an order is deleted.
>
> 5. **Credit Limit Enforcement**: Whenever a customer's `balance` is recalculated or an existing customer's `credit_limit` is updated, the system verifies `balance <= credit_limit`.  If exceeded, `CreditError` is raised (`"{name}: balance {balance} exceeds credit limit {limit}"`), aborting the transaction.

Plain statements of behavior, with no code.  The AI turns each into rules.

![The creation script and the requirements recovered from the legacy code](images/articles/Modernization/create_script.png)

*Left: the creation script.  Right: the requirements it implements, recovered from the legacy code.*

&nbsp;

## The experiments

We have run the process twice.

| | [Controlled sample](Tech-Modernization-Automation.md){:target="_blank" rel="noopener"} | [ERPNext](Tech-Modernization-ERPNext.md){:target="_blank" rel="noopener"} |
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

The test we would most like to see is an older, messier codebase, recovered independently by a second model, with the results compared.  If you have one, that is the experiment worth running.

&nbsp;

> **Rules are the governance**<br> - Enforcement You Can Trust<br> - Documentation You Can Read

