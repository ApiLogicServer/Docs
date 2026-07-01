---
title: Entity Subtypes — Single Table Inheritance Pattern
notes: background and design rationale for entity_subtypes sample project
source: docs/Sample-Yypes.md
version: 1.0 (Jul 2026)
---

# Entity Subtypes — Single Table Inheritance Pattern

**Audience:** Technical GenAI-Logic evaluators and developers

**Sample prompt:** `samples/prompts/entity_subtypes.prompt.md`

&nbsp;

## What This Illustrates

Two independent classification axes on the same entity — in this case `Employee`:

1. **Employment type** — strict hierarchy: `salaried` | `hourly` | `commissioned`
2. **Military status** — orthogonal flag: any employee can *also* be military, regardless of employment type

&nbsp;

## Three Approaches to Type Hierarchies

| Approach | Tables | GL preference |
|---|---|---|
| **STI (Single Table Inheritance)** | One table, `type` discriminator column, nullable subtype cols | ✅ Preferred |
| **Joined CTI (Class Table Inheritance)** | Base table + one joined table per subtype | ❌ Avoid |
| **Concrete CTI** | One separate table per subtype, no shared base | ❌ Avoid |

&nbsp;

## Why STI Wins in This Stack

**API:** `GET /api/Employee/` returns all employees in one call — no joins, no custom endpoints.  
**Insert:** `POST /api/Employee/` with a `type` value inserts any subtype in one call.  
**Admin UI:** `show_when` in `admin.yaml` hides/shows subtype fields based on the discriminator — no separate UI sections needed.  
**Rules:** LogicBank rules on the base class fire for all subtypes; rules on a subtype class fire only for that type.  
**Aggregates:** A parent `Department.total_salary` sums `Employee.salary` across all subtypes in one `Rule.sum` — no union required.

Joined CTI requires custom API endpoints for insert and list, and splits the Admin UI — far more effort for no practical gain in this stack.

&nbsp;

## The Orthogonal Axis Argument

The military classification is the key argument **for** STI over joined CTI:

- An employee can be **both** `commissioned` **and** `military` simultaneously
- Joined CTI has no clean home for a row that belongs to two subtype tables at once
- STI handles both axes with two discriminator columns (`type` + `is_military`) on one table, zero joins

This generalises: whenever classifications are **orthogonal** (independent of each other), STI is the only approach that avoids combinatorial table explosion.

&nbsp;

## Schema Pattern

```sql
CREATE TABLE employee (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    type            TEXT NOT NULL,          -- 'salaried' | 'hourly' | 'commissioned'
    name            TEXT NOT NULL,
    dept_id         INTEGER REFERENCES department(id),
    salary          REAL,                   -- on BASE table so Dept aggregate works for all types
    -- hourly-only (nullable for other types):
    hours_worked    REAL,
    hourly_rate     REAL,
    -- commissioned-only:
    base_salary     REAL,
    commission_total REAL,
    -- military orthogonal axis (any type):
    is_military     INTEGER DEFAULT 0,
    branch          TEXT,
    rank            TEXT,
    service_years   INTEGER,
    military_stipend REAL,
    total_compensation REAL
);
```

Key rule: any column needed for **cross-subtype aggregation** (e.g. `salary`) must live on the base table.

&nbsp;

## SQLAlchemy Mapper Args

```python
class Employee(Base):
    __tablename__ = 'employee'
    __mapper_args__ = {'polymorphic_on': 'type', 'polymorphic_identity': 'employee'}

class HourlyEmployee(Employee):
    __mapper_args__ = {'polymorphic_identity': 'hourly'}

class CommissionedEmployee(Employee):
    __mapper_args__ = {'polymorphic_identity': 'commissioned'}
```

&nbsp;

## LogicBank Rules — Scoped by Class

```python
# Fires for ALL employees (base class):
Rule.constraint(validate=models.Employee,
                as_condition=lambda row: row.total_compensation >= 0, ...)

# Fires only for hourly employees:
Rule.formula(derive=models.HourlyEmployee.salary,
             as_expression=lambda row: row.hours_worked * row.hourly_rate)

# Fires only for commissioned employees:
Rule.sum(derive=models.CommissionedEmployee.commission_total,
         as_sum_of=models.Order.amount)

# Cross-subtype aggregate on parent:
Rule.sum(derive=models.Department.total_salary, as_sum_of=models.Employee.salary)
```

&nbsp;

## Admin UI — show_when

```yaml
- Employee:
    fields:
      - name: hours_worked
        show_when: type == 'hourly'
      - name: hourly_rate
        show_when: type == 'hourly'
      - name: base_salary
        show_when: type == 'commissioned'
      - name: commission_total
        show_when: type == 'commissioned'
      - name: branch
        show_when: is_military == 1
      - name: rank
        show_when: is_military == 1
      - name: service_years
        show_when: is_military == 1
      - name: military_stipend
        show_when: is_military == 1
```
