# PowerShell Script to Check Password Expiry for an On-Prem AD User

# Prompt user to input the SAMAccountName
$SAMAccountName = Read-Host -Prompt "Enter the SAMAccountName of the user"

# Ensure input is not empty
if (-not $SAMAccountName) {
    Write-Host "No SAMAccountName provided. Exiting..." -ForegroundColor Red
    exit
}

try {
    # Retrieve the user object from Active Directory
    $user = Get-ADUser -Identity $SAMAccountName -Properties PasswordLastSet, PasswordNeverExpires, AccountExpirationDate

    if (-not $user) {
        Write-Host "User with SAMAccountName '$SAMAccountName' not found." -ForegroundColor Red
        exit
    }

    # Check if the user has a password set to never expire
    if ($user.PasswordNeverExpires) {
        Write-Host "The user '$SAMAccountName' has a password set to never expire." -ForegroundColor Yellow
    } else {
        # Calculate the password expiry date
        $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
        $passwordExpiryDate = $user.PasswordLastSet + $maxPasswordAge

        if ($passwordExpiryDate -lt (Get-Date)) {
            Write-Host "The password for user '$SAMAccountName' has expired on $($passwordExpiryDate.ToShortDateString())." -ForegroundColor Red
        } else {
            Write-Host "The password for user '$SAMAccountName' is valid and will expire on $($passwordExpiryDate.ToShortDateString())." -ForegroundColor Green
        }
    }

    # Check if the account itself is expired
    if ($user.AccountExpirationDate -and $user.AccountExpirationDate -lt (Get-Date)) {
        Write-Host "The account for user '$SAMAccountName' has expired on $($user.AccountExpirationDate.ToShortDateString())." -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
