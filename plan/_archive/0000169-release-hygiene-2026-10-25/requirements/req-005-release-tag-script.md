---
title: "Requirement: REQ-005 - release-tag-script"
summary: "release-tag.mjs tags HEAD with the product version and pushes the tag to origin."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-005 - release-tag-script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Source:** US-003 (backlog 0000167)
**Priority:** must-have

## User Story

As a maintainer, I see every release tag on a commit that `git log main` shows, so that a tag always names shipped code.

## Functional Requirements
- Add `ravintio-zero/scripts/release-tag.mjs`.
- The script reads the version from `version:` in `product.yml`. If that is missing, it reads `version:` from the `docs/about.md` frontmatter.
- The script reads the feature id from `feature:` in `product.yml` for the tag message.
- If no version is found, or the version fails `^[0-9]+\.[0-9]+(\.[0-9]+)?$`, the script prints one clear line and exits 1.
- If `v{version}` exists locally or on the remote `origin`, the script prints a skip line and exits 0.
- Otherwise the script creates an annotated tag `v{version}` on `HEAD` with the message `{feature}` and pushes it to `origin`.
- If the push fails, the script prints the failure and exits 1.

## Acceptance Criteria
- [ ] In a temporary repo with a local bare `origin`, a run creates the annotated tag `v{version}` on `HEAD` with message `{feature}`, and the bare remote holds that tag.
- [ ] A second run, and a run where only `origin` holds the tag, print a skip line, exit 0, and leave the tags unchanged.
- [ ] A missing version, an invalid version, and a failed push each exit 1 with a clear line. A version read from the `docs/about.md` frontmatter works when `product.yml` has none.

## Dependencies
- REQ-006 runs this script from CI and the ship flow.
