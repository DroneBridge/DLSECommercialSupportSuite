<#
.SYNOPSIS
Updates this repository from origin's default branch.

.DESCRIPTION
Fetches origin, resolves origin/HEAD by default, stashes tracked local changes,
updates the selected branch with a fast-forward pull, updates submodules, and
then reapplies the stash. Untracked files are not stashed or deleted.

.PARAMETER Branch
Optional remote branch name to update from, for example "master". When omitted,
the script uses origin/HEAD.

.EXAMPLE
.\update_repository.ps1

.EXAMPLE
.\update_repository.ps1 -Branch master
#>

[CmdletBinding()]
param(
    [string]$Branch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message"
}

function Invoke-Git {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & git @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Get-GitOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $output = & git @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
    return ($output -join "`n").Trim()
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or is not available on PATH."
}

$repoRoot = Resolve-Path -LiteralPath $PSScriptRoot
$insideWorkTree = Get-GitOutput -Arguments @("-C", $repoRoot, "rev-parse", "--is-inside-work-tree")
if ($insideWorkTree -ne "true") {
    throw "This script must be run from inside a Git repository checkout."
}

$actualRoot = Resolve-Path -LiteralPath (Get-GitOutput -Arguments @("-C", $repoRoot, "rev-parse", "--show-toplevel"))
if ($actualRoot.Path -ne $repoRoot.Path) {
    throw "This script must be run from the repository root: $($actualRoot.Path)"
}

Write-Step "Fetching origin"
Invoke-Git -Arguments @("-C", $repoRoot, "fetch", "--prune", "origin")

if ([string]::IsNullOrWhiteSpace($Branch)) {
    $originHead = & git -C $repoRoot symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($originHead)) {
        Invoke-Git -Arguments @("-C", $repoRoot, "remote", "set-head", "origin", "-a")
        $originHead = Get-GitOutput -Arguments @("-C", $repoRoot, "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD")
    }
    $Branch = $originHead -replace "^origin/", ""
}

if ([string]::IsNullOrWhiteSpace($Branch)) {
    throw "Could not resolve the branch to update from. Pass -Branch master or another branch name."
}

$remoteRef = "refs/remotes/origin/$Branch"
& git -C $repoRoot show-ref --verify --quiet $remoteRef
if ($LASTEXITCODE -ne 0) {
    throw "Remote branch origin/$Branch was not found. Run with a different -Branch value."
}

$stashCreated = $false
$stashMessage = "update_repository.ps1 automatic tracked-changes stash"

try {
    & git -C $repoRoot diff --quiet
    $hasUnstagedChanges = $LASTEXITCODE -ne 0
    & git -C $repoRoot diff --cached --quiet
    $hasStagedChanges = $LASTEXITCODE -ne 0

    if ($hasUnstagedChanges -or $hasStagedChanges) {
        Write-Step "Stashing tracked local changes"
        Invoke-Git -Arguments @("-C", $repoRoot, "stash", "push", "-m", $stashMessage)
        $stashCreated = $true
    }

    Write-Step "Switching to $Branch"
    & git -C $repoRoot show-ref --verify --quiet "refs/heads/$Branch"
    if ($LASTEXITCODE -eq 0) {
        Invoke-Git -Arguments @("-C", $repoRoot, "switch", $Branch)
        Invoke-Git -Arguments @("-C", $repoRoot, "branch", "--set-upstream-to=origin/$Branch", $Branch)
    } else {
        Invoke-Git -Arguments @("-C", $repoRoot, "switch", "--track", "-c", $Branch, "origin/$Branch")
    }

    Write-Step "Pulling latest changes with fast-forward only"
    Invoke-Git -Arguments @("-C", $repoRoot, "pull", "--ff-only", "origin", $Branch)

    Write-Step "Updating submodules"
    Invoke-Git -Arguments @("-C", $repoRoot, "submodule", "update", "--init", "--recursive")

    if ($stashCreated) {
        Write-Step "Reapplying tracked local changes"
        & git -C $repoRoot stash pop
        if ($LASTEXITCODE -ne 0) {
            throw "Stash pop reported conflicts. Resolve them, then run git status."
        }
    }

    Write-Step "Repository update complete"
    Invoke-Git -Arguments @("-C", $repoRoot, "status", "--short")
} catch {
    Write-Host ""
    Write-Host "Update failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "No destructive reset was run. Check the current state with:"
    Write-Host "  git status"
    if ($stashCreated) {
        Write-Host "If your tracked changes were not reapplied, inspect them with:"
        Write-Host "  git stash list"
        Write-Host "  git stash show --stat stash@{0}"
    }
    exit 1
}
