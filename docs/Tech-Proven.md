There are several novel elements of API Logic Server:

* Logic, using spreadsheet-like rules, customizable with Python
* Automated Admin Apps - multi-page, multi-table, automatic joins
* Models, expressed in Python, instead of massive code generation
* Customizable, using a standard language, in standard IDEs such as VSCode or PyCharm

It's therefore quite reasonable to ask whether this technology is proven.

It has.

Key aspects of this technology first surfaced in PACE, Wang's highly regarded DBMS with over 6500 installed sites. It provided a relational query engine with rule enforcement, an application builder, and a query/report writer. The technology was awarded several patents for rules and application generation.

The next major implementation was Versata, a J2EE app dev system with over 700 sites. Funded by the founders of Microsoft, SAP, Ingres and Informix, it went public in 2000 with an IPO exceeding $3B.

These commercial implementations both cost in the range of $35,000 - $50,000 per CPU.  Now available in open source. 

## The automation ratio, measured across dozens of systems

The A/B test in this project's documentation shows one example: 5 rules vs. ~200 lines, 0 bugs vs. 2. That's a single, reproducible data point — not a claim that the ratio holds everywhere.

For that, there's a longer track record. Val Huber, CTO / architect of both Versata and GenAI-Logic, measured the automated-vs-manual code ratio across several dozen Versata production systems (1995-2010): consistently **94-99% of logic automated by rules**, typically **~97%**. The remaining 3-6% was hand-written procedural code — event handlers and custom logic outside the declarative vocabulary of the day.

A ~97% automation rate means roughly 1 line of hand-written code for every 33 lines rules replace — the same order of magnitude as the README's ~40X figure (5 rules vs. ~200 lines). The 40X figure in the A/B test isn't a one-off, then — it's consistent with two decades of production measurement on a predecessor system.