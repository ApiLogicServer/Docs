# Governance by Architecture

### Why the Right Answer Finally Became Reachable

*By Wynford Reese and Val Huber*

---

I have spent a long career building and operating enterprise systems, and I have spent most of it watching governance-by-discipline fail.

Not loudly. Routinely. Audit findings on systems that had no AI involvement at all — traditional, hand-coded systems where rules were enforced on some paths but not others. Different teams, different services, different generations of code, all making honest decisions about where the check belonged. The exposure on a single engagement I have personal experience with reached eight figures.

That is governance not working — at scale, at cost, on systems that were supposed to be the well-understood ones.

The architectural answer has been understood for a long time. Stop scattering enforcement across application paths; put rules at the commit point, where every transaction must pass through. Triggers tried it decades ago and didn't settle the question, for reasons I'll come to. Declarative rules engines tried it more directly, and got the form right, but required analysts to learn to think in invariants — and that learning curve kept enterprise adoption out of reach for thirty years.

What changed recently is that the answer became reachable. AI bridged the gap that kept it out of reach.

This piece is about why this matters now, why the earlier attempts didn't settle it, and what the architecture actually produces.

---

When something looks like a real architectural answer, I write down a specification — Given, When, Then — and see if the structure holds. Here is the one I wrote for GenAI-Logic:

```gherkin
Feature: Governed Agentic AI

  Scenario: Enforce business rules across every transaction source

    Given GenAI-Logic, which allows Enterprise IT to enforce
          Agentic AI governance by architecture, not on
          development team discipline

    When Context Engineering turns requirements into declarative
         Data Rules attached to the data model

    Then a Commit Listener and Rule Engine automatically enforce
         them on every ORM commit, regardless of source —
         API, agent, or message
```

The structure held. The rest of this piece is the unpacking.

## The architecture, in one frame

![Logic Architecture](images/architecture/logic-architecture-exec.png)

Two funnels meeting in the middle.

On the left, **design time**. ① **NL Intent** is whatever form the requirement takes when an analyst, a regulator, or a product owner writes it down — regulations, Gherkin, pseudocode, rules-as-invariants. ③ **AI** translates that intent, directed by ② **Context Engineering**, into ④ **Data Rules**.

Data Rules are declarative statements attached to the data model. The closest analogy is spreadsheet formulas: a cell that says `= SUM(B2:B10)` does not need to know who or what changed B5. It recomputes automatically. Data Rules behave the same way — when underlying data changes, the rules that depend on that data recompute, regardless of what triggered the change. They are path-independent.

On the right, **runtime**. ⑥ **All Sources** — APIs, agents, workflows, anything that writes to the database — funnel through one point. ⑤ The **Rules Engine** sits at the **Commit** boundary and enforces the Data Rules on every transaction, with no bypass.

The two funnels meet at the rules. Whatever form a requirement starts in, it ends as Data Rules. Whatever path a transaction takes, it ends at the Rules Engine. One enforcement point. One compilation target. That is the architecture.

The rest of the piece walks the diagram.

## What agentic AI changed

It did not introduce the governance problem. It made the cost of the problem one IT can no longer absorb quietly.

Agents now generate code, propose transactions, and write to systems of record at speeds no review cycle can match. Governance models built around developer discipline don't fail loudly. They just stop covering most of what flows past. The audit findings that were already routine in traditional systems now have a faster mechanism producing them, and that mechanism is going to get faster, not slower.

Every enterprise IT leader I talk to recognizes this. Many are hoping that better prompts, better policy, or tighter agent confinement will hold. They will not. The cost has been visible for years; agents just made it impossible to keep absorbing.

## Why two earlier attempts didn't settle this

The architectural answer — rules at ⑤, the commit point — is not new. Two earlier attempts to operationalize it both kept the procedural form of the rules, and that turned out to matter as much as where the rules were located.

**Database triggers.** Triggers got the location right. Code at the commit point cannot be bypassed by code on any path above it. The part they missed is what gets enforced *at* that location. A trigger contains procedural code. Whatever you put inside it has the same path-enumeration problem as the application code you moved it from. If the procedural body of the trigger missed a dependency, the trigger fires reliably and enforces the wrong thing reliably. Putting code at the commit point doesn't help if the code itself can't be reviewed for correctness.

**AI-generated commit code.** A thoughtful reader will ask the modern version of the question: couldn't AI just write the procedural commit-point code automatically? Same enforcement boundary, no human review burden because the AI does the work.

