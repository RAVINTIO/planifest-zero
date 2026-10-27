# Acceptance evidence - 0000197-merge-guard-block-message

1. **Checks:** 171 feature suites and 19 regression suites pass under `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh`. The consistency check is clean. Self-corrections: 0.
2. **Security:** no critical or high finding. The hook's control flow is unchanged.
3. **Execution:** a heredoc that names the merge command exits 2 with a message that says the command names a merge in text and names the Write tool. The same command over 4096 characters exits 2 with the length reason and the Write tool advice. A plain squash merge into `initiative/*` still exits 0.
4. **Deviation:** none. No existing test asserted the old message text, so none changed.
5. **Observed during the run:** the first attempt to write the P0 artifacts with a long heredoc hit the old message. This reproduced the backlog entry before the fix.
