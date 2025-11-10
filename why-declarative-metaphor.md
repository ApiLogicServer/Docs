!!! note "Intuition (optional)"
    Think of declarative rules like spreadsheet formulas. You state *what* is true, and the engine keeps all the dependencies consistent.  
    Now imagine a spreadsheet with no formulas — one where an AI rewrites every cell’s logic each time you change something. Even a great model would inevitably miss some dependency paths, because it’s regenerating behavior rather than understanding it.  
    Declarative rules are the formulas; AI is excellent at writing them. The engine ensures they behave correctly every time, and procedural code remains available for the exceptions.


## Talking Points

Ran A/B Experiment
* 200 lines of code: finding:
    ** 2 key bugs (leading to self-analysis)
    ** Performance Issues
* Lead to self-analysis
    ** Bugs <= transitive dependencies

Long Term
* Bugs likely to endure: larger models don't address transitive dependencies 
* Maintenance: devs will have to contend with f/code

## Spreadsheets

“Sam… think about a spreadsheet that rewrites itself every time you type.”

“Imagine Excel doesn’t have formulas.
Imagine it has an AI instead.”

“You tell it what you want:
‘Totals should always match the rows.’
‘Balance should be the sum of open orders.’”

“And the AI rewrites the whole workbook for you — every function, every cell.”

Hold up your hand:

“Now — how confident are you that every dependency is covered?
Every time?
Under every combination of edits?”

Let him think.

Then:

“It’s not that the AI is bad — it’s great.
It’s that rewriting scripts for every cell will always miss cases.
Old versions, new versions, edge cases you didn’t ask for…”

“You’re depending on the AI to recreate the entire dependency graph from scratch.”

Pause.

“That’s why spreadsheets have formulas.
They don’t rely on regeneration.
They rely on meaning — the engine understands the relationships.”

Now bring it home:

“Declarative rules are the formulas.
AI is terrific at writing them.
But the engine is what guarantees they behave correctly — every time, with every change.”

“It’s the combination — NL for intent, engine for correctness — that makes the system work.”

And now the procedural escape hatch:

“And sure, sometimes you still need a macro.
But you don’t rebuild the spreadsheet from scratch to write it.”

Smile.

“That’s the world we’re building:
AI writes the formulas,
the engine keeps everything consistent,
and macros handle the exceptions.”



## AI Spreadsheets

“Sam, when I give AI a natural-language query, I don’t want it to build a new database engine for me.
I want it to run the query on the engine that already exists.”

“The engine is there because we need correctness — indexes, transactions, locking, optimization.
We don’t reinvent that every time we ask a question.”

Pause.

“Business logic works the same way.
When I tell the system, in natural language,
‘Balance should be the sum of open orders,’
I don’t want the AI to reinvent the whole dependency mechanism.”

“I want it to express the rule — the intent —
and let the engine handle the propagation, the ordering, the constraints.”

Smile.

“AI is great at translating intent.
Engines are great at executing it.
We shouldn’t confuse the two.”