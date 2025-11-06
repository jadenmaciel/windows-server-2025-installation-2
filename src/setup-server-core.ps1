# Windows Server 2025 Core Edition Setup Script
# Author: Jaden Maciel-Shapiro
# Date: 2024-08-27
# Description: Automates post-installation configuration for Windows Server 2025 Server Core

# Requires Administrator privileges
#Requires -RunAsAdministrator

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Windows Server 2025 Core Setup Script" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration variables
$AdminUsername = "administrator"
$AdminPassword = "!QAZ1qaz!QAZ1qaz"
$LocalUsername = "jsmith"
$LocalPassword = "#EDC3edc#EDC3edc"
$GuestAdditionsDrive = "D:"

# Function to create local user account using net.exe (compatible with Server Core)
function New-LocalUserAccountCore {
    param(
        [string]$Username,
        [string]$Password,
        [string]$Description = "Local User Account"
    )

    try {
        # Check if user already exists
        $UserExists = net user $Username 2>&1 | Select-String "The user name could not be found"

        if (-not $UserExists) {
            Write-Host "[INFO] User '$Username' already exists. Skipping creation." -ForegroundColor Yellow
            return
        }

        # Create user account
        net user $Username $Password /add /comment:"$Description" /passwordchg:yes 2>&1 | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "[SUCCESS] Created local user account: $Username" -ForegroundColor Green
        }
        else {
            Write-Host "[ERROR] Failed to create user account '$Username'" -ForegroundColor Red
            return
        }

        # Add user to Users group (can be customized)
        net localgroup "Users" $Username /add 2>&1 | Out-Null
        Write-Host "[SUCCESS] Added '$Username' to Users group" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to create user account '$Username': $_" -ForegroundColor Red
    }
}

# Function to install VirtualBox Guest Additions (silent mode)
function Install-GuestAdditionsCore {
    param([string]$DriveLetter)

    $GuestAdditionsPath = Join-Path $DriveLetter "VBoxWindowsAdditions.exe"

    if (Test-Path $GuestAdditionsPath) {
        Write-Host "[INFO] Found Guest Additions installer at: $GuestAdditionsPath" -ForegroundColor Cyan
        Write-Host "[INFO] Running Guest Additions installer in silent mode..." -ForegroundColor Cyan

        try {
            # Silent installation with automatic reboot
            $Process = Start-Process -FilePath $GuestAdditionsPath -ArgumentList "/S" -Wait -PassThru -NoNewWindow

            if ($Process.ExitCode -eq 0) {
                Write-Host "[SUCCESS] Guest Additions installation completed." -ForegroundColor Green
                Write-Host "[NOTE] System reboot recommended for changes to take effect." -ForegroundColor Yellow
            }
            else {
                Write-Host "[WARNING] Guest Additions installer exited with code: $($Process.ExitCode)" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "[ERROR] Failed to install Guest Additions: $_" -ForegroundColor Red
            Write-Host "[INFO] Please install Guest Additions manually using:" -ForegroundColor Yellow
            Write-Host "      $GuestAdditionsPath /S" -ForegroundColor White
        }
    }
    else {
        Write-Host "[WARNING] Guest Additions installer not found at: $GuestAdditionsPath" -ForegroundColor Yellow
        Write-Host "[INFO] Please ensure the VirtualBox Guest Additions ISO is mounted." -ForegroundColor Yellow
        Write-Host "[INFO] You can mount it via VirtualBox: Devices > Insert Guest Additions CD image" -ForegroundColor Yellow
    }
}

# Function to configure network discovery (Server Core compatible)
function Enable-NetworkDiscoveryCore {
    try {
        Write-Host "[INFO] Configuring Network Discovery via netsh..." -ForegroundColor Cyan

        # Enable network discovery firewall rules using netsh
        netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes | Out-Null

        Write-Host "[SUCCESS] Network Discovery enabled." -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to enable Network Discovery: $_" -ForegroundColor Red
        Write-Host "[INFO] You can configure this manually using sconfig or netsh commands." -ForegroundColor Yellow
    }
}

# Function to set computer name (optional)
function Set-ComputerNameCore {
    param([string]$NewName)

    if ($NewName) {
        try {
            $CurrentName = $env:COMPUTERNAME
            if ($CurrentName -ne $NewName) {
                Write-Host "[INFO] Setting computer name to: $NewName" -ForegroundColor Cyan
                Rename-Computer -NewName $NewName -Force
                Write-Host "[SUCCESS] Computer name will be changed to '$NewName' after reboot." -ForegroundColor Green
            }
            else {
                Write-Host "[INFO] Computer name is already set to: $NewName" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "[ERROR] Failed to set computer name: $_" -ForegroundColor Red
        }
    }
}

# Function to display system information
function Show-SystemInfo {
    Write-Host ""
    Write-Host "System Information:" -ForegroundColor Cyan
    Write-Host "===================" -ForegroundColor Cyan
    Write-Host "Computer Name: $env:COMPUTERNAME" -ForegroundColor White
    Write-Host "OS Version: $((Get-CimInstance Win32_OperatingSystem).Caption)" -ForegroundColor White
    Write-Host "OS Build: $((Get-CimInstance Win32_OperatingSystem).BuildNumber)" -ForegroundColor White
    Write-Host "Architecture: $((Get-CimInstance Win32_OperatingSystem).OSArchitecture)" -ForegroundColor White
    Write-Host "Total RAM: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)) GB" -ForegroundColor White
}

# Main execution
Write-Host "[1/5] Creating local user account: $LocalUsername" -ForegroundColor Cyan
New-LocalUserAccountCore -Username $LocalUsername -Password $LocalPassword -Description "Local User Account"

Write-Host ""
Write-Host "[2/5] Enabling Network Discovery" -ForegroundColor Cyan
Enable-NetworkDiscoveryCore

Write-Host ""
Write-Host "[3/5] Installing VirtualBox Guest Additions" -ForegroundColor Cyan
Install-GuestAdditionsCore -DriveLetter $GuestAdditionsDrive

Write-Host ""
Write-Host "[4/5] Displaying system information" -ForegroundColor Cyan
Show-SystemInfo

Write-Host ""
Write-Host "[5/5] Listing available local users" -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan
net user | Select-String -Pattern "User accounts|^----|^\w" | ForEach-Object {
    Write-Host $_ -ForegroundColor White
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Setup script completed!" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Reboot the system if Guest Additions was installed: shutdown /r /t 0" -ForegroundColor White
Write-Host "2. Run 'sconfig' for additional Server Core configuration" -ForegroundColor White
Write-Host "3. Create VM snapshots for backup" -ForegroundColor White
Write-Host "4. Verify user accounts: net user" -ForegroundColor White
Write-Host ""
Write-Host "Useful Server Core commands:" -ForegroundColor Yellow
Write-Host "  - sconfig          : Server Configuration menu" -ForegroundColor White
Write-Host "  - net user         : List all users" -ForegroundColor White
Write-Host "  - shutdown /r /t 0 : Restart immediately" -ForegroundColor White

