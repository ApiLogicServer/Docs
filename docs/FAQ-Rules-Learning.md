!!! pied-piper ":bulb: TL;DR - Is Learning Curve for Rules Steep?  No - Dramatically Reduces with AI and Context Engineering"

      Experience has shown that not all developers find the declarative rules approach intuitive.  They naturally think in procedural terms, which fit well with the programming paradigm.
      
      AI, with extensive Context Engineering, dramatically reduces this.  In fact, developers can submit procedural logic, and AI will transpile it into declarative rules.
      
      > The payoff: automatic re-use means logic imagined for inserting an order automatically addresses delete order, update order, and insert/update/delete line items.  For more on **automatic re-use**, [click here](Logic-Why.md#automatic-reuse){:target="_blank" rel="noopener"}.

&nbsp;

---

## Procedural Logic
Funny story: early in the development of Context Engineering, I found that the same learning that drove code generation could also drive support.  So, I asked my AI Assistant to provide an example of rules:

```text title="Procedural Logic"
On Placing Orders,
Derive item amount as quantity times Product Price
Add that to the Order Total Amount
Add that to the Customer Balance
Ensure that is less that the Credit Limit
```

&nbsp;

## Results in Declarative Rules

And here was the result: declarative rules:

![proc-decl](images/logic/proc_logic/proc_logic.png)

With a diagram:

![proc-decl](images/logic/proc_logic/proc_logic_dgm.png)