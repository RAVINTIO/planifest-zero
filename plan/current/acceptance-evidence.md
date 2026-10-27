# Acceptance evidence - 0000200-reply-conventions

1. **Checks:** 176 feature suites and 19 regression suites pass under `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh`. The consistency check and the self-description check are clean. Self-corrections: 2 (the miss log was not excluded from git, and a risk entry overstated the parity suite).
2. **Security:** no critical or high finding. Two low findings are accepted: the transcript path and the 80 characters of reply text in the local miss log.
3. **Execution:** a reply that starts with plain text makes the hook exit 0, print a warning, and log one line. A reply that starts with `P4 Ship:` produces no output. A malformed payload, a missing transcript, and a missing sentinel each exit 0 with no output. `setup.sh` writes one `Stop` entry and keeps a user entry across two runs.
4. **Not run:** `setup.ps1` did not run, because the setup suites have no PowerShell runner. A source check confirms it declares the same entry.
5. **Deviation:** seven existing suites and one fixture asserted text the change altered and were updated. The size caps in the 0151 req-011 suites rose to 27,700 and 37,800 bytes. The combined cap covers the Reply Conventions section that step 13 installs into `CLAUDE.md`.
6. **Note:** the installed copies under `.claude/` and `CLAUDE.md` keep the old rules until step 13 reruns setup. This session's own `Stop` hook stays unwired until then.
