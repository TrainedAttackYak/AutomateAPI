function Get-AutomateLocationExtraFields {
    <#
  .SYNOPSIS
      Get Extra Data Fields (EDFs) for computer.
  .DESCRIPTION
      Connects to the Automate API and returns EDFs for specified computer.
  .PARAMETER ClientId
      Returns all EDFs for the computer.
  .PARAMETER Title
      Filters the EDFs by specified EDF title.
  .PARAMETER ExtraFieldDefinitionId
      Filters the EDFs by specified EDF ID.
  .PARAMETER ValueOnly
      Retrieves only the value of the EDF. 
  .OUTPUTS
      EDF objects
  .NOTES
      Version:        1.0
      Author:         Stephen McGough
      Creation Date:  2021-12-09
      Purpose/Change: Initial function development
  .EXAMPLE
      Get-AutomateLocationExtraFields -Location 102
  .EXAMPLE
      Get-AutomateLocationExtraFields -Location 102 -Title 'PatchingSchedule' -ValueOnly $true
  #>
  [cmdletbinding(DefaultParameterSetName = 'Title')]
  param(
      [Parameter(Mandatory = $true, Position = 0)]
      [int32]
      $Location,

      [Parameter(Mandatory = $false, ParameterSetName = 'Title')]
      [string]
      $Title,

      [Parameter(Mandatory = $false, ParameterSetName = 'EdfId')]
      [int32]
      $ExtraFieldDefinitionId,

      [Parameter(Mandatory = $false)]
      [bool]
      $ValueOnly = $false
  )

  $Params = @{
      Endpoint = "locations/$Location/extrafields"
      Page = 1
  }
  $EDFs = Get-AutomateApiGeneric @Params

  #Conditions doesn't seem to be respected server side, thus why filtering locally.
  If ($PSBoundParameters.ContainsKey('Title')) {
      $EDFs = $EDFs | Where-Object { $_.Title -eq $Title }
  }

  If ($PSBoundParameters.ContainsKey('ExtraFieldDefinitionId')){
      $EDFs = $EDFs | Where-Object { $_.ExtraFieldDefinitionId -eq $ExtraFieldDefinitionId }
  }

  If ($PSBoundParameters.ContainsKey('ValueOnly')) {
      $EDFs = $EDFs.TextFieldSettings.Value
  }

  return $EDFs
}
