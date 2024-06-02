#!/usr/bin/env sh

set -e

help() {
  cat <<EOF
git-fixup
Creates a git fixup commit that is amended automatically to the target commit.

'fzf' is used to improve the user experience by providing a selectable list of
usable commits. If 'fzf' is not found in the PATH user must provide the commit
hash to the 'git-fixup' command.

This command is intended to be used as a git alias. Aliases can be added to
'.gitconfig' file. Add an alias to the '.gitconfig' file called 'fixup' (or
some other preferred name) and point it to the location of this script.

USAGE
	git-fixup <commit_hash>

EXAMPLES
	Amend to older commit behind 2 commits in the current branch
	git add file.txt
	git-fixup HEAD~2

	Amend to older commit in the current branch using git alias
	git add file.txt
	git fixup HEAD~2

	Amend to selected commit with 'fzf'
	git add file.txt
	git-fixup
EOF
  exit 2
}

err() {
  printf >&2 "error: %s\n" "$@"
  exit 1
}

print() {
  printf "%b\n" "$@"
}

git_log_branch_commits() {
  git --no-pager log --oneline origin..
}

git_commit_select() {
  git_log_branch_commits |
    fzf \
      --pointer=" " \
      --reverse \
      --height=10 \
      --no-scrollbar \
      --preview="printf '%s' {} | awk '{ print \$1 }' | xargs git show" | awk '{ print $1 }'
}

git_fixup() {
  total_commits="$(git_log_branch_commits | wc -l | bc)"
  total_commits_and_fixup="$((total_commits + 1))"
  # GIT_SEQUENCE_EDITOR is set to colon to prevent git from opening a text editor
  git commit --fixup "$1" && GIT_SEQUENCE_EDITOR=: git rebase --interactive --autosquash --autostash HEAD~"${total_commits_and_fixup}"
}

fixup() {
  for arg; do
    case "${arg}" in
      -h | --help) help ;;
      -*) err "Unknown option ${arg}" ;;
    esac
  done

  if ! command -v fzf >/dev/null; then
    [ -z "$1" ] && err "Commit hash needs to be provided as 'fzf' was not found in PATH"
    git_fixup "$1"
  fi

  git_fixup "$(git_commit_select)"
}

fixup "$@"
