function Get-CsSensorMemberInfo {
<#
    .SYNOPSIS
        Search for details about members of a Sensor Update policy in your environment

    .PARAMETER ID
        The ID of the Sensor Update policy to search for members of

    .PARAMETER FILTER
        The filter expression that should be used to limit the results (when IDs are not provided)

    .PARAMETER LIMIT
        The maximum records to return [Default: 5000] (when IDs are not provided)

    .PARAMETER OFFSET
        The offset to start retrieving records from [Default: 0] (when IDs are not provided)
#>
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateLength(32,32)]
        [string]
        $Id,

        [string]
        $Filter,

        [ValidateRange(2,5000)]
        [int]
        $Limit = 5000,

        [int]
        $Offset = 0
    )
    process{
        $Param = @{
            Uri = '/policy/combined/sensor-update-members/v1?id=' + $Id + '&limit=' + [string] $Limit +
            '&offset=' + [string] $Offset
            Method = 'get'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Filter' { $Param.Uri += '&filter=' + $Filter }
            'Verbose' { $Param['Verbose'] = $true }
        }
        Invoke-FalconAPI @Param
    }
}