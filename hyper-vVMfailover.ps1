<#
A PowerShell script to create VMs in Hyper-V with error handling and repeat option
#>

do {
    try {
        # Prompt for VM name
        $VM = Read-Host "Enter VM name"

        # Prompt for VM switch name
        $Switch = Read-Host "Enter switch name (default is 'YOUR SWITCH HERE!')" 
        if (-not $Switch) { $Switch = "YOUR SWITCH HERE!" }

        # Define install media path
        $InstallMedia = Read-Host "Enter path to ISO file (default: 'default path to iso file')" 
        if (-not $InstallMedia) { $InstallMedia = "YOUR ISO PATH HERE" }

        # Define VM path
        $VMPath = Read-Host "Enter VM folder path (default: 'VM FOLDER PATH')" 
        if (-not $VMPath) { $VMPath = "VM FOLDER PATH HERE!" }

        # Define VHD path
        $VHD = "$VMPath\$VM.vhdx"

        # Create a new VM
        Write-Host "Creating VM: $VM..."
        New-VM -Name $VM -MemoryStartupBytes 4GB -Path $VMPath -NewVHDPath $VHD -NewVHDSizeBytes 40GB -Generation 1 -SwitchName $Switch

        # Add virtual DVD drive and mount the ISO file
        Write-Host "Adding ISO to VM: $VM..."
        Add-VMDvdDrive -VMName $VM -Path $InstallMedia

        # Configure boot order to DVD, VHD, and Network
        Write-Host "Setting boot order for VM: $VM..."
        Set-VMFirmware -VMName $VM -BootOrder $(Get-VMDvdDrive -VMName $VM), $(Get-VMHardDiskDrive -VMName $VM), $(Get-VMNetworkAdapter -VMName $VM)

        # Start the VM
        Start-VM -VMName $VM
        Write-Host "VM '$VM' created and started successfully!" -ForegroundColor Green

    } catch {
        Write-Host "An error occurred: $_" -ForegroundColor Red
    }

    # Ask if the user wants to create another VM
    $continue = Read-Host "Do you want to create another VM? (Yes/No)"
} while ($continue -eq "Yes")