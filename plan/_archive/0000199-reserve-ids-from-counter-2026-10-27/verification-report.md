# Verification report - 0000199-reserve-ids-from-counter

**Method:** each check ran `node ravintio-zero/scripts/reserve-id.mjs` in a temporary folder with a counter file, or searched the changed docs. The folder was removed afterwards.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 reserve a block | Counter at 0000188, reserved 4 ids | verified | Printed 0000188 to 0000191. The file held 0000192. |
| REQ-001 AC-2 concurrent reservations | 8 reservations of 3 ids started at once in the suite | verified | 24 different ids and the file held 0000124. |
| REQ-001 AC-3 failed reservation changes nothing | A held lock, letters, a symlink, quantities 0, 1001, and abc, and an overflow | verified | Each exited 1 and left the folder as it was. A manual run with a held lock exited 1 after 5.07 seconds and named the lock. |
| REQ-002 AC-1 bootstrap | Folders numbered 0000041, 0000039, 0000030, and 0000007, then `--init` | verified | Printed 0000042. The file held 0000043. |
| REQ-002 AC-2 missing counter | No counter, no `--init` | verified | Exit 1 and no file created. |
| REQ-002 AC-3 shipped seed | Read `plan/backlog/.next-id` | verified | It holds 0000210. |
| REQ-003 AC-1 skill calls the script | Searched the file-backlog skill | verified | It names `reserve-id.mjs` and `.next-id`, and no longer names `plan/_archive/`. |
| REQ-003 AC-2 copied entry | Searched the skill and the backlog template | verified | Both name the source id rule. |
| REQ-003 AC-3 no scan rule left | Searched the six docs for "highest ever allocated" and read the conflict answer | verified | No match. `roadmap-standards.md` says to keep the higher value and renumber. |

**Full suite:** 173 feature suites and 19 regression suites pass. The consistency check is clean over `plan/current`, and the self-description check passes.
