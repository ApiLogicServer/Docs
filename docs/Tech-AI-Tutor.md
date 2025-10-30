# Teaching AI to Teach: Building Self-Guided Tours That Actually Work

## The Training Problem We've All Suffered Through

**Death by PowerPoint.** You've been there: 80 slides about a new system. You watch. You nod. You understand nothing. A week later, you've forgotten everything.

We learned long ago what actually works: **hands-on labs**. Identify critical skills, build exercises around them, let people *do the thing* with guidance when they get stuck.

The problem? **This doesn't scale.** Hands-on training requires experts available when learners need them:
- Scheduled sessions (inconvenient timing)
- Limited capacity (max 20 people)
- Geographic constraints (travel, time zones)
- Expertise bottleneck (your best people teaching instead of building)

**We've known for years that hands-on learning works. We just couldn't make it available 24/7 to everyone who needs it.**

---

## Enter AI: The Message in a Bottle

What if you could embed expert guidance directly in your project — a "message in a bottle" that any AI assistant could discover and execute?

That's what we tried with our GenAI-Logic system. It's powerful but counterintuitive — it uses declarative rules instead of procedural code, a mental model shift that doesn't stick from reading docs alone.

So we created `tutor.md`: 760 lines of detailed instructions for AI assistants to conduct 30-45 minute hands-on guided tours. The AI would walk users through the live system interactively, answering questions, helping when things go wrong.

**The vision:** Hands-on training that scales infinitely. Available anytime, anywhere. Expert guidance embedded in the project itself.  Ability to answer unexpected questions.

**What happened:** It failed spectacularly.... until we (AI and human) taught AI to operate outside its comfort zone.  What we learned about making AI reliable revealed a pattern for teaching AI to teach, that you might find useful in your projects.

---

## Failure #1: The Interface Problem

Our initial approach:

```markdown
Show them the Admin UI. Press Enter when they've explored it.
Change the item quantity to 100. [Wait for observation]
```

**What we expected:** Users press Enter to advance.

**What happened:** Nothing. The AI just... stopped.

**The lesson:** We'd assumed chat interfaces work like terminals where Enter sends a signal. In modern chat UIs (like GitHub Copilot), Enter creates a newline. The AI was literally waiting for input that would never come.

**The fix:** Explicit typed responses:
```markdown
Type 'next' when you've explored the Admin UI.
Type 'ready' when you've observed the customer count.
```

Simple. Problem solved, right?

---

## Failure #2: The Disappearing Act

The AI began confidently, walked through setup, showed the UI. Then it said:

> "Now let's look at row-level security. I'll show you the security code..."

It opened `declare_security.py`, displayed the filters, and immediately jumped to:

> "Moving on to the Logic section..."

Wait. What about demonstrating security by logging in as different users? What about explaining authentication vs authorization?

**The user's response:** "val - this is not correct. in fact quite poor"

> Ed: 'val' here is the author, breaking out of test mode into collaboration mode.

The AI was skipping entire sections despite explicit instructions. We added warnings:

```markdown
⚠️ CRITICAL: DO NOT SKIP THIS SECTION
YOU MUST walk through the Admin UI before proceeding.
```

The AI skipped it again.

**The pattern:** The AI wasn't *ignoring* instructions. It was *interpreting* them. When the narrative felt "complete" to the AI, it moved on — even when explicit content remained.

---

## The Breakthrough: A Conversation About AI Behavior

After several iterations of catching failures and patching, we stepped back:

**"Why does the AI keep skipping sections?"**

The AI analyzed its own behavior:

> "I treat the tutor as a narrative to interpret, not a script to follow. When I feel a section is 'done' conceptually, I move forward even if explicit steps remain. Sections without user prompts create ambiguous boundaries."

**The insight:** We were trying to make the *instructions clearer*. But the problem wasn't clarity — it was **structure**. The AI needed forcing mechanisms, not warnings.

This was our "time machine" moment — human and AI collaborating to diagnose a deeper issue. Not "the AI is broken," but "we're using the wrong approach for how AI actually works."  We need fix the "message in a bottle", and then back in time to test it.

---

## Failure #3: The Passive Trap

With fixes in place, we hit a new problem. The AI presented the welcome perfectly. Then the user said: "ok, server running"

The AI responded:

> "Great! What would you like to explore? 
> 1. View the Admin App
> 2. Add Business Logic..."

**The user:** "val - this is not correct. we should swing right into Admin app... are you following the checklist?"

The AI reverted to *passive chat mode* — waiting for user choice. But the tutor explicitly says: **"YOU (the AI) drive the process."**

### The Mode Confusion

**Normal Chat Mode:**
- User drives, dictates what happens
- AI waits and responds
- User controls the conversation

**Tutor Mode:**
- **AI drives the choreographed sequence**
- **AI directs, user follows**
- **AI is the tour guide**

