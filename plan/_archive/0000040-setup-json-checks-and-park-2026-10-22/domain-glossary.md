---
title: "Domain Glossary - setup-json-checks-and-park"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.7.0"
---
# Domain Glossary - setup-json-checks-and-park

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000040-setup-json-checks-and-park
**Version:** 0.7.0

> The ubiquitous language for this feature. If the glossary says "Order", the code says `Order` - not "Purchase" or "Transaction". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| settings object | The top level of `.claude/settings.json` when it is a plain JSON object. Setup can read and merge only this shape. | | planifest-zero |
| plain object | A JSON object. An array, `null`, a string, a number, and a boolean are not plain objects. | | planifest-zero |
| shape check | The test that `settings.json` holds a settings object and that any `hooks` value is a plain object. It runs before any write (req-001, req-002). | | planifest-zero |
| fixed error line | The one message both scripts print on a shape check failure: `! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.` It never includes file content or a parser message. | shared message | planifest-zero |
| case-duplicate keys | Two keys in one JSON object that differ only by letter case, such as `{"a":1,"A":2}`. `ConvertFrom-Json` throws on them, so `setup.ps1` fails the shape check. `setup.sh` accepts them because node reads them. | | planifest-zero |
| nesting depth cap | The limit of 1024 levels of JSON nesting. `Test-JsonText` fails above it, before the parse (req-003). | depth cap | planifest-zero |
| `Test-JsonText` | The `setup.ps1` function that checks JSON text is strictly valid. It tracks depth with an integer and a `[System.Collections.Generic.Stack[char]]`. | | planifest-zero |
| `hooks` value | The `hooks` field of `settings.json`. A value of `null` counts as absent. | | planifest-zero |
| park | The orchestrator command that shelves a part-finished feature on its branch, files a backlog entry, and returns the working tree to `main` (req-004). | | planifest-zero |
| parked entry | A backlog entry whose status is `parked`. It names the feature branch that holds the shelved work. | | planifest-zero |
| park record | The file `plan/current/park.md`, written from `park.template.md`. It holds the phase reached, the last artifact, the head commit, and the reason. | `park.md` | planifest-zero |
| chore PR | The pull request from `chore/park-{feature-id}` that carries the parked entry to `main`. Park raises it with `gh pr create`, and the human merges it. | | planifest-zero |
| sentinel | A state marker file that lives on the feature branch only. Because of this, `main` needs no cleanup when you park. | | planifest-zero |
| resume detection | The orchestrator check at session start that restores state from `pause.md` or `park.md`. When it finds `park.md` with no chore PR, it finishes the chore PR step. | | planifest-zero |
| backlog pickup | The step at P1 where the human chooses a backlog entry to pull in. A parked entry offers resume or discard (req-005). | pull-in | planifest-zero |
| resume | The choice that checks out the parked branch, merges `origin/main`, and restores state from `park.md`. | | planifest-zero |
| discard | The choice that deletes the parked branch locally and on `origin`. It runs only after the human confirms. | | planifest-zero |
