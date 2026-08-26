A few weeks ago I posted about RFI — the feature that lets AI run a full requirements interview instead of needing a written prompt. (If you missed it: https://www.linkedin.com/posts/val-huber-6738401_executable-reqmts-activity-7495880546133155840-q4nw?utm_source=share&utm_medium=member_desktop&rcm=ACoAAABNN7cBvgEFs5o_sdw5Nr02vWxPC6HtAhw).

Today I want to back up to where that idea actually started for me — decades before AI made it possible.

I got into app dev at Xerox - competing against IBM, we won every benchmark. And lost every sale.

Why? They had "data processing." I didn't know what that meant. Neither did anyone else on my team.

So I went to learn it — joined a consulting firm that built systems for a living. I watched a bunch of smart MBAs translate user needs into specs with zero trouble. What struck me: the specs were always so clear. The dev work never was. It always took forever. What if...

One day I was pairing with a new dev on a system for a paper company. He fell asleep. First day.

Amused, I asked if I was boring him.

He said: no — here we increment the quantity, here we decrement it. It's obvious. The computer should just do that.

I confidently told him that was literally our job: making the computer do that.

But driving home, it hit me. There *did* seem to be a pattern...

I played a what-if game: what would it actually take for the computer to "just do that"? In about thirty seconds it clicked — if the system knew the quantity was the sum of the transactions, it could automate the whole thing itself.

I ran the 5-6 systems I'd built through my head. Same pattern, every time. Sums, counts, validations.  It as the bulk of the effort.  Exactly what the MBAs had been writing down all along.

It was the birth of rules, for me.

A few years later we built one of the first business rules engines, at Wang, to capture and run exactly that kind of logic. It worked — remarkably well — but it wasn't easy. Declaring rules instead of writing code asks people to think differently, and that's a hard sell.

The same approach worked again at Versata, in the J2EE years. Also a real success. But it also taught me two things that would matter for the next twenty years:

1. Plenty of customers "got" rules. Too many didn't - "thinking different" was still a challenge. Too ofen, developers quietly went back to writing code.

2. This was also when IDEs took over software development. Developers didn't just prefer their IDE. They actively resisted anything — rules included — that meant giving it up.

So the real problem was never rules themselves. It was: how do you capture logic the way people actually think about it, without asking developers to abandon the tools they live in?

For a long time, that felt like an academic question. There was no good way to parse natural language reliably enough to make it work.

Then AI showed up inside the IDE itself. NL as no longer a blocker.

More on that next.

