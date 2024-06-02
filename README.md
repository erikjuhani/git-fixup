# git-fixup

Creates a git fixup commit that is amended automatically to the target commit.

'fzf' is used to improve the user experience by providing a selectable list of
usable commits. If 'fzf' is not found in the PATH user must provide the commit
hash to the 'git-fixup' command.

This command is intended to be used as a git alias. Aliases can be added to
'.gitconfig' file. Add an alias to the '.gitconfig' file called 'fixup' (or
some other preferred name) and point it to the location of this script.

```.gitconfig
[alias]
	fixup = git-fixup
```

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

## Installation

Easiest way to install `git-fixup` is with [shm](https://github.com/erikjuhani/shm).

To install `shm` run either one of these one-liners:

curl:

```sh
curl -sSL https://raw.githubusercontent.com/erikjuhani/shm/main/shm.sh | sh
```

wget:

```sh
wget -qO- https://raw.githubusercontent.com/erikjuhani/shm/main/shm.sh | sh
```

then run:

```sh
shm get erikjuhani/git-fixup
```

to get the latest version of `git-fixup`.

`git-fixup` uses `fzf` which can be installed by following the instructions [here](https://github.com/junegunn/fzf#installation).

## Usage

```sh
git-fixup [<commit_hash>]
```

When commit hash is not provided `git-fixup` will use 'fzf' to provide a list
of selectable commits in the branch, however, if 'fzf' is not found in the
PATH, user _must_ provide a commit hash.

### Examples

#### Amend to older commit behind 2 commits in the current branch

```sh
git add file.txt
git-fixup HEAD~2
```

#### Amend to older commit in the current branch using git alias

```sh
git add file.txt
git fixup HEAD~2
```

#### Amend to selected commit with 'fzf'

```sh
git add file.txt
git-fixup
```
