
<#
A short powershell script to make vm in Hyper-V
#>

# Define the VM name
$VM = Read-Host "Enter VM name"

# Define the switch name
$Switch = "SWITCH NAME IN HYPER-V"

# Define the install media path
$InstallMedia = "PATH TO ISO FILE"

# Define the VM path
$VMPath = "PATH FOR VM CREATION"

# Define the VHD path
$VHD = "$VMPath\$VM.vhdx"

# Creating a new VM
New-VM -Name $VM -MemoryStartupBytes 4GB -Path $VMPath -NewVHDPath $VHD -NewVHDSizeBytes 40GB -Generation 1 -SwitchName $Switch
# Adding the virtual DVD drive and mounting the ISO file
Add-VMDvdDrive -VMName $VM -Path $InstallMedia
# Configuring the boot order to DVD, VHD, and Network
Set-VMFirmware -VMName $VM -BootOrder $(Get-VMDvdDrive -VMName $VM), $(Get-VMHardDiskDrive -VMName $VM), $(Get-VMNetworkAdapter -VMName $VM)
