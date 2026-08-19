The real bottleneck in getting business logic right was never writing the rules. It's getting the requirements out of someone's head in the first place.

That used to require a business analyst trained in a very specific technique — repeatedly asking "what is X?" until every term bottoms out at something the system actually stores. It's how rules adoption worked long before natural language made direct capture possible. It still works. It's just slow, and it needs a skill that's gotten rarer.

So we shipped a feature that lets AI run that interview itself.

We call it RFI — Requirements From Interview. Instead of needing a pre-written prompt to start a project, you can just say "let's discuss," and the AI runs a structured, BA-style interview: what are the constants, what are the lookups and foreign keys, where are the genuine judgment calls versus the straightforward derivations, what does the type hierarchy actually look like. It synthesizes all of that into a real requirements document — not a transcript, a build-ready spec.

It's live and documented here: [link to https://apilogicserver.github.io/Docs/Exec-Reqmts/#requirements-from-interview]

The validation I like best didn't come from us. A senior IT executive at a major logistics company — someone who's spent decades running large-scale systems, and isn't easily impressed — used it, unprompted, on a real customs-declaration domain: the rules for what has to happen when a shipment crosses into Canada. He didn't write it a prompt. He just started talking to it.

The AI kept surfacing requirements he hadn't stated yet, revised its own design as it learned more, and self-corrected through several rounds of live testing. In under an hour it had a working draft — about a dozen tables, three dozen rules, covering a genuinely complex regulatory domain — ready for review and sign-off, not a rough sketch.

His reaction: "blown away."

The goal underneath this — the goal underneath everything I work on — is letting people express logic in the language they already think in, without losing the rigor of governed, readable rules. RFI pushes that one step further: you don't even need to know how to write the prompt. You just need to know your domain. (I'll be writing more here about how I got to that goal in the first place — decades before AI made it possible.)

#GenAI #AI #ExecutableRequirements #BusinessRules #RequirementsEngineering #EnterpriseAI

