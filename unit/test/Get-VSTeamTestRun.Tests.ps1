Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'
   [VSTeamVersions]::Release = '1.0-unittest'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         environments = [PSCustomObject]@{}
         _links       = [PSCustomObject]@{
            self = [PSCustomObject]@{}
            web  = [PSCustomObject]@{}
         }
      }
   }

   $singleResult = [PSCustomObject]@{
      environments = [PSCustomObject]@{}
      variables    = [PSCustomObject]@{
         BrowserToUse = [PSCustomObject]@{
            value = "phantomjs"
         }
      }
      _links       = [PSCustomObject]@{
         self = [PSCustomObject]@{}
         web  = [PSCustomObject]@{}
      }
   }

   Describe 'TestRuns' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamRelease by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $singleResult
         }

         It 'should return release as Object' {
            $r = Get-VSTeamRelease -ProjectName project -Id 15

            $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'Team.TestRun'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }

      Context 'Get-VSTeamRelease by ID -JSON' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $singleResult
         }

         It 'should return release as JSON' {
            $r = Get-VSTeamRelease -ProjectName project -Id 15 -JSON

            $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.String'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }
   }
}