# Push main to GitHub only through a pull request whose checks pass (the owner's CrossTalk rule, 2026-11-06): the
# commits go to an update/<time> branch, a pull request runs .github/workflows/check.yml, and only a passing one is
# merged (a merge commit); then main here is brought up to GitHub's. .githooks/pre-push refuses any push to main.
#   . "$PSScriptRoot\pr_push.ps1"; Push-ThroughPullRequest -Remote github -Title "..."
function Push-ThroughPullRequest([string]$Remote = "github", [string]$Title = "Update") {
    $ErrorActionPreference = "Continue"
    git config core.hooksPath .githooks
    $url = git remote get-url $Remote
    if ($url -notmatch "github\.com[:/](.+?)(\.git)?$") { throw "not a GitHub address: $url" }
    $repo = $Matches[1]
    git fetch --quiet $Remote main 2>&1 | Out-Null
    git merge-base --is-ancestor HEAD FETCH_HEAD 2>$null
    if ($LASTEXITCODE -eq 0) { "GitHub already has every commit: nothing to push"; return }
    $branch = "update/" + (Get-Date -Format "yyyyMMdd-HHmmss")
    git push $Remote "HEAD:refs/heads/$branch" 2>&1 | ForEach-Object { "$_" }
    if ($LASTEXITCODE) { throw "push of $branch failed (git exit $LASTEXITCODE)" }
    $subjects = (git log --format="- %s" FETCH_HEAD..HEAD | Select-Object -First 30) -join "`n"
    $body = "Commits:`n$subjects`n`n" + [char]::ConvertFromUtf32(0x1F916) + " Generated with [Claude Code](https://claude.com/claude-code)"
    gh pr create --repo $repo --base main --head $branch --title ($Title + " " + (Get-Date -Format "yyyy-MM-dd HH:mm")) --body $body 2>&1 | ForEach-Object { "$_" }
    if ($LASTEXITCODE) { throw "pull request for $branch not opened" }
    $deadline = (Get-Date).AddMinutes(3)
    do { Start-Sleep -Seconds 10; $n = @(gh pr checks $branch --repo $repo --json name 2>$null | ConvertFrom-Json).Count } while (-not $n -and (Get-Date) -lt $deadline)
    if (-not $n) { throw "no check started on the pull request for ${branch}: left open, not merged" }
    gh pr checks $branch --repo $repo --watch --fail-fast --interval 20 2>&1 | Select-Object -Last 3 | ForEach-Object { "$_" }
    if ($LASTEXITCODE) { throw "checks failed on the pull request for ${branch}: left open, not merged" }
    gh pr merge $branch --repo $repo --merge 2>&1 | ForEach-Object { "$_" }
    if ($LASTEXITCODE) { throw "merge of the pull request for $branch failed" }
    gh api -X DELETE "repos/$repo/git/refs/heads/$branch" 2>&1 | Out-Null
    git pull --quiet --ff-only $Remote main 2>&1 | ForEach-Object { "$_" }
    if ($LASTEXITCODE) { throw "merged on GitHub, but main here did not move up to it" }
    "merged into GitHub's main through a pull request whose checks passed ($branch)"
}
