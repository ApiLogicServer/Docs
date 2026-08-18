Last week I wrote about how I stumbled into business rules three decades ago — a sleepy developer on day one, an offhand comment, and the realization that "sum, count, validate" was the actual shape of most business logic. It ended with developers resisting anything that meant giving up their IDE, even rules. (If you missed it: [link to Post 1])

Then AI showed up inside the IDE. That changed everything.

Suddenly you could describe logic in plain language — Gherkin, expressions, plain words, straight out of a regulation — and have the AI ask the follow-up questions itself. All inside a real IDE, with real debuggers and real source control. No separate studio required.

That last part matters more than it sounds. A proprietary studio used to be the price of entry for capturing business rules. Suddenly it wasn't just unnecessary — it was a liability. Business users and developers could finally work from the same logic, in the same tools. The Shadow IT wars that low-code had been fighting for a decade: over.

So — peace in the shire?

Big progress, honestly. Developers and business users can now work the same project with the same tools. Nobody has to be forced to pick a side; an organization can blend the two however a given project calls for, and tune that mix as needs change.

But one issue remained, and it's a real one. AI-driven projects, broadly, aren't doing well. People usually call this "governance." I think it comes down to two things.

First: left alone, AI translates requirements into native code. A lot of it — five rules can turn into two hundred lines of code. The intent gets buried. You can't govern what you can't read.

Second, and worse: we found bugs. The hard-to-spot kind. The kind that quietly corrupts your data instead of throwing an error.

Funny story here. We were testing, and gave the AI a five-line prompt to write some logic. It did. I reviewed the code, then asked: what happens if...? It understood the bug, and fixed it. I asked again. Same thing.

At that point the AI stopped and said: "I see what you are doing. You are teaching me about declarative rules vs. procedural code." Then it wrote up its own report on the comparison. (Genuinely — you can read it here: [link to the AI's report])

Which brings it back to rules. Rules are the governance — executed deterministically by a rules engine, not generated as a pile of one-off code. The real question is how you teach AI to produce rules instead of code.

The honest answer is context. Early on, everyone — us included — learned Prompt Engineering: sandwich the request between chunks of background information. It worked, sort of. It was also fragile, and different for every model.

What actually works is Context Engineering: a set of project files that live in your project, that the IDE's AI assistant already knows how to find. It splits the prompt into two kinds of knowledge — the specifics of your logic ("the balance is the sum of the unpaid orders"), and the general knowledge of how to turn that into a rule. The second part doesn't have to come from the user. It can come from the vendor.

It's a genuine three-way choreography: the IDE tells the AI assistant where the context lives, the assistant gathers that context plus your project's own artifacts and drafts a plan, and the LLM does the translation. What comes out the other end is deterministic — executed at runtime by the rules engine, not re-guessed by a model every time it runs.

So, in retrospect, it's almost obvious. You need two things:

Let people express themselves in the language and tools they already use.
And turn that into governed, rule-based systems they can actually read, trust, and maintain.

It's also exactly why RFI works — the feature I posted about a few weeks back, where AI runs the requirements interview itself. If you haven't seen that one, this is the "why" behind it: [link to RFI post]

---
[DRAFT — not yet posted. Notes for Val below this line, delete before publishing.]

- Resequenced per your call to run RFI first: added a closing back-reference to the RFI post and a bracketed link placeholder. Everything else below is unchanged from the original draft.
- Part 2 of 2 (now Part 3 of 3 overall, after RFI and Post 1). Opens with a one-line recap of Post 1 for anyone who lands here without seeing it, then continues the arc exactly through the end of Tech-Realizations.md.
- Kept the "funny story" bug anecdote close to verbatim — it's the strongest single beat in either post, didn't want to blunt it.
- Left two bracketed links: back to Post 1, and to the declarative-vs-procedural report on GitHub (currently at .../basic_demo_logic_gov/logic/procedural/declarative-vs-procedural-comparison.md — same link already in the current Tech-Realizations.md).
- Didn't include the closing "key pieces of technology" bullet list from the source doc — felt like it belonged to the deeper Medium/docs version rather than the LinkedIn post; happy to add back if you want the post to end more concretely instead of on the "read, trust, maintain" line.
- No markdown will render on LinkedIn — post as plain text.
