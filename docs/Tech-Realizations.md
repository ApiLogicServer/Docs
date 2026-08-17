!!! pied-piper ":bulb: TL;DR - Key Realizations"

    This summarizes our key app dev realizations, reached over decades of personal experience:

    1. Business Users are quite capable of designing non-trivial systems, given the right tools
    2. BRMS support for business rules is a key / required element of such tooling
    3. Still, Devs will 'slip into code' if rules are not as natural as code
    4. Devs will resist tooling that provides new value (e.g., rules) if it comes at the expense of tried and true technology (in particular, IDEs)
    5. AI can provide NL to address the *rules aren't natural* problem
    6. AI alone produces unreadable / buggy Frankencode, but can be trained with CE to generate *rules not code.*   Rules *are* the governance enterprises require: logic they can read, trust and maintain.
    7. IDEs can  1) provide access to AI, that   2) meets dev requirements,   and 3) with simplified interfaces.  The result: Bus Users and Devs can share the same logic, rules and tooling.

I got into app dev when I worked at Xerox Computer Systems.  Competing against IBM, we won every benchmark, and lost every sale.  Why?  They had data processing.  What's that?  Files and stuff.  They didn't know.

So, to learn, I joined a consulting firm that built systems.  There were a bunch of ***smart MBAs who had no trouble translating user needs into specifications.***  What struck me was that the specs were so clear, but the dev took so long.  What if...

One day, I was working with a new dev on a system for Meade Paper.  He fell asleep (first day).  Amused, I asked him if this was boring.

He said yes, here we increment the quantity, here we decrement it.  It's all so obvious - the computer should just do that.

I confidently explained that's what *our* job was - to make the computer do that.  But driving home, it struck me that while it was not quite obvious, there was certainly a pattern...

So, I played a what-if game: ***what would it take** for the computer to 'just do that'*.  In moments, it hit me: if the system knew the quantity was the sum of the transactions, it could automate it.

And I ran across in my mind the 5-6 systems we'd built, and it became clear that these kinds of sums, counts and validations were the core of each system.  And exactly what the MBAs had written down.

It was the birth of rules.

Some years later, we developed the Wang system that captured and automated these rules - one of the first BRMS.  Remarkably successful, but not easy: declaring rules required a new way of thinking.  

This same approach worked for Versata on the J2EE space.  Also sucessful, but 2 realizations:

1.  It was again clear that ***many customers 'got' rules, but too many did not.***  As soon as you looked away, the devs all too often 'ran home to code'. 
2. This marked the advent of IDEs.  And it became clear that **devs were resistant to studio-based rules if it meant *losing their IDE.***

So... how to capture the rules in the way users thought of them, and *not* lose the IDE.  It seemed like an academic exercise, because there were a myriad of ways to capture requirements, and they all started with parsing NL.  Just too hard...

Then along came the comet: ***NL, available in free IDEs.*** Overnight:

* **NL can create systems in *your* language**

    * Common formats, such as Gherkin, expressions, plain words, regulations
    * Or gather them from an *AI Interview*

* **In an IDE with all the dev tools** (debuggers, source control, etc).

    * And modern studios often provide an *Agent Mode*, a UI suitable for business users - mainly AI prompting and testing

So now Bus Users and Devs can share the ***same logic, and use the same (standard) tools.***  Suddenly, a proprietary studio - formerly *required* to capture rules - was *no longer necessary, in fact, was a liability.*   And, a huge org impact: the end of *Shadow IT wars* that had plagued Low Code.

So, peace in the shire?  Not quite....

The fact is, AI-driven projects are not doing well.  Two reasons:

1. AI, on its own, translates requirements to native code. *Lots* of it: 5 rules become 200 lines of code.  Suddenly, the intent is obscured.  You can't govern what you can't read.

2. And, worse, we found bugs -- hard to spot, but fatal to data integrity.

    * Funny story there... we were testing, and gave AI a 5 line prompt with instructions to create code.  It did.  I reviewed the code, and asked AI what would have if...  It understand the bug, and fixed it.  I did it again.
    * At this point, the AI literally stopped and said "I see what you are doing.  You are teaching me about declarative rules vs. procedural code."  And it wrote a report, summarizing that ((click here))[https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/manager/samples/basic_demo_logic_gov/logic/procedural/declarative-vs-procedural-comparison.md].

Which brings us back around to rules.  The **rules *are* the governance**, excecuted by a rule engine.  We need to teach AI to generate rules, not code.  So, how?

AI provides multiple ways to do that with *context* - additional information you provide to AI. 

In the beginning, we all learned Prompt Engineering: sandwich your request with additional "background information".
  We did that too.  It worked, but it was difficult to program, model dependent...

What works better is **Context Engineering** - a set of project files in your project.  The IDE AI Assistants know how to find it, and provide the needed aspects to AI.  This essentially paritions the prompt:

* **problem-specific knowledge** (your logic: *"the balance is the sum of the unpaid orders"*) from 
* **problem-independent knowledge** (system information: *here's how you transate 'sum' into rules*).  Significantly, this can be provided by a rule vendor, not the user.

> It's a remarkable choreography between the IDE,  Coding Assistants, and LLMS:<br> 
> - The IDE informs the AI Ass't about the CE<br>
> - The AI Ass't processes prompts by gathering CE and project artifacts to prepare a plan that uses the LLM to translate<br>
> - The resultant rules are deterministic, executed at runtime by the BRMS

AI can then play the critical role of speaking to the user in *their* terms, and translating into rules - grounded, structured, governable.  All inside an IDE suitable for both devs and Bus Users, sharing the same artifacts.
  
---

So, it retrospect, it seems so obvious: to really help, you need to 

* ***Let users express themselves in familiar ways, in familiar environments.***  
* And create ***governed rule-based systems they can read, trust and maintain.***