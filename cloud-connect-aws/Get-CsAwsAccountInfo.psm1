function Get-CsAwsAccountInfo {
<#
    .SYNOPSIS
        Retrieve a set of AWS Accounts by specifying their IDs

    .PARAMETER FILTER
        The filter expression that should be used to limit the results

    .PARAMETER LIMIT
        The maximum records to return [default: 500]

    .PARAMETER OFFSET
        The offset to start retrieving records from [default: 0]

    .PARAMETER ALL
        Repeat request until all results are returned

    .PARAMETER ID
        IDs of specific accounts to return
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

        [Parameter(ParameterSetName = 'entities', Mandatory = $true)]
        [array]
        $Id
    )
    process{
        $Param = @{
            Uri = '/cloud-connect-aws/combined/accounts/v1?limit=' + [string] $Limit +
            '&offset=' + [string] $Offset
            Method = 'get'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Filter' { $Param.Uri += '&filter=' + $Filter }
            'Id' { $Param.Uri = '/cloud-connect-aws/entities/accounts/v1?ids=' }
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