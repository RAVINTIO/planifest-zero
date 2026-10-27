# Domain Glossary - reserve ids from a counter

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Version:** 0.21.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Counter file | `plan/backlog/.next-id`. It holds the next free id as one seven-digit number. | next-id file | ravintio-zero |
| Reservation | One call of `reserve-id.mjs`. It takes a block of ids and moves the counter past them. | reserve | ravintio-zero |
| Lock | A file named `.next-id.lock` that the script creates for the length of one reservation. | lock file | ravintio-zero |
| Source id | The id an entry had in the repo it was copied from. The copy names it in its text. | original id | ravintio-zero |
| Seed | The first value of a counter file. This repo seeds `0000210`. | none | ravintio-zero |