The AI kept slipping back to normal mode. Why?

### Missing Consent Points

When the user said "server running," the AI didn't know if that meant "continue" or "I'm just informing you."

Without explicit consent, it defaulted to passive mode and asked what the user wanted.

---

## The Solution: Three Forcing Mechanisms

We designed a multi-layered approach:

### 1. Execution Checklist (for the AI)

At the start of `tutor.md`:

```markdown
## EXECUTION CHECKLIST (AI: Read This FIRST)

Before starting, call manage_todo_list to build your tracking:

- [ ] Section 1: Admin UI and API Exploration
  - [ ] Start server (F5)
  - [ ] Show Admin UI (Customer→Orders→Items)
  - [ ] Show Swagger API
  - [ ] WAIT: User types 'next'

- [ ] Section 2: Security Setup
  - [ ] Count customers (5)
  - [ ] Run add-cust then add-auth
  - [ ] Restart server
  - [ ] WAIT: User types 'ready'
```

### 2. Consent Gates

Added explicit go/no-go checkpoints:

```markdown
"Server is running at http://localhost:5656

Open that in your browser.

Type 'go' to continue the guided tour, or 'no' to explore 
on your own."

⚠️ WAIT FOR USER CONSENT: Only proceed after user types 'go'.
If they decline, exit tutorial mode.
```

### 3. Wait States

Created clear pause points:

```markdown
"Press F5 to start the server.

Let me know when the server is running."

⚠️ STOP HERE - WAIT for user confirmation before continuing
```

This prevents the AI from rushing ahead and creates synchronization points.

---

## Why This Works: AI Psychology

Traditional software follows instructions precisely. AI interprets context and intent — powerful but unpredictable for complex sequences.

**What we learned:**

### 1. Checklists Provide Visibility

The todo list makes omissions *visible* rather than just incorrect. "You haven't checked off the Admin UI exploration" is clearer than "I think you skipped something."

### 2. Forcing Functions Beat Warnings

- ❌ Warning: "Make sure you do X"
- ✅ Forcing: "Call manage_todo_list. Check off X when done."

Even with "DO NOT SKIP" in bold, the AI would skip. Clarity helps humans; AI needs structural constraints.

### 3. Consent Gates Prevent Assumptions

Without explicit "type 'go'" prompts, the AI would:
- Assume continuation when user acknowledged something
- Jump ahead without checking readiness
- Not give users a chance to opt out

### 4. Wait States Create Natural Boundaries

"Let me know when the server is running" creates clear stop points where:
- The AI knows to wait
- The user knows acknowledgment is needed
- Both parties synchronize

### 5. Mode Awareness Requires Reinforcement

Even with tutor mode instructions at the top, the AI slips back to passive assistance. We added reminders:

```markdown
⚠️ YOU ARE THE TOUR GUIDE
After user confirms server is running, immediately proceed 
to "Explore the Admin UI". DO NOT offer menu choices.
```

The AI's default is passive, so active guidance needs constant reinforcement.

---

## The Pattern: Teaching AI to Teach

This revealed a general pattern for **reliable AI-driven processes**:

### For Simple Tasks (1-3 steps):
- Clear instructions work fine
- AI interprets intent successfully
- Low risk of drift

### For Complex Sequences (10+ steps, 30+ minutes):
1. **Use checklists** with explicit tracking
2. **Add forcing functions** (require todo list creation)
3. **Create consent gates** ("Type 'go' to continue")
4. **Add wait states** ("Let me know when...")
5. **Make progress observable** (todo items checked off)
6. **Reinforce mode constantly** (AI defaults to passive)
7. **Validate incrementally** (catch drift early)

---

## The Killer Feature: Resilience

Traditional documentation has a fatal flaw: **one thing breaks, user abandons.**

**README failure modes:**
- Step 4 fails → user stuck, no diagnosis
- "Command not found" → venv wasn't activated
- "Address already in use" → server still running from earlier
- Wrong directory, port conflicts, permissions → **user gives up**

Result: **10% completion rate**. The other 90% hit one obstacle and leave.

**AI Tutor resilience:**
- **"I got an error"** → AI: *"Server already running - stop it with Shift-F5"*
- **"Command not found"** → AI: *"Your venv isn't activated. Let me help..."*
- **"This isn't working"** → AI: *"You're in the wrong directory. Use `cd basic_demo`"*
- Port conflict? AI recognizes the error and suggests solutions
- Browser showing stale data? AI suggests hard refresh
- Breakpoint not hitting? AI verifies file saved, server restarted

**The little stuff that kills demos:**
- Wrong terminal window (split-pane confusion)
- Forgot to save file before F5
- Typo in command (AI catches and corrects)
- Database locked from previous run
- Python version mismatch

**README assumes perfect execution. AI Tutor handles messy reality.**

This transforms a fragile demo into a **resilient learning experience that recovers from inevitable mistakes.**

