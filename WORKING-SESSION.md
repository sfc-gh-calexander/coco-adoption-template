# CoCo Adoption - Working Session

A phase-driven runbook for building an account-specific CoCo agent with a customer. Follow phases in order. Each phase has an entry condition and an exit artifact. Do not advance past a failing gate.

Paired with the full reference at: [Hands-on Lab](https://your-org.github.io/cortex-coco-adoption-template/lab/)

---

## Before You Start

Have these ready before the session:

- [ ] CoCo enabled on the customer Snowflake account
- [ ] Access to 1-2 source tables that answer a question the customer cares about
- [ ] One business question defined: *"I want to be able to ask: ___"*
- [ ] A warehouse (XS is fine)
- [ ] `SYSADMIN` or equivalent role (needs `CREATE SEMANTIC VIEW`, `CREATE AGENT`)

Write the one-sentence build brief before Phase 1:

> Build an agent that answers **[business question]** using **[table 1]** and **[table 2]**.

**What CoCo can build:** the build brief above assumes a conversational agent (semantic view + Cortex Analyst agent), which is the pattern this runbook walks through step by step. CoCo is a general coding agent, so the same three discovery questions can just as easily point to a Streamlit app or dashboard, a dbt model or Dynamic Table pipeline, or a notebook analysis instead. Phases 3-4 below cover the agent pattern as one worked example; swap in the artifact that actually answers the customer's question.

---

## Phase 1 - Discovery

**Entry condition:** you have a customer and a meeting.

**Goal:** leave this phase with the build brief filled in above.

Run these three questions before touching Snowflake:

1. *What decision does your team make every week that takes longer than it should?*
2. *Where does the data that informs that decision live today?*
3. *If you could ask that data a question in plain English and get an answer in 10 seconds, what would you ask?*

Map question 3 to a table. That table is your build target.

**Exit artifact:** the one-sentence build brief above is filled in.

---

## Phase 2 - Setup (30 minutes)

**Entry condition:** build brief is filled in.

Open CoCo Desktop or a Snowflake Workspace. Run:

```sql
-- Verify CoCo and Cortex features are enabled
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();

-- Verify you can see the target tables
SHOW TABLES IN DATABASE <customer_db>;

-- Check row count and freshness on target table(s)
SELECT COUNT(*), MAX(<date_column>) FROM <customer_db>.<schema>.<table>;
```

Confirm:
- [ ] CoCo is enabled (CoCo Desktop connects without error)
- [ ] Target tables are accessible and have recent data
- [ ] You have CREATE SEMANTIC VIEW and CREATE AGENT privileges

Copy `starter/semantic_view_example.sql` into the session.

**Exit artifact:** the starter file is open, tables are confirmed accessible, privileges are confirmed.

---

## Phase 3 - Build: Semantic View + Agent pattern

**Entry condition:** target tables confirmed, starter file open.

This phase covers the agent pattern: a semantic view feeding a Cortex Analyst text-to-SQL agent. If the build brief points to an app, dashboard, or pipeline instead, the same entry/exit/gate structure applies, just with a different artifact.

Edit `semantic_view_example.sql`:

1. Replace the table references with the actual `DATABASE.SCHEMA.TABLE` paths
2. Update `DIMENSIONS` to match the columns the customer will group/filter by (use business names, not column names)
3. Add `METRICS` for the 1-2 KPIs that answer the build brief
4. Add one `AI_VERIFIED_QUERY` phrased exactly as the customer would ask it

Run:

```sql
-- Create the semantic view
-- (paste the contents of semantic_view_example.sql)
```

Confirm:
- [ ] Semantic view creates without error
- [ ] Run a quick Cortex Analyst test query to verify it answers the target question

**Gate:** the semantic view answers the build brief question correctly before advancing.

**Exit artifact:** deployed semantic view.

---

## Phase 4 - Build: Agent

**Entry condition:** semantic view is deployed and validated.

In CoCo, create a new agent:

```sql
CREATE OR REPLACE AGENT <customer>_analyst
  TOOLS = (
    TOOL_TYPE => CORTEX_ANALYST_TEXT_TO_SQL,
    TOOL_NAME => 'data_analyst',
    SEMANTIC_VIEW => '<database>.<schema>.<semantic_view_name>',
    TOOL_DESCRIPTION => 'Answers questions about <what the SV covers>'
  )
  INSTRUCTIONS = (
    ORCHESTRATION => 'You answer questions about <customer domain>. Use the data_analyst tool. If you cannot answer from the data, say so.',
    RESPONSE => 'Answer in plain language. Lead with the number or answer, then explain briefly.'
  );
```

Test with three questions:
1. The exact question from the build brief
2. A follow-up the customer is likely to ask
3. An out-of-scope question (verify it handles gracefully)

**Gate:** all three questions return useful, accurate answers.

**Exit artifact:** deployed agent that answers the target question.

---

## Phase 5 - Demo and Handoff

**Entry condition:** agent is deployed and validated.

**Demo script:**

1. Open CoCo, switch to the agent
2. Ask the build brief question - let the customer see their own data answer it
3. Ask a follow-up they didn't expect to work
4. Invite them to ask a question

**Objection handling (quick reference):**

| Objection | Response |
|---|---|
| "We already have Copilot / ChatGPT" | Those answer from the internet. This answers from your Snowflake data, with your governance controls, and it doesn't leave your environment. |
| "My data team won't trust it" | Show them the generated SQL. Every answer is explainable and auditable - it's not a black box. |
| "This is just a demo, not production" | The semantic view and agent you just built are already production objects. This is not a sandbox. |
| "What does this cost to run?" | Cortex AI usage is billed per token. For a typical analyst question at this data volume, it is cents per query. |
| "How do we maintain this?" | The semantic view is SQL you version-control. The agent spec is a SQL DDL statement. Update it the same way you update any other database object. |

**AE handoff card - fill this in before ending the session:**

```
Account: _______________
Date: _______________
What the demo answered: _______________
The most impressive moment: _______________
Three follow-up questions the customer should ask next:
  1.
  2.
  3.
Expansion story: _______________
SE who built it: _______________
Next step (owned by AE): _______________
```

**Exit artifact:** AE has the handoff card. The agent is deployed and live.

---

## Notes

- A dedicated data governance skill (data governance patterns for regulated industries) can replace Phase 3 for healthcare/financial services accounts - check internally for the latest version before the session.
- Aim for ≥95% answer accuracy before handing off to the AE. Run a quick 5-question eval to confirm.
- If you get stuck, the reference pages are in the lab site: exhibit-a (capabilities) and exhibit-b (vertical patterns).
