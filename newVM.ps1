# Prompt for VM name
$vmName = Read-Host "Enter the name for the new VM"

$isoPath = "C:\Users\Carl Häggbring\Skolmapp\IsoFiler\en-us_windows_server_2022_updated_aug_2023_x64_dvd_78639bda.iso"

# Ange autentiseringsuppgifter
$username = "Administrator"
$password = ConvertTo-SecureString "Test123" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

try {
    # Create the new VM
    New-VM -Name $vmName -Generation 2 -MemoryStartupBytes 5GB   -NewVHDPath "C:\Hyper-V\$vmName\$vmName.vhdx" -NewVHDSizeBytes 20GB -Path "C:\Hyper-V\$vmName" -SwitchName "Intel" 
    
    # Add DVD drive to the VM and set the ISO file
    Add-VMDvdDrive -VMName $vmName -Path $isoPath

    # Enable TPM for the VM
    Set-VMKeyProtector -VMName $vmName -NewLocalKeyProtector
    Enable-VMTPM -VMName $vmName

    # Set the boot order to boot from the DVD drive first
    $dvdDrive = Get-VMDvdDrive -VMName $vmName
    Set-VMFirmware -VMName $vmName -FirstBootDevice $dvdDrive

    # Start the VM
    Start-VM -Name $vmName
    # Connect to the VM
    Enter-PSSession -VMName $vmName -Credential $credential
}
catch {
    Write-Host "An error occurred: $_"
}
