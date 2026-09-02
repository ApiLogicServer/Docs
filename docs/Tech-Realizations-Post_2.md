Last week I wrote how rules are effective, but their capture required a custom studio - a blocker for developers.

But now, AI-enabled IDE can provide a better basis for rule capture than custom studios.

Why?  Because you could describe logic in plain language — Gherkin, expressions, plain words, straight out of a regulation — and have the AI ask the follow-up questions itself. All inside a real IDE, with real debuggers and real source control. No separate studio required.

So, a proprietary studio - formerly the price of entry for capturing business rules -  wasn't just unnecessary, it was a liability. Business users and developers could finally work from the same logic, in the same tools. 

This is very significant: an organization can blend the two however a given project calls for, and tune that mix as needs change.  End of the Shadow IT wars.  Peace in the shire.

But one issue remained... AI-driven projects, broadly, aren't doing well. People usually attribute this "governance." I think it comes down to two things.

First: left alone, AI translates requirements into native code. A lot of it — five rules can turn into two hundred lines of code. The intent gets buried. You can't govern what you can't read.

Second: we found bugs causing data integrity issues.

Funny story here. We were testing, and gave the AI a five-line prompt to write some logic. It did. I reviewed the code, then asked: what happens if...? It understood the bug, and fixed it. I asked about another bug. Same thing.

At that point the AI stopped and said: "I see what you are doing. You are teaching me about declarative rules vs. procedural code." Then - on its own - it wrote up a report on the comparison. (You can read it here: [link to the AI's report])

Which brings it back to rules. Rules are the governance — executed deterministically by a rules engine, not generated as a pile of one-off code. The real question is: how you teach AI to produce rules instead of code?

Early on, everyone — us included — learned Prompt Engineering: sandwich the request between chunks of background information. It worked, sort of. It was also fragile, and different for every model.

What actually works is Context Engineering.  It's a set of project files we create in your project. It provides the general knowledge of how to turn NL logic into code.

So, in retrospect:

- Let people express themselves in the language and tools they already use.

- And turn that into governed, rule-based systems they can read, trust, and maintain.

It's also exactly why RFI works — the feature I posted about a few weeks back, where AI runs the requirements interview itself. If you haven't seen that one, this is the "why" behind it: https://www.linkedin.com/posts/val-huber-6738401_executable-reqmts-activity-7498403947724926976-pqZ8?utm_source=share&utm_medium=member_desktop&rcm=ACoAAABNN7cBvgEFs5o_sdw5Nr02vWxPC6HtAhw

#genai #governance #business-rules
