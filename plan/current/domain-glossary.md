---
title: "Domain Glossary - faster-setup-ps1-tests"
summary: "Definitions of the setup copy and timing terms used in this feature."
status: "draft"
version: "0.1.0"
---
# Domain Glossary - faster-setup-ps1-tests

**Skill:** plan
**Feature:** 0000171-faster-setup-ps1-tests
**Version:** 0.15.1

> The ubiquitous language for this feature. If the glossary says "Timing total", the code says the `setup.ps1 total` line, not "sum line" or "run time". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Bundle rules | The rules that decide which pack files `setup.ps1` installs as skills, and in which form. The parity test checks the installed tree against them. | None | ravintio-zero |
| Installed tree | The set of skill and hook files that `setup.ps1` writes under the project root. Its paths and bytes stay the same after this feature. | None | ravintio-zero |
| Timing line | A `[timing]` line that `run-tests.ps1` prints to the host. It never enters data that a test captures. | None | ravintio-zero |
| Timing total | The sum of every `setup.ps1` time in a run, in milliseconds. `run-tests.ps1` reads it from the file named by `RAVINTIO_TIMING_FILE` and prints it with the case count. | None | ravintio-zero |
| Host | The PowerShell edition that runs a script. This feature supports Windows PowerShell 5.1 and PowerShell 7. | PowerShell host | ravintio-zero |
