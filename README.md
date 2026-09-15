# Cortex Code Adoption Template

A customer-facing resource for driving Cortex Code (CoCo) adoption: a business value deck, a hands-on lab, and a step-by-step runbook that any SE can pick up and run.

Modeled after [Tony's Cortex Agents + dbt template](https://innovation-igloo.github.io/beyond-a-reasonable-dbt/).

---

## What is in this repo

| Path | What it is |
|---|---|
| `presentations/` | GitHub Pages site — landing page, executive deck, HoL, reference pages |
| `WORKING-SESSION.md` | Step-by-step runbook to follow live in a Workspace or alongside a customer |
| `starter/semantic_view_example.sql` | Semantic view skeleton to copy and adapt |

## GitHub Pages

This repo publishes to GitHub Pages from the `presentations/` folder. The site has four paths:

- `/` — Landing page (two paths: Decision Maker and Builder)
- `/the-case/` — Why account-specific CoCo builds drive adoption
- `/executive/` — Business value deck (~10 slides, keyboard-navigable)
- `/lab/` — Hands-on Lab (5-phase walkthrough)
- `/exhibit-a/` — CoCo capabilities reference
- `/exhibit-b/` — Anonymized vertical patterns

To publish: Settings > Pages > Source: Deploy from branch > Branch: `main` > Folder: `/presentations`.

## Using the runbook

Open `WORKING-SESSION.md` in a Snowflake Workspace (or Cortex Code Desktop) alongside the customer environment. Follow the phases in order. Each phase has an entry condition and an exit artifact — do not advance past a failing gate.

## Using the starter semantic view

Copy `starter/semantic_view_example.sql` and point it at the customer's tables:

```sql
-- 1. Replace DATABASE.SCHEMA.YOUR_TABLE with actual table references
-- 2. Update DIMENSIONS to match actual column names
-- 3. Add METRICS for the business KPIs you want to expose
-- 4. Add one VERIFIED_QUERY for the most common question
-- 5. Run the file to create the semantic view
```

## Prerequisites

To run the HoL with a customer:

- Snowflake account with Cortex features enabled
- CoCo (Cortex Code) enabled on the account
- 1-2 source tables identified that answer a business question the customer cares about
- One business question defined before the session starts

## License

Apache 2.0
