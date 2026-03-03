# Commit and Push

Commit all staged/modified files and push to the remote repository.

## Instructions

1. Run `git status` to see current changes
2. Run `git diff` to see what will be committed
3. Run `git log --oneline -3` to see recent commit style
4. Stage all modified and new files (exclude untracked files that look unrelated)
5. Create a commit with a concise message describing the changes
6. Push to the remote repository
7. Report the commit hash when done

Never NEVER EVER end the commit message with and keep only one human author:

```
Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```
