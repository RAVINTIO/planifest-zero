# Acceptance evidence - 0000199-reserve-ids-from-counter

1. **Checks:** 173 feature suites and 19 regression suites pass under `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh`. The consistency check and the self-description check are clean. Self-corrections: 1.
2. **Security:** no critical or high finding. Two low findings are accepted: the `--file` path and the stale lock.
3. **Execution:** reserving 4 ids from 0000188 prints 0000188 to 0000191 and leaves 0000192. Eight concurrent reservations of 3 ids return 24 different ids. A held lock, a bad counter, a symlink, and a bad quantity each exit 1 and change nothing.
4. **Deviation:** four existing suites asserted the old folder-scan wording (0000025, 0000043, 0000151, 0000164). They now assert the counter. The 0000151 suite applies a base-line rewrite for the pickup line, as 0000171 did for its change.
5. **Note:** the installed skill copies under `.claude/skills/` keep the old rule until step 13 reruns setup. Step 10 of the initiative queues ids from this counter.
