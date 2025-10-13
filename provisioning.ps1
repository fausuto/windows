# Define the date format for the log file
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Define the path to the provisioning folder
$ProvisioningPath = "$env:PROGRAMDATA\Microsoft\Provisioning"

# =============================================================================
# CONFIGURATION: THIS SECTION IS WHERE YOU WOULD EDIT WHAT YOU WANT THE NAME OF
# A FILE TO BE, OR THE URL LINK TO DOWNLOAD EXECUTABLE, OR EVEN CHANGE THE NAME
# OF THE SOFTWARE TO CHECK IF CERTAIN SOFTWARE IS ALREADY INSTALLED.
# =============================================================================

# Define the transcript file location
$TranscriptFile = "$ProvisioningPath\$Date-secrets-install-url.txt"

# Define the name of the software to check
$secretZip = "$ProvisioningPath\secrets.zip"

# Define the name of the software to check
$secretPath = "$ProvisioningPath\secrets"

# Define the path where the installer will be downloaded
$secretExe = "$ProvisioningPath\secrets\bws.exe"

# Define the arguments to use with the installer
$secretArgs = "secret", "get", "344563b3-c03f-4c15-8e69-b3720103da6c"

# =============================================================================
# THIS IS WHERE THE SCRIPT BEGINS. USUALLY NO NEED TO CHANGE MUCH DEPENDING ON
# THE SOFTWARE BEING INSTALLED. SOMETIMES YOU DO HAVE TO CHANGE THE DIFFERENT
# ARGUMENTS IF NEEDED.
# =============================================================================

# Start a Log file
Start-Transcript -Path "$TranscriptFile"

# Best practice: Use a function for reusable logic and clear scope
function Test-InternetConnection
{
    param (
        [string]$Target = '8.8.8.8',
        [int]$IntervalSeconds = 5
    )

    # Save the original progress preference for restoration
    # Using $global: ensures the variable is set regardless of the function's scope
    $originalProgressPreference = $global:ProgressPreference
    $global:ProgressPreference = 'SilentlyContinue'

    try
    {
        Write-Host "Testing internet connection. Target: $Target" -ForegroundColor Green
        $connected = $false
        do
        {
            try
            {
                # The progress bar is now suppressed by the $ProgressPreference variable
                $testResult = Test-NetConnection -ComputerName $Target -InformationLevel Quiet -ErrorAction Stop
                $connected = $testResult
            } catch
            {
                # Catch block handles network errors gracefully instead of failing
                $connected = $false
            }

            if (-not $connected)
            {
                Write-Host "Waiting for network connection... (sleeping for $IntervalSeconds seconds)" -ForegroundColor Yellow
                Start-Sleep -Seconds $IntervalSeconds
            }
        } while (-not $connected)

        Write-Host "Network connection successful!" -ForegroundColor Green
        return $true
    } finally
    {
        # Restore the original progress preference
        $global:ProgressPreference = $originalProgressPreference
    }
}

# Call the function in your main script logic
Test-InternetConnection

Pause
