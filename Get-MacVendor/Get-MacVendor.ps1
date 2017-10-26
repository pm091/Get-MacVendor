function Get-MacVendor {
<#
.Synopsis
This function resolves macadresses and returns the manufacturer
.Description
This function queries macvendors api with supplied mac adderess and will return manufacturer information if a match is found
.Parameter MacAddress 
This Parameter supports multiple MacAddresses to be supplied
.Example
Get-MacVendor 
.Example
Get-MacVendor -MacAddress 00:00:00:00:00:00
.Example
Get-NetAdapter | select MacAddress -ExpandProperty MacAddress | Get-MacVendor
.Example
Get-DhcpServerv4Lease -ComputerName $ComputerName -ScopeId $ScopeId | Select ClientId -ExpandProperty ClientId | Get-MacVendor
#>
		[CmdletBinding()]
		param(
		[Parameter (Mandatory=$true,
                    ValueFromPipeline=$true)]
		[ValidatePattern("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")]
		[string[]]$MacAddress
		)
        process{
		foreach($Mac in $MacAddress){
		try{
				Write-Verbose 'Sending Request to http://api.macvendors.com'
				Invoke-RestMethod -Method Get -Uri http://api.macvendors.com/$Mac -ErrorAction SilentlyContinue | Foreach-object {

					[pscustomobject]@{
						Vendor = $_
						MacAddress = $Mac
					}
				}
			}
		catch{
				Write-Warning -Message "$Mac, $_"
			}
        }
   }
         end{}
    
}
