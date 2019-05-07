function Get-MacVendor {
    <#
.Synopsis
Resolve MacAddresses To Vendors
.Description
This Function Queries The MacVendors API With Supplied MacAdderess And Returns Manufacturer Information If A Match Is Found
.Parameter MacAddress 
MacAddress To Be Resolved
.Example
Get-MacVendor 
.Example
Get-MacVendor -MacAddress 00:00:00:00:00:00
.Example
Warning ! ! This may error due to api limits
Get-DhcpServerv4Lease -ComputerName $ComputerName -ScopeId $ScopeId | Select -ExpandProperty ClientId | Foreach-Object {Get-MacVendor -MacAddress $_; sleep 1}

Get-NetAdapter | select -ExpandProperty MacAddress | Foreach-Object {Get-MacVendor -MacAddress $_; sleep 1}
#>
    [CmdletBinding()]
    param(
        [Parameter (Mandatory = $true,
            ValueFromPipeline = $false)]
        [ValidatePattern("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")]
        [string[]]$MacAddress
    )
    begin {
        $CurrentMac = 0
    }
    process {	
        $CurrentMac++
        Write-Progress -Activity "Resoving MacAddress : $Mac" -Status "$CurrentMac of $($MacAddress.Count)" -PercentComplete (($CurrentMac / $MacAddress.Count) * 100)
        foreach ($Mac in $MacAddress) {
            try {
                Write-Verbose 'Sending Request to https://api.macvendors.com/'
                Invoke-RestMethod -Method Get -Uri https://api.macvendors.com/$Mac -ErrorAction SilentlyContinue | Foreach-object {
                    [pscustomobject]@{
                        Vendor     = $_
                        MacAddress = $Mac
                    }
                }
                Start-Sleep -Milliseconds 1000
            }
            catch {
                Write-Warning -Message "$Mac, $_"
            }
        }
    }
    end { }
    
}
