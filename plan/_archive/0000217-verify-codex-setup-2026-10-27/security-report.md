# Security report - 0000217-verify-codex-setup

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Until a person trusts the hook, Codex runs no `merge-guard`, so a merge command is not blocked, including in `codex exec`. | `.codex/hooks.json` as written by `ravintio-zero/setup.sh` | Medium | Mitigated in documentation. Setup output, `AGENTS.md`, `getting-started.md`, and `README.md` now say so. `AGENTS.md` also tells the agent never to merge into `main`. Trust remains a human decision. |
| Running `codex exec` in a repo adds a `trust_level = "trusted"` entry for that path to the user's Codex config. | `~/.codex/config.toml` | Low | Not mitigated. The path is a temp folder. Remove the entry for `/private/tmp/codex-verify.*` if you want a clean config. |

Checked and clean:

- The stub `gh` only appends arguments to a file in the temp repo. Nothing reached GitHub.
- No credential appears in the changed files or the evidence.
- The run used no trust bypass and no edit of the trust state.

Overall risk rating: low. Open risks: the post-trust block is unverified (see `verification-report.md`).
