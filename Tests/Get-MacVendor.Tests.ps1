$PSVersion = $PSVersionTable.PSVersion.Major
. $env:BHProjectPath\Get-MacVendor\Get-MacVendor.ps1

#Unit test example
Describe "Get-MacVendor PS$PSVersion Unit tests" {

   It 'Should Return Cisco' {
    $Output = Get-MacVendor 00:00:0C:00:00:00
    $Output -eq 'Cisco Systems, Inc'
   }

   It 'Should accept "-" seperators in macaddresses and Return Xerox (Valid Vendor)' {
    $Output = Get-MacVendor 00-00-00-00-00-00
    $Output -eq 'XEROX CORPORATION'
   }
}