This was tried. From a five-rule specification, AI generated 220 lines of procedural code. Reasonable structure, clean style. When asked about edge cases — *what if the customer assignment changes? what if the product changes?* — it found bugs. Each one a foreign-key change that updated the new parent's balance but left the old parent's balance uncorrected. Silent. No exception. Wrong data persisting to the database.

When asked to explain its own failure, the AI diagnosed itself. Its summary: *"Business logic is not a coding problem. It's a dependency graph problem."* Dependencies in transactional logic, it concluded, are not reliably inferable from procedural control flow.

That diagnosis is not a vendor's claim. It is what the tool that wrote the buggy code said when asked to explain why the code was buggy.

The implication is sharp. The problem with procedural commit-point code is not that there is too much of it to review. It is that it is *wrong*, by the diagnosis of the system that produces it, in ways the review process cannot reliably catch — because no developer enumerates the full dependency graph either.

So the architectural move is not "automate the procedural code." It is to stop generating procedural code at all, and generate something the engine can reason about.

## What changed: AI as translator

The reason this conversation belongs in IT now, and not five years ago, is that AI crossed a specific threshold. It can translate the way analysts naturally describe business logic into the form the engine enforces. That is the work happening at ③ in the diagram, directed by ②.

That sounds modest. It is not. The historical adoption ceiling on declarative systems was that analysts had to learn to phrase requirements as invariants — "balance is the sum of unpaid order totals" rather than "when an order is placed, add the total to the balance." That shift was real, it was difficult, and it kept declarative adoption out of reach inside enterprises for three decades. I saw it slow declarative systems on a major project I built with Versata in that earlier era.

AI removes the barrier. Analysts continue to write the way they naturally write — procedural in form, step by step. AI translates into declarative rules. Here is what that actually looks like.

The analyst writes the requirement the way analysts naturally write requirements:

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

Procedural in form. It walks step by step. AI translates it into the declarative rules at ④:

```python
Rule.copy(derive=Item.unit_price,
          from_parent=Product.unit_price)

Rule.formula(derive=Item.amount,
             as_expression=lambda row: row.quantity * row.unit_price)

Rule.sum(derive=Order.amount_total,
         as_sum_of=Item.amount)

Rule.sum(derive=Customer.balance,
         as_sum_of=Order.amount_total,
         where=lambda row: row.date_shipped is None)

Rule.constraint(validate=Customer,
                as_condition=lambda row: row.balance <= row.credit_limit,
                error_msg="balance {row.balance} exceeds credit {row.credit_limit}")
```

Five rules. Standard Python. Open the file in VSCode. Set a breakpoint, step through with the debugger. Check it into git. Deploy in a container. The rules are readable code in a normal Python project, and the engine that executes them is open source — inspectable, forkable, no vendor lock-in for the runtime that does the enforcing.

This is the part that, more than anything else, reduced my skepticism. The five rules above are a rigorous reformulation of the requirement — each rule maps to a clause an analyst wrote. A compliance officer can read them. An auditor can read them. The 220-line procedural version, generated from the same requirement, disperses that intent across handlers, branches, and helper functions. The original requirement is no longer visible in the code; you have to reconstruct it from how the code behaves.

That is the difference, and it is the second move that triggers never had. Location is one half of the architectural argument. *Reviewability* is the other. Together, they are what makes ⑤ an architecture rather than a relocation.

## What else comes out

The rules are the heart of the architecture, but they are not the whole delivery. For an enterprise IT organization, the question that decides adoption is not "how elegant is the rule layer" but "does this fit my reference architecture without exceptions." I have walked the checklist for GenAI-Logic and found nothing I would have to make exceptions for.

Alongside the rules, the same compilation pipeline produces a standard **JSON:API** for every table — pagination, filtering, sorting, optimistic locking, Swagger-documented; **Kafka publish and subscribe** with standard topics, message shapes, and consumer-group semantics; a multi-table **Admin UI** with master/detail and lookups, ready on day one rather than a custom build; a **Behave test suite** generated from the rules, executable in any Python CI pipeline; a **Logic Report** that traces, for each transaction, which rules fired in what order with what before-and-after values, mapped back to the originating requirement; and a **standard Python project** managed in git and deployed as a container.

None of these is a vendor-specific variant of a standard component. They are the standard components, generated from the requirements rather than written by hand. For a senior IT executive, that is the difference between adopting a tool and adopting an exception.

## Two proofs, in different directions

