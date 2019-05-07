$PSVersion = $PSVersionTable.PSVersion.Major
. $env:BHProjectPath\Get-MacVendor\Get-MacVendor.ps1



#Integration test example
Describe "Get-Macvendor PS$PSVersion Integrations tests" {

    Context 'Strict mode' { 

        Set-StrictMode -Version latest

        It 'should get valid data' {
            $Output = Get-MacVendor 00:00:0C:00:00:00
            $Output.GetType().name | Should be 'PSCustomObject'
            $Output.MacAddress -match "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$" | Should be $true
            $Output.Vendor -contains 'Cisco Systems, Inc'
        }
    }
}


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

