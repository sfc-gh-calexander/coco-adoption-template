# CoCo Quickstart

A guide to installing Snowflake CoCo and connecting it to your Snowflake account. That's the whole scope: get CoCo running, on whichever surface fits how you work, then you're on your own to build.

Live site: https://sfc-gh-calexander.github.io/cortex-coco-adoption-template/

## What's here

| Path | Covers |
|---|---|
| `/` | Hub - what CoCo is, three ways to run it, prerequisites |
| `/desktop/` | CoCo Desktop - download, connect, first session, settings |
| `/cli/` | CoCo CLI - install, connect, first query, next steps |

There is no fourth surface page for the Snowsight-embedded panel - it's a single step (click the blue star icon in Snowsight) and is covered as a callout on the hub instead of its own page.

## Local development

The site is static HTML with a small shared asset layer (`presentations/assets/`: `base.css`, `doc.css`, `doc.js`, `coco-theme.css`). Open any `presentations/**/index.html` file directly in a browser - no build step.

## Deployment

`.github/workflows/deploy.yml` publishes `presentations/` to GitHub Pages on every push to `main`. `.github/workflows/validate.yml` runs on pull requests and checks for em dashes, emojis, "Cortex Code" mentions (the product name is CoCo), and broken internal links.
