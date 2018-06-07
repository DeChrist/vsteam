Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\workitems.psm1 -Force

InModuleScope workitems {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'workitems' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Add-WorkItem' {
         $obj = @{
            id  = 47
            rev = 1
            url = "https://test.visualstudio.com/_apis/wit/workItems/47"
         }

         Mock Invoke-RestMethod {
            return $obj
         }

         It 'Without Default Project should add work item' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json-patch+json' -and
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitems/`$Task?api-version=$($VSTeamVersionTable.Core)"
            }
         }

         It 'With Default Project should add work item' {
            $Global:PSDefaultParameterValues["*:projectName"] = 'test'            
            Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json-patch+json' -and
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitems/`$Task?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }
   }
}