I have seen this work in two domains that come from completely different sides of the requirements pipeline.

**The first** is a customs eligibility system — CLVS rules over a Kafka shipment pipeline with seven tables and 130-plus columns. The inputs were artifacts a business team already owns: a plain-English requirements document, an existing database schema, an XML field-mapping spreadsheet, a sample message. The Executable Requirements workflow compiled those inputs directly into a running, governed system in two days. The estimate for an equivalent build using a traditional Java framework was roughly two engineer-years.

**The second** is a regulatory implementation. The input was not a requirements document at all. It was a citation of a public Canadian regulation — the CBSA Steel Derivative Goods Surtax Order. Here is the actual prompt, with no editing:

```
Create a fully functional application and database for CBSA Steel
Derivative Goods Surtax Order PC Number: 2025-0917 on 2025-12-11 and
annexed Steel Derivative Goods Surtax Order under subsection 53(2) and
paragraph 79(a) of the Customs Tariff program code 25267A to calculate
duties and taxes including provincial sales tax or HST where applicable
when hs codes, country of origin, customs value, and province code and
ship date >= '2025-12-26' and create runnable ui with examples from
Germany, US, Japan and China
```

That dense regulatory citation produced a working application — schema, data, UI, and the duty calculation logic enforced as Data Rules — without a separate requirements pass.

For an enterprise IT executive in a regulated industry, this matters. The most expensive translation chain in compliance is regulation → requirements → specs → code → enforcement → audit. Every step is a defect generator and a cost center. The Surtax example compresses that chain to a single step, with the regulation itself as the source of truth and the running system as the artifact that enforces it.

## What the pipeline accepts

The four bullets inside ① in the diagram are not aspirational. I have personally seen GenAI-Logic accept all of them and produce governed systems:

- **Regulatory text**, as in the Surtax example — public statute, cited by section
- **Gherkin scenarios**, as my teams already write them and as Behave-style requirements pipelines already capture
- **Rules stated as invariants**, as a rules-trained analyst would phrase them — *"customer balance is the sum of unpaid order totals"*
- **Procedural pseudocode**, as analysts naturally write — *"when an order is placed, copy the price from the product, multiply by quantity, sum to the order total..."*

All four end at the same place: ④ Data Rules, attached to the data model, enforced at ⑤ on every path, regardless of source. Governed by architecture.

## Governance at organizational scale

A single governed system is interesting. An organization that makes governed-by-architecture the *norm* — across hundreds of services, dozens of teams, requirements coming in from every direction — is a different argument. It is the argument that matters at the level enterprise IT actually operates.

What makes it possible is that the business side of the requirements pipeline does not change. Analysts continue to produce the artifacts they already produce. Product owners continue to review them. They flow into Jira, into specs, into the same backlogs and the same review cadences. The pipeline already exists in every enterprise. What changes is what comes out the other end.

Without an architecture like this, the same five-rule scenario produces 220 lines of procedural code on one team and 340 on another, each with the path-dependency bugs no developer (and no AI) enumerates exhaustively. Multiply that across every team, every quarter, every new endpoint, and governance reverts to a discipline problem at scale — which is to say, an unsolved problem. The audit findings I described at the top of this piece are exactly this failure mode.

With this architecture, the same input *always* produces declarative rules that are automatically dependency-ordered, automatically enforced at commit, and automatically inherited by every new path — including paths that don't exist yet. The pipeline doesn't change. The output does. Governance becomes pipeline-native, and the cost of governance stops scaling with the size of the portfolio.

That is the property I have been looking for and have not previously found.

## The bottom line

Enterprise IT does not need more processes layered on top of agentic AI. It needs an architecture in which the rules live inside the data model, the enforcement is automatic, and the source of the write is irrelevant to whether the rule applies.

That architecture is **mandatory for agentic AI**, because no review cadence will keep pace with agent-generated transactions. It is also **essential for traditional systems**, because governance-by-discipline was already failing in those systems, at significant cost, well before agents arrived.

The frame the GenAI-Logic team uses for this is *Correct by Construction* — correctness as a property of the architecture, not a property of the team's discipline. After what I have seen, both in audit findings on traditional systems and in the early evidence on agentic ones, that is the right frame.

I have started treating my requirements as the specification the system will run. The architecture takes them from there.

---

*Wynford Reese is a senior enterprise IT executive with a long career building and operating large-scale systems. Val Huber is co-founder and architect of GenAI-Logic, and previously CTO at Versata.*
