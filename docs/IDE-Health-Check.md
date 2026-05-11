!!! pied-piper "Technology Preview"
    Project Health Check is a technology preview. The feature works today —
    say "vital signs" in any project. Scoring weights and thresholds are still
    being calibrated based on real-world use. Feedback welcome.

# Project Health Check — Vital Signs

GenAI-Logic projects are governed by declarative rules. But how do you know
if a project is *well* governed? And how does a manager see rule adoption
across a portfolio of projects — without reading every line of code?

**Project Health Check** answers both questions. Say `vital signs` in any project
and the AI scans your logic files, computes two scores, checks for red flags,
and offers to fix every finding.

&nbsp;

## Background: The Versata Automation Analyzer

This capability is inspired by a tool built at Versata in the 1990s — the
**Automation Analyzer**. Versata generated Java superclasses for business rules;
the analyzer measured the ratio of generated (declarative) code to hand-written
(procedural) code across teams and projects.

The findings were striking. Across Fortune 500 deployments with tens to hundreds
of thousands of lines of code:

- **High-automation projects:** 98% declarative
- **Low-automation projects:** 94% declarative

The gap — just 4 percentage points — represented thousands of lines of procedural
code that bypassed the rules engine, with corresponding maintenance costs and
production bugs. Teams that resisted rules didn't avoid *all* rules — they avoided
the *hardest* ones: multi-table aggregations (sums, counts) that require trusting
the engine to handle all change paths automatically.

The analyzer made that resistance visible. Managers could spot a struggling team
in seconds, without reading code. Training and consulting followed.

GenAI-Logic's Health Check is that analyzer, updated for AI-assisted development.

&nbsp;

## How It Works

Say `vital signs` (or `health check`) in any project workspace. The AI:

1. Reads all logic files in `logic/logic_discovery/` and `logic/declare_logic.py`
2. Reads `database/models.py` to count domain tables
3. Computes two scores and checks for red flags
4. Reports findings with exact file:line citations
5. Offers to fix each finding in the same session

No configuration required. Zero overhead until invoked.

&nbsp;

## The Two Scores

### Coverage Score — Are your tables governed by rules?

```
Coverage Score = weighted_rules / domain_table_count
```

Rules are weighted by their value — how much procedural code they replace:

| Rule type | Weight | Why |
|---|---|---|
| `Rule.sum` | 3 | Replaces multi-path aggregate on every change path |
| `Rule.count` | 3 | Same — existence checks, cardinality constraints |
| `Rule.formula` | 2 | Replaces derivation on every write path |
| `Rule.copy` | 2 | Replaces copy + cascade on parent change |
| `Rule.constraint` | 1 | Replaces one guard — trivial to write procedurally |

A constraint is worth 1 point; a sum is worth 3 — because a sum rule replaces
derivation, propagation, and cascade across all change paths automatically. A
procedural aggregate does none of that.

**Reference ranges:**

| Score | Grade | Meaning |
|---|---|---|
| ≥ 4.0 | ✅ Strong | Well-governed; meaningful rules on most tables |
| 2.0–3.9 | 🟡 Moderate | Some tables likely ungoverned |
| 1.0–1.9 | 🟠 Thin | Mostly constraints; low rule density |
| < 1.0 | 🔴 Weak | Project largely procedural |

### Integrity Score — Is the rule code correct?

```
Integrity Score = 100 - demerits
```

Demerits penalize patterns that look like rules but silently fail — broken
dependency tracking, procedural aggregates replacing rules, and hygiene issues
that cause the AI to generate wrong rules on the next iteration.

**Key demerits:**

| Pattern | Points | Why |
|---|---|---|
| `session.query()` inside a formula | -3 | Goes stale on child changes — use `Rule.count` |
| `as_expression=lambda row: my_func(row)` | -2 | LB sees no `row.attr` refs — rule never re-fires |
| Event assigns `row.attr =` with no I/O | -2 | Should be `Rule.formula` or `Rule.copy` |
| Rules in `declare_logic.py` (not discovery) | -2 | Traceability lost — migrate to logic_discovery/ |

**Hall passes** exempt legitimately procedural code: Kafka publish functions,
EAI consumer bridges, AI handler functions (OpenAI/Anthropic calls), and
Allocate recipients functions. These patterns are structural, not failures to use rules.

**Reference ranges:**

| Score | Grade |
|---|---|
| ≥ 95 | ✅ Good |
| 85–94 | 🟡 Fair — some findings to address |
| 75–84 | 🟠 Poor — likely bugs in production logic |
| < 75 | 🔴 Critical — immediate remediation needed |

&nbsp;

## Red Flag — The Governance Signal

