function Get-CsInstallerInfo {
<#
    .SYNOPSIS
        Search for info about Falcon Sensor Installers

    .PARAMETER FILTER
        The filter expression that should be used to limit the results

    .PARAMETER LIMIT
        The maximum records to return [default: 500]

    .PARAMETER OFFSET
        The offset to start retrieving records from [default: 0]

    .PARAMETER ALL
        Repeat request until all results are returned

    .PARAMETER ID
        Hashes of specific Falcon Sensor installers to return
#>
    [CmdletBinding(DefaultParameterSetName = 'combined')]
    [OutputType([psobject])]
    param(
        [Parameter(ParameterSetName = 'combined')]
        [string]
        $Filter,

        [Parameter(ParameterSetName = 'combined')]
        [ValidateRange(1,500)]
        [int]
        $Limit = 500,

        [Parameter(ParameterSetName = 'combined')]
        [int]
        $Offset = 0,

        [Parameter(ParameterSetName = 'combined')]
        [switch]
        $All,

        [Parameter(ParameterSetName = 'entities')]
        [array]
        $Id
    )
    begin{
        if ($Filter) { Add-Type -AssemblyName System.Web }
    }
    process{
        $Param = @{
            Uri = '/sensors/combined/installers/v1?limit=' + [string] $Limit + '&offset=' + [string] $Offset
            Method = 'get'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Filter' { $Param.Uri += '&filter=' + [System.Web.HTTPUtility]::UrlEncode($Filter) }
            'Query' { $Param.Uri += '&q=' + $Query }
            'Id' { 
                $Param['Uri'] = '/sensors/entities/installers/v1?ids='
            }
            'Verbose' { $Param['Verbose'] = $true }
            'Debug' { $Param['Debug'] = $true }
        }
        if ($Id) {
            Split-CsArray -Activity $MyInvocation.MyCommand.Name -Param $Param -Id $Id
        }
        elseif ($All) {
            Join-CsResult -Activity $MyInvocation.MyCommand.Name -Param $Param
        }
        else {
            Invoke-CsAPI @Param
        }
    }
}