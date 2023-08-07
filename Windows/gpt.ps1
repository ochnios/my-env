param (
    [Parameter(Mandatory = $true)]
    [string]$UserMessage,
    [string]$SystemMessage,
    [string]$Model = "gpt-3.5-turbo",
    [double]$Temperature = 1.0,
    [string]$Url = "https://api.openai.com/v1/chat/completions",
    [switch]$Raw
)

$Headers = @{
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer $env:OPENAI_API_KEY"
}

$Request = @{
    model       = $model
    messages    = @(
        @{
            role    = "user"
            content = $UserMessage
        }
    )
    temperature = $Temperature
}

if ($SystemMessage.Length -gt 0) {
    $Request.messages += @{
        role    = "system"
        content = $SystemMessage
    }
}

$Request = $Request | ConvertTo-Json -Depth 10

try {
    $Response = Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $Request
}
catch {
    Write-Host "Status code:" $_.Exception.Response.StatusCode.value__ -ForegroundColor Red
    Write-Host "Message: " $_.Exception.Message -ForegroundColor Red
    Break
}

if ($Raw) {
    $Response | ConvertTo-Json -Depth 10 | Write-Host
}
else {
    $ResponseMessage = $Response.choices[0].message.content -replace "\\n", "`n"
    $PromptTokens = $Response.usage.prompt_tokens
    $CompletionTokens = $Response.usage.completion_tokens
    $TotalTokens = $Response.usage.total_tokens

    Write-Host $ResponseMessage
    Write-Host "`nPrompt tokens: $PromptTokens" -ForegroundColor DarkGray
    Write-Host "Completion tokens: $CompletionTokens" -ForegroundColor DarkGray
    Write-Host "Total tokens: $TotalTokens" -ForegroundColor DarkGray
}
