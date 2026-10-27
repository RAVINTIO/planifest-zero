# Acceptance evidence - 0000196-setup-argument-checks

1. **Checks:** 170 feature suites and 19 regression suites pass under `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh`. The consistency check is clean. Self-corrections: 2 (a test grep for the exact tool match, and two guard tests that flagged old names in new files).
2. **Security:** no critical or high finding. One low finding predates the feature (`ravintio-zero/setup.sh` prints an unknown tool name unchanged).
3. **Execution:** an unknown tool exits 1 and leaves the repo unchanged. A missing tool prints usage and exits 0. Each retired flag exits 1 with a named error and no repo change. A `--backend-url` value never appears in the output. REQ-003 is not verifiable by execution because the refresh skill is Markdown. A structural suite covers it.
4. **Deviation:** a missing tool keeps exit 0. The brief first said exit 1, and the backlog entry said the exit code stays. Artifacts now match.
5. **Backlog count:** the entry listed six tests to change. Four needed it.
