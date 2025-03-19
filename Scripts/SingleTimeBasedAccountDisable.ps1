# Import Active Directory module
Import-Module ActiveDirectory

# Variables - Replace these values
$samAccountName = "replace"  # The user account to disable
$targetDate = "mm/dd/yyyy"   # The date when account should be disabled

# Get current date
$currentDate = Get-Date -Format "MM/dd/yyyy"

# Check if today is the target date
if ($currentDate -eq $targetDate) {
    try {
        # Check if account exists and is not already disabled
        $user = Get-ADUser -Identity $samAccountName -Properties Enabled
        if ($user.Enabled) {
            # Disable the account
            Disable-ADAccount -Identity $samAccountName
            Write-Host "Successfully disabled account: $samAccountName"
            
            # Optional: Log the action
            $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Disabled account $samAccountName"
            Add-Content -Path "C:\Temp\AccountDisable.log" -Value $logMessage
        }
    }
    catch {
        Write-Host "Error: Failed to disable account. $_"
    }
}