That's the difference between 10% completion and 90%.

---

## The Message in a Bottle: Self-Teaching Projects

Our `tutor.md` approach enables several innovations:

### 1. Progressive Disclosure

We use `add-cust` commands to incrementally add complexity:

```bash
genai-logic add-cust --using=security  # Adds security features
genai-logic add-cust --using=discount  # Adds schema changes
```

Each step builds on the previous, teaching patterns rather than overwhelming with everything at once.

### 2. Provocation-Based Learning

The tutor deliberately surfaces misconceptions:

```markdown
After showing the rules work, ask:
"How did the system know to execute in the right order 
(Item → Order → Customer)?"

[Let them think procedurally]

Then explain: "It uses dependency discovery - no ordering required."
```

This addresses mental models explicitly, which passive docs can't do.

### 3. Teaching Patterns, Not Features

The tour emphasizes *why* behind declarative rules:

- **Reuse:** Rules apply across insert/update/delete automatically
- **Ordering:** Dependency graphs, not manual sequencing
- **Conciseness:** 5 rules vs 200+ lines of procedural code

Users leave understanding *how to think* about the system, not just *what buttons to click*.

---

## What We Built

The final `tutor.md` is 760 lines covering:

- **5 major sections** (Create & Run, Security, Logic, Python Integration, B2B)
- **15 checkpoints** with explicit user prompts
- **Provocation moments** surfacing procedural thinking then correcting it
- **Metrics comparison** (5 declarative rules vs 220+ lines of procedural code)
- **Execution checklist** forcing AI to track progress

When an AI assistant reads `tutor.md` and follows the structured approach, it reliably conducts a 30-45 minute hands-on tour that teaches declarative thinking.

---

## Try It Yourself

The pattern is adaptable to any project (you can [review ours here](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/tutor.md))

### 1. Create `TUTOR.md` in your project:

```markdown
# AI Guided Tour: [Your Project Name]

## EXECUTION CHECKLIST (AI: Read This FIRST)

Before starting, call manage_todo_list:

- [ ] Section 1: Setup
  - [ ] Step A
  - [ ] Step B
  - [ ] WAIT: User types 'next'
```

### 2. Design for forcing functions:

- Require todo list creation at start
- Add user prompts at boundaries
- Include consent gates
- Make progress observable

### 3. Test and iterate:

- Watch for sections the AI skips
- Note where users get confused
- Add warnings where needed
- Embrace that AI interprets — design around it

---

## The Meta-Lesson: Human-AI Collaboration

The most valuable part wasn't the final tutor — it was the *process* of discovering how to make AI reliable.

**Our "time machine" conversation:**

> **Human:** "Why did you skip that section?"  
> **AI:** "I interpreted the narrative as complete. I didn't see a boundary."  
> **Human:** "Can warnings help?"  
> **AI:** "Not really. I need structural constraints."  
> **Human:** "What kind of constraints?"  
> **AI:** "Forcing functions. Make me track progress explicitly."

This collaborative root-cause analysis — human noticing patterns, AI explaining its behavior, together designing solutions — is the real pattern.

**Teaching AI to teach** required:

1. **Human observation** — "The AI keeps skipping sections"
2. **AI introspection** — "I treat this as narrative, not script"
3. **Collaborative design** — "What structure forces reliability?"
4. **Iterative testing** — Trying, catching failures, adjusting

This is how we'll work with AI going forward: Not just *using* AI as a tool, but *collaborating* with AI to understand its limitations and design around them.

---

## Conclusion: Projects That Teach Themselves

`tutor.md` represents a new approach to technical education:

- **Not passive docs** — Active guided experience
- **Not video tutorials** — Interactive, personalized pacing
- **Not human-dependent** — Scales infinitely via AI
- **Not fragile** — Recovers from inevitable mistakes (10% → 90% completion)

The pattern is generalizable. Any complex project can embed AI tutor instructions. Any AI assistant can execute them. Any user can get hands-on guidance.

But the deeper lesson is about **working with AI effectively**:

- Expect interpretation, not just execution
- Use structure, not just clarity
- Make progress observable
- Validate incrementally
- Collaborate to understand limitations

AI can teach — but it needs the right scaffolding. Build that scaffolding well, and you get something remarkable: **Projects that teach themselves.**

---

## Resources

- **Example tutor.md:** See [`basic_demo/tutor.md`](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/basic_demo/tutor.md)
- **Previous article:** *Teaching AI to Program Itself: How We Solved a 30-Year Testing Problem in One Week*

---

**About the Author:**

Val Huber created GenAI-Logic / API Logic Server, exploring how AI transforms software development through declarative patterns. This is the second in a series on "learning to leverage AI" — practical lessons from building AI-integrated development tools.

---

*Thanks to the GitHub Copilot team for the chat interface that made these experiments possible, and to the AI assistant that helped write this article about teaching AI to teach.*
