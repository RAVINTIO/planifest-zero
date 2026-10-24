---
title: "Backlog Entry: 0000147 - Chart front-loads more step stops"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000147 - Chart front-loads more step stops

**Source feature:** 0000043-autonomous-roadmaps
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-24

---

## Problem

A roadmap step stops for a human at any exception stop. 0000043 moves schema approval into R-A Chart, while the human is still present. Two other stops can still halt a step that Chart could have foreseen:

- A backlog entry too vague for P0 to draft a brief from.
- A step that adds a new library or service.

## Suggested Action

At R-A Chart, check that each step's backlog entries are clear enough to draft from, and ask the human to sharpen any that aren't. List any library or service each step is likely to add, and ask the human to approve the list. A step that adds an unlisted dependency stops as it does today.

## Why Deferred

The live acceptance run showed only the schema stop. 0000043 fixes that one and keeps its scope to it.
