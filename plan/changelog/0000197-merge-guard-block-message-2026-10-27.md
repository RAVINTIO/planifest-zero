# Changelog (0000197-merge-guard-block-message, 27 Oct 2026)

**Feature:** merge-guard block message
**Version:** 0.20.1
**PR:** pending, updated at Step 9

## What changed

- The `merge-guard` hook says "The command names a merge in text that isn't a merge call" when a segment holds merge words and is not a bare merge call. A heredoc line is one example.
- The text reason, the quoting reason, and the over-4096 reason each tell the agent to use the Write tool to write a file.
- A new suite covers the three messages and checks that the block set is unchanged.
- The architecture overview describes the text reason.

## Why

The hook blocked a heredoc that named the merge command and said the command was over 4096 characters. The agent could not tell that merge words in text caused the block, or that the Write tool avoids it. Backlog entry 0000190 asked for the change.

## Deviations

- No existing test asserted the old message text, so none changed.

## Validation results

171 feature suites and 19 regression suites pass. The consistency check is clean. No critical or high security finding. The hook's control flow is unchanged.

## Skipped phases

None.
