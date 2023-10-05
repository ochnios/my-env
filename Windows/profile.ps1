# Aliases in Powershell aren't that easy...
function Get-Git { & git $args }
function Get-GitClone { & git clone $args }
function Get-GitStatus { & git status $args }
function Get-GitBranch { & git branch $args }
function Get-GitCommit { & git commit -m $args }
function Get-GitPush { & git push $args }
function Get-GitPull { & git pull $args }
function Get-GitCheckout { & git checkout $args }
function Get-GitAdd { & git add $args }
function Get-GitStash { & git stash $args }
function Get-GitDiff { & git diff $args }
function Get-GitLog { & git log --oneline $args }
function Get-GitRestoreStaged { & git restore --staged $args }
function Get-GitClean { & git clean -fd $args }
function Get-GitReset { & git reset $args }
function Get-GitResetHard { & git reset --hard $args }
function Get-GitRevert { & git revert $args }
function Get-GitMerge { & git merge $args }
function Get-GitCherryPick { & git cherry-pick $args }
function Get-GitTag { & git tag $args }
function Get-GitCount {
    $Like = $args[0]
    $Files = git ls-files | Where-Object { $_ -like "*$Like" }
    $TotalCount = 0
    $Tab = [char]9
    
    foreach ($file in $Files) {
        $Count = (Get-Content $File).Count
        Write-Output "$Count$Tab$File"
        $TotalCount += $Count
    }
    
    Write-Output "$TotalCount$Tab total"
}
function Get-GitPushNewBranch {
    $currentBranch = git branch --show-current
    & git push --set-upstream origin $currentBranch
}
function Get-GPT {
    & $HOME\bin\gpt.ps1 -UserMessage $args[0] -SystemMessage $args[1] 
}
function Get-GPT4 {
    & $HOME\bin\gpt.ps1 -UserMessage $args[0] -SystemMessage $args[1] -Model "gpt-4"
}

function Set-Aliases {
    $Aliases = @{
        # git aliases
        g      = "Get-Git"
        gcl    = "Get-GitClone"
        gs     = "Get-GitStatus"
        gb     = "Get-GitBranch"
        gc     = "Get-GitCommit"
        gph    = "Get-GitPush"
        gpl    = "Get-GitPull"
        gco    = "Get-GitCheckout"
        ga     = "Get-GitAdd"
        gsh    = "Get-GitStash"
        gd     = "Get-GitDiff"
        gl     = "Get-GitLog"
        grs    = "Get-GitRestoreStaged"
        gclean = "Get-GitClean"
        gr     = "Get-GitReset"
        grhard = "Get-GitResetHard"
        grv    = "Get-GitRevert"
        gmrg   = "Get-GitMerge"
        gcp    = "Get-GitCherryPick"
        gt     = "Get-GitTag"
        gcount = "Get-GitCount"
        gphnew = "Get-GitPushNewBranch"

        # other aliases
        gpt    = "Get-GPT"
        gpt4   = "Get-GPT4"
    }

    foreach ($Alias in $Aliases.Keys) {
        $Value = $Aliases[$Alias]
        Set-Alias -Name $Alias -Value $Value -Force -Scope Global
    }
}

function Set-Variables {
    $env:Path += "${HOME}\bin"
}

function Set-Powershell {
    # OhMyPosh
    # Import-Module Terminal-Icons
    # Import-Module posh-git
    # oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\bubblesextra.omp.json" | Invoke-Expression
    
    $PSReadLineOptions = @{
        PredictionSource              = "HistoryAndPlugin"
        PredictionViewStyle           = "ListView"
        HistorySearchCursorMovesToEnd = $true
    }

    Set-PSReadLineOption @PSReadLineOptions
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# here we go
Set-Aliases
Set-Variables
Set-Powershell