Beyond the two scores, the health check raises a binary red flag:

> **≥ 10 tables with incoming foreign keys AND zero `Rule.sum` + zero `Rule.count`**

This is the primary signal for a team that has not adopted rules. Not a low score —
*none*. A project with 10+ tables and no aggregation rules has almost certainly
written those derivations procedurally, or not at all.

```
🚨 RED FLAG: 12 tables with child relationships, zero aggregation rules.
   Suggestion: schedule rules training or consulting engagement.
```

### Acknowledging a Known Exception

If the flag applies but is intentional (schema locked, read-only reporting project,
legacy integration), acknowledge it formally in `logic/logic_discovery/use_case.py`:

```python
"""
@health-check: red-flag-suppress
Reason: schema locked — aggregations implemented in stored procedures
Reviewer: val
Date: 2026-05-10
"""
```

`Reason:` is required. The acknowledgement appears in the health check report
with the reviewer's name and date — a permanent audit trail.

&nbsp;

## Sample Report

```
## 🩺 Project Vital Signs

Coverage Score: 5.8  (29 weighted rules / 5 tables)   ✅ Strong
Integrity Score: 98  (1 demerit, 0 reviewed)
Red Flag: none  (3 aggregation rules, 5 FK tables)

────────────────────────────────────────
COVERAGE DETAIL
  Tables (5): CustomsEntry, SurtaxLineItem, HsCodeRate, Province, CountryOrigin
  Rules:  3× sum, 6× formula, 6× copy, 2× constraint

INTEGRITY FINDINGS
  🟡 -1  logic/logic_discovery/cbsa_surtax/validation.py:8
         docstring contains implementation note beyond requirement text
         → Fix: replace with verbatim requirement text only

────────────────────────────────────────
1 finding needs attention. Want me to fix it?
```

&nbsp;

## The nw_sample Contrast — See It In Action

The Manager workspace includes two Northwind projects that tell the before/after
story concretely. **Open these files now** to see what a real health check report
looks like:

**Before — `samples/nw_sample_nocust/health_check_nw_sample_nocust.md`**  
Freshly created from the Northwind database. No rules added. This is what every
project looks like on day one:
- Coverage: **0.0** — Red Flag: 🚨 raised (16 FK tables, zero aggregations)
- Integrity: 100 (vacuously — nothing to demerit yet)

**After — `samples/nw_sample/health_check_nw_sample.md`**  
Same schema, rules added. This is what the project looks like after a developer
has worked through the logic:
- Coverage: **2.1** — Red Flag: none
- Integrity: **96** — 3 minor organizational findings, no bugs

The jump from 0.0 → 2.1 coverage and 🚨 → no flag is the value of rule adoption
made visible in two numbers. The full reports show exactly which rules were added,
which tables they govern, and what the remaining findings are.

!!! tip "Try it yourself"
    Open `samples/nw_sample/` as a workspace and say `vital signs`.
    You will get a live report equivalent to `health_check_nw_sample.md` —
    plus the offer to fix each finding in the same session.

&nbsp;

## Portfolio View — Governance at Scale

For organizations running multiple GenAI-Logic projects, health check scores
provide a natural basis for tracking rule adoption across teams.

Ask the AI to score all projects at once:

```
"vital signs across all projects — rank by coverage score"
```

This produces a ranked summary table — a leaderboard that makes rule adoption
visible and comparable without reading a single line of code.

**Why this works as an adoption tool:**

- The score is actionable in an afternoon — one `Rule.sum` declaration visibly
  moves the number
- The red flag creates urgency without a mandate — no team wants to be the
  only 🚨 on the board
- Peer learning replaces enforcement — "how did Team A get to 5.8?" is a better
  conversation than "you must use more rules"
- The `@health-check` acknowledgement requires a name and reason — suppressing
  a flag to game the leaderboard is visible to management

**Trend tracking** matters more than absolute scores. A project at 2.0 trending
up is healthier than one at 4.0 trending down. Run health checks after each
significant release and track direction.

For full governance policy, score thresholds, and manager roll-up guidance,
see `docs/training/governance.md` in any created project.

&nbsp;

## Technical Reference

| File | Purpose |
|---|---|
| `docs/training/health_check.md` | AI instructions — scoring algorithm, detection patterns, fix protocol |
| `docs/training/governance.md` | Human policy — thresholds, red flags, portfolio view, Versata baseline |
| `samples/health_checks.md` | Cross-project health check for all Manager samples |
| `samples/nw_sample/health_check_nw_sample.md` | Single-project example (with rules) |
| `samples/nw_sample_nocust/health_check_nw_sample_nocust.md` | Single-project example (baseline) |
