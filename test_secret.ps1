param (
	[string]$MyPassword
)

if ([string]::IsNullOrEmpty($MyPassword))
{
	Write-Error "Error: The password parameter was not provided."
	exit 1
}

# The password is in memory. Do not output it directly.
Write-Host "Successfully received password as a parameter. It is a string of length $($MyPassword.Length)."

# Perform a safe operation that uses the password, such as creating a secure string.
try
{
	$SecurePassword = ConvertTo-SecureString -String $MyPassword -AsPlainText -Force
	Write-Host "The password was successfully converted to a secure string."
} catch
{
	Write-Error "Failed to convert the password to a secure string."
	exit 1
}
