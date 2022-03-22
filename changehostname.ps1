#region Get the MAC Address to set the computer name
#Get a list of Network Adapters that are Physical and connected to the PCI bus
$NICs = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object -FilterScript {$PSItem.PhysicalAdapter} | Where-Object { $PSItem.PNPDeviceID -like "PCI\*" }
# USB Ethernet adapters and the Surface Dock Ethernet adapter have a VendorID starting with USB.
# Therefore, using PCI should eliminate all Ethernet adapters that are not connected using a PCI connection
    
If ($NICs | Where-Object { $PSItem.NetConnectionID -eq "Ethernet" })
{   #If there is a Physical ethernet adapter, use that MAC address
    $MACAddress = @($NICs | Where-Object { $PSItem.NetConnectionID -like "Ethernet" })[0].MACAddress.Replace(':','')
}
ElseIf ($NICs | Where-Object { $PSItem.NetConnectionID -eq "Wi-Fi" })
{   #Otherwise, use the Wi-Fi MAC address if it exists
    $MACAddress = @($NICs | Where-Object { $PSItem.NetConnectionID -like "Wi-Fi" })[0].MACAddress.Replace(':','')
}
#endregion

$ComputerName = "MS$MACAddress"