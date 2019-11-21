<!-- #include "./common/header.md" -->

# Get-VSTeamTestRun

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamTestRun.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamTestRun.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamTestRun -Ids 47,48
```

This command gets test runs with IDs 47 and 48 by using the IDs parameter.

## PARAMETERS

### -Id

The id of the test run.

```yaml
Type: Int32
Parameter Sets: ByID
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Ids

The id of the work item.

```yaml
Type: Int32[]
Parameter Sets: List
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -ErrorPolicy

The flag to control error policy in a bulk get work items request.  The acceptable values for this parameter are:

- Fail
- Omit

```yaml
Type: String
Parameter Sets: List
Required: True
Default value: Fail
```

### -Fields

Comma-separated list of requested fields.

```yaml
Type: String[]
```

### -IncludeDetails

Default value is true. It includes details like run statistics,release,build,Test environment,Post process state and more.

```yaml
Type: Boolean
```

## INPUTS

### System.String

ProjectName

## OUTPUTS

## NOTES

If you do not set the default project by calling Set-VSTeamDefaultProject before calling Get-VSTeamTestRun you will have to type in the names.

## RELATED LINKS
