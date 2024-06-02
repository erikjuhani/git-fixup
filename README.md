# git-fixup

## Problem statement

Applying changes to the last commit with git is trivial, but when applying
changes to older commits we need to run cumbersome commands to make the changes
and to keep the git history pristine.

I'm quite certain that many developers will face the issue of wanting to edit a
previous commit, especially when relying on rebase mechanics (as one should).
However, fixups are a great way to keep the context of the commit knowledge
within a single commit by directly modifying the existing commit and rebasing
the history.

If you are not familiar with rebasing, I highly recommend reading the following
chapter from the Pro Git book [3.6 Git Branching -
Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing).

The usual flow for applying fixups is as follows:

```
# Stage changes for older commit in the branch
git add file.txt

# Find the commit hash by using the log command and copy the commit hash
git log --oneline origin..

# Create a fixup
git commit --fixup <commit_hash>

# Interactive rebase with autosquash and autostash
git rebase -i --autosquash --autostash
```

As we can see, the process itself is quite cumbersome and requires a better
approach, especially since this is a recurring operation that happens multiple
times a day.


## Solution

The solution is simple:

Create a git alias called `fixup` that will run a POSIX-compatible shell
script, which automates the cumbersome parts of the fixup operation.

The same example as above, but with the fixup command:

```
# Stage changes for older commit in the branch
git add file.txt

# Prompts fzf to select commit hash the fixup should be applied to.
# After selection creates a fixup that is rebased to the original commit.
git fixup
```

As we can see, the solution is vastly simpler than the original way of creating
fixup commits.

The one caveat is the requirement of the external dependency fzf, but I'd
imagine this is one of the 'default' tools developers have on their machines
anyway.
