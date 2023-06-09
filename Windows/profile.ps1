# Aliases in Powershell aren't that easy...
function Get-Git { & git $args }
function Get-GitStatus { & git status $args }
function Get-GitBranch { & git branch $args }
function Get-GitCommit { & git commit -m $args }
function Get-GitPush { & git push $args }
function Get-GitPull { & git pull $args }
function Get-GitCheckout { & git checkout $args }
function Get-GitAdd { & git add $args }
function Get-GitLog { & git log --oneline $args }
function Get-GitRestoreStaged { & git restore --staged $args }
function Get-GitResetHard { & git reset --hard $args }
function Get-GitMerge { & git merge $args }
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

function Set-Aliases {
    $Aliases = @{
        # git aliases
        g      = "Get-Git"
        gs     = "Get-GitStatus"
        gb     = "Get-GitBranch"
        gc     = "Get-GitCommit"
        gph    = "Get-GitPush"
        gpl    = "Get-GitPull"
        gco    = "Get-GitCheckout"
        ga     = "Get-GitAdd"
        gl     = "Get-GitLog"
        grs    = "Get-GitRestoreStaged"
        grhard = "Get-GitResetHard"
        gmrg   = "Get-GitMerge"
        gcount = "Get-GitCount"
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