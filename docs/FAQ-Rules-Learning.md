!!! pied-piper ":bulb: TL;DR - Is Learning Curve for Rules Steep?  No - Dramatically Reduces with AI and Context Engineering"

      Experience has shown that not all developers find the declarative rules approach intuitive.  They naturally think in procedural terms, which fit well with the programming paradigm.
      
      AI, with extensive Context Engineering, dramatically reduces this.  In fact, developers can submit procedural logic, and AI will transpile it into declarative rules.
      
      > The payoff: automatic re-use means logic imagined for inserting an order automatically addresses delete order, update order, and insert/update/delete line items.  For more on **automatic re-use**, [click here](Logic-Why.md#automatic-reuse){:target="_blank" rel="noopener"}.

&nbsp;

---

## Procedural Logic In

Funny story: early in the development of Context Engineering, I found that the same learning that drove code generation could also drive support.  So, I asked my AI Assistant to provide an example of rules - it produced:

```text title="Procedural Logic"
On Placing Orders,
Derive item amount as quantity times Product Price
Add that to the Order Total Amount
Add that to the Customer Balance
Ensure that is less that the Credit Limit
```

I gasped - here was AI teaching folks the wrong paradigm.

And yet, models had been improving.  So, I tried it.

&nbsp;

## Declarative Rules Out

I created a project from an existing database, like this:

```bash title="Create a Project: API (MCP), Admin App"
create basic_demo from samples/dbs/basic_demo.sqlite 
```

And then I submitted the logic... the result -- declarative rules:

![proc-decl](images/logic/proc_logic/proc_logic.png)

With a diagram:

![proc-decl](images/logic/proc_logic/proc_logic_dgm.png)

&nbsp;

## Reuse - Design One, Solve Many

Look again at the 5 rules above. Not one of them mentions "placing an order" — they declare
what `Item.amount`, `Order.amount_total`, and `Customer.balance` *are*, not when to compute
them. That's why one design solves every path: insert an Item, delete an Item, change its
quantity, move it to a different Order, move an Order to a different Customer — the same 5
rules cover all of it, automatically, because they're declared on the data, not wired to
"placing an order."

The procedural version above can't do this. "On Placing Orders..." names one path. Handling
update, delete, and re-parenting means writing and maintaining separate handlers for each -
the classic path-dependent logic problem. For the full reasoning on why this generalizes past
this one example, see **automatic re-use** in [Why Rules?](Logic-Why.md#automatic-reuse){:target="_blank" rel="noopener"}.

&nbsp;

## Trust - on commit, no bypass

The 5 rules aren't called by the code that handles order placement - there is no such code.
They're attached to the ORM's commit event, so they fire on *every* write to `Item`, `Order`,
or `Customer`, from *every* caller: the JSON:API, a custom endpoint, an MCP request, a Kafka
message handler, a script, an AI agent acting on the database directly. There's no place to
insert a change that skips them, because they don't live downstream of any particular entry
point - they live on the commit itself.

This is the same guarantee described in [Introduction - Executable Requirements](Introduction.md):
*"the rule engine plugs into the ORM's commit event, not into the API or handlers, so it fires
identically whether the change comes from an API call, a message handler, or an AI agent."*
Procedural logic, by contrast, only runs where someone remembered to call it - and every new
entry point is a new place to forget.

&nbsp;

## Trust - error free

This isn't a claim taken on faith - it's been tested directly against the procedural
alternative, more than once.

The original A/B test (documented in the [declarative-vs-procedural comparison](https://github.com/ApiLogicServer/basic_demo/blob/main/logic/procedural/declarative-vs-procedural-comparison.md))
asked an AI assistant to hand-write the same order/credit logic as procedural code. The result:
~200 lines, and two real bugs - reassigning an `Order` to a different `Customer` left the old
customer's balance stale; reassigning an `Item` to a different `Product` left the old price in
place. Both are the same shape of bug: code that handles the *new* side of a change but forgets
the *old* side.

A follow-up test went further: two independent frontier models (no ApiLogicServer, no rules
engine - "native AI," told explicitly not to use either) were given this exact prompt, phrased
the way a developer naturally describes the requirement ("here's what needs to happen when
someone places an order..."). Both produced code with *no update or delete path at all* - a
single function wired to order creation, with `Customer.balance` implemented as a running
total that's only ever incremented, never recomputed. Probed live: changing an item's
quantity, deleting an item, reassigning an order's customer, reassigning an item's product -
every one of these left stale, wrong data, silently, with no error. The same prompt, run
through GenAI-Logic's 5 declarative rules, handled all four cases correctly - verified live
against a running server, not just by inspection.

Two different models, one shared failure mode, traceable to the same root cause each time:
procedural code reacts to the path it was told about, and silently misses the ones it wasn't.

&nbsp;

## Business User Empowerment

It's not just that rules read like the requirement - the requirement itself can come straight
from a business user, in the language they already use, with no developer in the loop to
translate it first:

![reg-tech](images/exec_reqmts/reg-tech.png)

That's a real regulatory prompt - citing the actual statute sections and program code for a
CBSA customs surtax order, written the way a compliance analyst would write it, not the way a
developer would. Handed to a simplified agent window, it produces a running, governed system:
duty and tax calculations, trade-agreement exemptions, provincial tax handling - all as rules,
not hand-written procedural code a business user could never review. The artifacts stay
available to developers on request, but nothing about getting to a working first version
required one.

The 5 rules in the check_credit example read like the requirement for the same reason:

```
The Customer's balance is less than the credit limit
The Customer's balance is the sum of the Order amount_total where date_shipped is null
The Order's amount_total is the sum of the Item amount
The Item amount is the quantity * unit_price
The Item unit_price is copied from the Product unit_price
```

A business user doesn't need to read Python to check whether this says what they meant - they
can read the rule text itself, the same words they'd use to describe the policy out loud. This
is what makes rules reviewable by the person who owns the requirement, not just the developer
who typed it in. Contrast the procedural version: the "logic" is spread across event handlers,
session queries, and conditionals - readable to a developer, opaque to everyone else.

&nbsp;

## Business User Collaboration

Because the rules are readable by both sides, the same project artifact serves as the shared
reference. A developer and a business user can look at `check_credit.py` together and agree
it says what it should - no separate business-readable spec that drifts out of sync with the
"real" implementation, no hand-off where intent gets lost in translation. When the policy
changes ("balance is less than *or equal to* the credit limit"), the fix is a one-line English
diff and a matching one-line rule change - a conversation both people can have.

&nbsp;

## Goverance At Scale

Five rules per use case doesn't sound like much - until the system has 80 tables with business
logic instead of one. A hand-coded system needs a correctly-written handler for every change
path on every table: insert, update, delete, every foreign-key reassignment. A rules-based
system needs one rule per invariant, and the engine supplies every path automatically.

The gap between those two curves doesn't stay small. Change paths grow faster than tables as a
system grows - re-parenting, deletes, and conditional aggregation each multiply the cases a
hand-written system must separately get right, while a declarative system's rule count grows
with the requirements, not with the paths. At 5 rules, a missed change path is a curiosity you
can find with a single test. At 80 tables and hundreds of rules' worth of hand-written
equivalent, it's an audit problem - and there's no tractable way to review thousands of
handlers by hand for the "did you also handle the old parent?" bug documented above. Rules
scale by staying declarative: readable, auditable, and complete by construction, not by
review.

