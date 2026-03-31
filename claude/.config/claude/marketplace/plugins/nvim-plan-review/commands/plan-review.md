---
name: nvim-plan-review:plan-review
description: Open a plan or document in Neovim for interactive review. After the review, address any comments by editing the document.
argument-hint: [file-path]
allowed-tools: Bash(*/bin/plan-review *), Read, Edit
---

# Review Document

Review the document at `$ARGUMENTS` using Neovim in a Zellij floating pane.

## Step 1: Launch the review

Check if `$ZELLIJ` is set. If in Zellij, run this command with **no timeout** since it blocks until the user finishes reviewing:

```bash
~/.config/claude/marketplace/plugins/nvim-plan-review/bin/plan-review review $ARGUMENTS
```

If not in Zellij (command fails), ask the user to run the review manually:

> Please run this in your terminal, review the document with comments, and let me know when you're done:
>
> ```
> nvim "+lua require('util.plan-review').setup('$ARGUMENTS')" "$ARGUMENTS"
> ```

Wait for the user to confirm before proceeding.

## Step 2: Read the comments

After the review completes, read the comments:

```bash
~/.config/claude/marketplace/plugins/nvim-plan-review/bin/plan-review status $ARGUMENTS
```

This outputs JSON with the file path and comments array. If the comments array is empty, the user had no feedback — the document is approved. You're done.

## Step 3: Address comments

For each comment in the `comments` array:

1. Read the `line` number and `content_snippet` to locate where in the document the comment applies
2. Read the `body` for what the reviewer wants changed
3. Edit the document at `$ARGUMENTS` to address the comment

After addressing ALL comments, clear the comments so they don't carry over to the next review:

```bash
~/.config/claude/marketplace/plugins/nvim-plan-review/bin/plan-review clear $ARGUMENTS
```

Summarize what you changed.

## Step 4: Re-review (optional)

After making changes, ask the user if they want to re-review:

> "I've addressed all comments. Want to review the changes? I'll open the review again."

If yes, go back to Step 1. If no, done.

## Important notes

- Do NOT modify the document while Neovim is open — only edit after it exits
- The `content_snippet` field shows the line content when the comment was created — use it to find the right location even if line numbers have shifted
