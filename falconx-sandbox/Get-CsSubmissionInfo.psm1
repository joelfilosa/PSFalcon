function Get-CsSubmissionInfo {
<#
    .SYNOPSIS
        Check the status of a sandbox analysis. Time required for analysis varies but
        is usually less than 15 minutes

    .PARAMETER ID
        Id of a submitted malware sample
#>
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory = $true)]
        [array]
        $Id
    )
    process{
        $Param = @{
            Uri =  '/falconx/entities/submissions/v1?ids='
            Method = 'get'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Verbose' { $Param['Verbose'] = $true }
            'Debug' { $Param['Debug'] = $true }
        }
        Split-CsArray -Activity $MyInvocation.MyCommand.Name -Param $Param -Id $Id
    }
}
