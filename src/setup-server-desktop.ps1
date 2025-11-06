# Windows Server 2025 Desktop Edition Setup Script
# Author: Jaden Maciel-Shapiro
# Date: 2024-08-27
# Description: Automates post-installation configuration for Windows Server 2025 Desktop Experience

# Requires Administrator privileges
#Requires -RunAsAdministrator

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Windows Server 2025 Desktop Setup Script" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration variables
$AdminUsername = "administrator"
$AdminPassword = "!QAZ1qaz!QAZ1qaz"
$LocalUsername = "jsmith"
$LocalPassword = "#EDC3edc#EDC3edc"
$GuestAdditionsDrive = "D:"

# Function to create local user account
function New-LocalUserAccount {
    param(
        [string]$Username,
        [string]$Password,
        [string]$Description = "Local User Account"
    )

    try {
        $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

        # Check if user already exists
        $UserExists = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

        if ($UserExists) {
            Write-Host "[INFO] User '$Username' already exists. Skipping creation." -ForegroundColor Yellow
            return
        }

        New-LocalUser -Name $Username -Password $SecurePassword -Description $Description -UserMayNotChangePassword:$false -PasswordNeverExpires:$false
        Write-Host "[SUCCESS] Created local user account: $Username" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to create user account '$Username': $_" -ForegroundColor Red
    }
}

# Function to install VirtualBox Guest Additions
function Install-GuestAdditions {
    param([string]$DriveLetter)

    $GuestAdditionsPath = Join-Path $DriveLetter "VBoxWindowsAdditions.exe"

    if (Test-Path $GuestAdditionsPath) {
        Write-Host "[INFO] Found Guest Additions installer at: $GuestAdditionsPath" -ForegroundColor Cyan
        Write-Host "[INFO] Launching Guest Additions installer..." -ForegroundColor Cyan

        try {
            Start-Process -FilePath $GuestAdditionsPath -ArgumentList "/S" -Wait -NoNewWindow
            Write-Host "[SUCCESS] Guest Additions installation completed." -ForegroundColor Green
            Write-Host "[NOTE] A system reboot may be required for changes to take effect." -ForegroundColor Yellow
        }
        catch {
            Write-Host "[ERROR] Failed to install Guest Additions: $_" -ForegroundColor Red
            Write-Host "[INFO] Please install Guest Additions manually from: $GuestAdditionsPath" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "[WARNING] Guest Additions installer not found at: $GuestAdditionsPath" -ForegroundColor Yellow
        Write-Host "[INFO] Please ensure the VirtualBox Guest Additions ISO is mounted." -ForegroundColor Yellow
    }
}

# Function to configure network discovery
function Enable-NetworkDiscovery {
    try {
        Write-Host "[INFO] Enabling Network Discovery..." -ForegroundColor Cyan
        Set-NetFirewallRule -DisplayGroup "Network Discovery" -Enabled True -Profile Private, Domain
        Write-Host "[SUCCESS] Network Discovery enabled." -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to enable Network Discovery: $_" -ForegroundColor Red
    }
}

# Main execution
Write-Host "[1/4] Creating local user account: $LocalUsername" -ForegroundColor Cyan
New-LocalUserAccount -Username $LocalUsername -Password $LocalPassword -Description "Local User Account"

Write-Host ""
Write-Host "[2/4] Enabling Network Discovery" -ForegroundColor Cyan
Enable-NetworkDiscovery

Write-Host ""
Write-Host "[3/4] Installing VirtualBox Guest Additions" -ForegroundColor Cyan
Install-GuestAdditions -DriveLetter $GuestAdditionsDrive

Write-Host ""
Write-Host "[4/4] Displaying system information" -ForegroundColor Cyan
Write-Host "Computer Name: $env:COMPUTERNAME" -ForegroundColor White
Write-Host "OS Version: $((Get-CimInstance Win32_OperatingSystem).Caption)" -ForegroundColor White
Write-Host "OS Build: $((Get-CimInstance Win32_OperatingSystem).BuildNumber)" -ForegroundColor White

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Setup script completed!" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Verify user account creation in Server Manager" -ForegroundColor White
Write-Host "2. Reboot the system if Guest Additions was installed" -ForegroundColor White
Write-Host "3. Create VM snapshots for backup" -ForegroundColor White

