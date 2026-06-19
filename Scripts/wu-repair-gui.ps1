Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Update Repair Tool"
$form.Size = New-Object System.Drawing.Size(600,400)
$form.StartPosition = "CenterScreen"

# Output Box
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Size = New-Object System.Drawing.Size(550,250)
$outputBox.Location = New-Object System.Drawing.Point(20,20)
$form.Controls.Add($outputBox)

# Button
$btn = New-Object System.Windows.Forms.Button
$btn.Text = "Run Repair"
$btn.Size = New-Object System.Drawing.Size(120,40)
$btn.Location = New-Object System.Drawing.Point(230,290)
$form.Controls.Add($btn)

# Function to log output
function Write-OutputBox {
    param ($msg)
    $outputBox.AppendText("$msg`r`n")
    $outputBox.Refresh()
}

# Repair function
$btn.Add_Click({

    Write-OutputBox "Starting repair..."

    $services = @("wuauserv","bits","cryptsvc")

    # Stop services
    foreach ($svc in $services) {
        try {
            Stop-Service $svc -Force -ErrorAction Stop
            Write-OutputBox "$svc stopped"
        } catch {
            Write-OutputBox "$svc already stopped"
        }
    }

    Start-Sleep -Seconds 2

    # Clear SoftwareDistribution
    Write-OutputBox "Clearing SoftwareDistribution..."
    try {
        Remove-Item "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction Stop
        Write-OutputBox "SoftwareDistribution cleared"
    } catch {
        Write-OutputBox "Error clearing SoftwareDistribution"
    }

    # Reset Catroot2
    Write-OutputBox "Resetting Catroot2..."
    try {
        Rename-Item "C:\Windows\System32\catroot2" "catroot2.old" -ErrorAction Stop
        Write-OutputBox "Catroot2 reset"
    } catch {
        Write-OutputBox "Catroot2 already handled"
    }

    # Start services
    foreach ($svc in $services) {
        try {
            Start-Service $svc
            Write-OutputBox "$svc started"
        } catch {
            Write-OutputBox "Failed to start $svc"
        }
    }

    # Run DISM
    Write-OutputBox "Running DISM (this may take time)..."
    DISM /Online /Cleanup-Image /RestoreHealth | Out-Null
    Write-OutputBox "DISM completed"

    # Run SFC
    Write-OutputBox "Running SFC..."
    sfc /scannow | Out-Null
    Write-OutputBox "SFC completed"

    # Check if reboot required
    $rebootRequired = Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"

    if ($rebootRequired) {
        Write-OutputBox "Reboot is required."

        $result = [System.Windows.Forms.MessageBox]::Show(
            "A reboot is required. Restart now?",
            "Reboot Required",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($result -eq "Yes") {
            Write-OutputBox "Rebooting..."
            Restart-Computer -Force
        } else {
            Write-OutputBox "Reboot cancelled."
        }
    } else {
        Write-OutputBox "No reboot required."
    }

    Write-OutputBox "Repair completed."
})

# Run Form
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
