#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: ./update_repository.sh [--branch BRANCH]

Updates this repository from origin's default branch. Pass --branch master to
update from origin/master instead. The script stashes tracked local changes,
pulls with --ff-only, updates submodules, and reapplies the stash. Untracked
files are not stashed or deleted.
USAGE
}

branch=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --branch)
            if [[ $# -lt 2 || -z "${2:-}" ]]; then
                echo "Error: --branch requires a branch name." >&2
                exit 1
            fi
            branch="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: unknown argument '$1'." >&2
            usage
            exit 1
            ;;
    esac
done

step() {
    printf '\n==> %s\n' "$1"
}

if ! command -v git >/dev/null 2>&1; then
    echo "Error: Git is not installed or is not available on PATH." >&2
    exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$(git -C "$script_dir" rev-parse --is-inside-work-tree)" != "true" ]]; then
    echo "Error: this script must be run from inside a Git repository checkout." >&2
    exit 1
fi

repo_root="$(git -C "$script_dir" rev-parse --show-toplevel)"
repo_root="$(cd -- "$repo_root" && pwd)"
if [[ "$repo_root" != "$script_dir" ]]; then
    echo "Error: this script must be run from the repository root: $repo_root" >&2
    exit 1
fi

step "Fetching origin"
git -C "$repo_root" fetch --prune origin

if [[ -z "$branch" ]]; then
    origin_head="$(git -C "$repo_root" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
    if [[ -z "$origin_head" ]]; then
        git -C "$repo_root" remote set-head origin -a
        origin_head="$(git -C "$repo_root" symbolic-ref --quiet --short refs/remotes/origin/HEAD)"
    fi
    branch="${origin_head#origin/}"
fi

if [[ -z "$branch" ]]; then
    echo "Error: could not resolve the branch to update from. Pass --branch master or another branch name." >&2
    exit 1
fi

if ! git -C "$repo_root" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    echo "Error: remote branch origin/$branch was not found. Run with a different --branch value." >&2
    exit 1
fi

stash_created=0
stash_message="update_repository.sh automatic tracked-changes stash"

on_error() {
    status=$?
    echo
    echo "Update failed." >&2
    echo "No destructive reset was run. Check the current state with:" >&2
    echo "  git status" >&2
    if [[ "$stash_created" -eq 1 ]]; then
        echo "If your tracked changes were not reapplied, inspect them with:" >&2
        echo "  git stash list" >&2
        echo "  git stash show --stat stash@{0}" >&2
    fi
    exit "$status"
}
trap on_error ERR

if ! git -C "$repo_root" diff --quiet || ! git -C "$repo_root" diff --cached --quiet; then
    step "Stashing tracked local changes"
    git -C "$repo_root" stash push -m "$stash_message"
    stash_created=1
fi

step "Switching to $branch"
if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$repo_root" switch "$branch"
    git -C "$repo_root" branch --set-upstream-to="origin/$branch" "$branch"
else
    git -C "$repo_root" switch --track -c "$branch" "origin/$branch"
fi

step "Pulling latest changes with fast-forward only"
git -C "$repo_root" pull --ff-only origin "$branch"

step "Updating submodules"
git -C "$repo_root" submodule update --init --recursive

if [[ "$stash_created" -eq 1 ]]; then
    step "Reapplying tracked local changes"
    git -C "$repo_root" stash pop
fi

trap - ERR
step "Repository update complete"
git -C "$repo_root" status --short
