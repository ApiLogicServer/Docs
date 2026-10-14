---
title: Students & Courses
version: 1.0, 10/13/2026
---
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

!!! pied-piper ":bulb: TL;DR - When the CE correctly refuses to guess, and what resolving it later looks like"

    * **`students_courses`** — a course-attendance requirement with two traps a literal
      reading won't reveal: a column named `consecutive_absences` whose own requirement text
      says `count(...)` (a plain count never resets — it needs a streak, not a tally), and a
      Course Drop-Off Alert that depends on an `Attendance(status='absent')` row that nothing
      in the system ever writes. The CE catches both unaided: the streak gets built correctly,
      and the alert logic is left commented out with a `FIXME` rather than guessing a trigger
      mechanism it was never asked to invent.
    * **`students_courses_1`** — the same project, carried one phase further. A second
      Executable Requirements pass supplies the missing design decision (an externally
      triggered sweep endpoint, suited to a clustered deployment, plus an `Enrollment` table
      the sweep needs to know who was expected) and turns the `FIXME` into working code.

# Students & Courses

A two-phase example of the Executable Requirements workflow: the first phase shows the CE
correctly identifying that a requirement depends on a design decision it hasn't been given,
and the second phase shows what happens once that decision arrives.

## Phase 1 — `students_courses`: correctly blocked

The requirement reads naturally: *"if a student has 2+ consecutive absences, dispatch a
drop-off alert."* Nothing in it says what writes an `absent` row when a student simply
doesn't show up — a missed class is a non-event, and no rule engine can fire on a row that
never arrives. Rather than invent a trigger mechanism unprompted, the implementation leaves
the streak/alert logic commented out with a `FIXME`, and files the gap — with candidate
strategies, not a silent pick — in its own `ad-libs.md`.

[Full report](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/manager/samples/students_courses/docs/requirements/course_dropoff/ad-libs.md)

## Phase 2 — `students_courses_1`: resolved

Given the missing decision — a scheduled reconciliation job, triggered externally rather
than by an in-process timer (so a clustered deployment never races multiple instances
against the same sweep) — the second pass adds a plain `POST /api/attendance_sweep`
endpoint and an `Enrollment` table, then re-enables the already-written streak and alert
logic. The `Enrollment` table also fixed a second, separately-filed finding for free:
`Course.enrolled_count` had been counting Attendance records instead of distinct enrolled
students.

![Logic diagram: Enrollment/Attendance/Alert rule chain for students_courses_1](images/students_courses/logic_diagram.svg)

[Full report](https://github.com/ApiLogicServer/ApiLogicServer-src/blob/main/api_logic_server_cli/prototypes/manager/samples/students_courses_1/docs/requirements/students_courses_attendance_sweep/ad-libs.md)

## Try it

```bash
# Phase 1, from the Manager:
implement reqs students_courses

# Phase 2, on a copy of the resulting project:
implement reqs students_courses_attendance_sweep
```
