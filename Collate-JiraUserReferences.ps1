# Function to fetch information for a given userkey
function FetchUserinfo() {

    $userRestEndPoint = $serverUrl.TrimEnd("/") + "/rest/api/2/user?key=$($userKey)"
    try {
        "INFO`tFetching user information for $($userKey)" | Out-File $logFile -Append
        $userInfo = Invoke-RestMethod -Method Get -Headers $Global:headers -Uri $userRestEndPoint
    }
    catch {
        $userInfo = $null
        "ERROR`tFailed to fetch user information for $($userKey)" | Out-File $logFile -Append
        "ERROR`t$_.Exception.Message" | Out-File $logFile -Append
    }
    return $userInfo
}
function Main {
    
    $logFile = "UserReferences.log"
    $outputFile = "UserInfo.txt"
    Out-File $logFile
    "userKey,userName,email,displayName,active" | Out-File $outputFile

    $Global:serverUrl = Read-Host "Provide the server URL (https://<fqdn>)"
    $Global:personalAccessToken = Read-Host "Provide the Personal Access Token " -MaskInput
    $Global:headers = @{
        "Authorization" = "Bearer $($personalAccessToken)"
        "Accept"        = "application/json"
        "Content-Type"  = "application/json"
    }
    # Mandatory to have the following files
    $RequiredFiles = @(
        "CustomfieldUserReferences.csv",
        "JiraActionUserReferences.csv",
        "JiraIssueUserReferences.csv",
        "UserActionsUserReferences.csv"
    )
    $UserReferenceFiles = Get-ChildItem
    # Iterate and check if the mandatory files exist under the current path
    foreach ($file in $RequiredFiles) {
        if (!$UserReferenceFiles.Name.Contains($file)) {
            "Did not find the file $($file) under $($PWD.Path)"
            break
        }
    }
    # Collate the users from various references.
    $jiraIssueIssueReferences = Import-Csv ./JiraIssueUserReferences.csv
    $jiraActionUserReferences = Import-Csv ./JiraActionUserReferences.csv
    $userActionUserReferences = Import-Csv ./UserActionsUserReferences.csv
    $customfieldUserReferences = Import-Csv ./CustomfieldUserReferences.csv

    # Declared a Hashset to keep unique values from collated references
    $uniqueUsersHashSet = New-Object System.Collections.Generic.HashSet[string]
    $jiraIssueIssueReferences.userreference | ForEach-Object { [void]$uniqueUsersHashSet.Add($_) } 
    $jiraActionUserReferences.userreference | ForEach-Object { [void]$uniqueUsersHashSet.Add($_) }
    $userActionUserReferences.userreference | ForEach-Object { [void]$uniqueUsersHashSet.Add($_) }
    $customfieldUserReferences.userreference | ForEach-Object { [void]$uniqueUsersHashSet.Add($_) }

    foreach ($userKey in $uniqueUsersHashSet) {
        $userInfo = FetchUserinfo $userKey
        if ($userInfo) {
            $email = $userInfo.emailAddress
            $name = $userInfo.name
            $displayName = $userInfo.displayName
            $active = $userInfo.active
            "$($userKey),$($name),$($email),$($displayName),$($active)" | Out-File UserInfo.txt -Append
        }
    }
    Write-Host "Check the followig files: $($logFile), $($outputFile)"
}
Main
