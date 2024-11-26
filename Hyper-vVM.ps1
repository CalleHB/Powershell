
<#
A short powershell script to make vm in Hyper-V
#>

# Define the VM name
$VM = Read-Host "Enter VM name"

# Define the switch name
$Switch = "LAN"

# Define the install media path
$InstallMedia = "C:\Saker\ubuntu-24.04-live-server-amd64.iso"

# Define the VM path
$VMPath = "\\CARL-MUSIC02\VMfolder\VHD"

# Define the VHD path
$VHD = "$VMPath\$VM.vhdx"

# Creating a new VM
New-VM -Name $VM -MemoryStartupBytes 4GB -Path $VMPath -NewVHDPath $VHD -NewVHDSizeBytes 40GB -Generation 1 -SwitchName $Switch
# Adding the virtual DVD drive and mounting the ISO file
Add-VMDvdDrive -VMName $VM -Path $InstallMedia
# Configuring the boot order to DVD, VHD, and Network
Set-VMFirmware -VMName $VM -BootOrder $(Get-VMDvdDrive -VMName $VM), $(Get-VMHardDiskDrive -VMName $VM), $(Get-VMNetworkAdapter -VMName $VM)