function New-AppConfig {
    # creates a new Application Configuration file
    param(
        [parameter(mandatory = $true)]
        [string]
        $Path,

        [parameter(mandatory = $true)]
        [string]
        $projectName,

        [parameter(mandatory = $false)]
        [object]
        $Options = (New-AppConfigOptions),

        [parameter(mandatory = $false)]
        [switch]
        $Force = $false
    )

    $configfile = Join-Path $Path config.xml
    if ( (Test-Path $configfile) ) {
        if ( -not $Force ) {
            Write-Warning "Configuration file already exists, use -Force to overwrite"
            return
        }
    }

    $HttpEnabled = if ( $Options.HttpEnabled ) { "1" } else { "0" }
    $HttpsEnabled = if ( $Options.HttpsEnabled ) { "1" } else { "0" }

    $raw = 
@"
        <?xml version="1.0" encoding="iso-8859-1"?>
        <config>
            <server>
                <property name="project" value="$projectName" />
                <property name="http-server-enabled" value="$HttpEnabled" />
                <property name="port" value="$($Options.HttpPort)" />
                <property name="secure-server-enabled" value="$HttpsEnabled" />
                <property name="secure-server-port" value="$($Options.HttpsPort)" />
            </server>
        </config>

"@

        $raw | Out-File $configfile -Encoding ascii -Force
}

function New-AppConfigOptions
{# returns a default set of options for an App configuration
  $result = New-AppCfgObject ConfigOptions -h @{
      HttpPort        = 5000;
      HttpsPort       = 448;
      HttpEnabled     = $true;
      HttpsEnabled    = $true;
      DataName        = "testdb";
  }
  return $result
}


function New-AppCfgObject {
    [CmdletBinding(DefaultParameterSetName = "hash")]
    param(
        [parameter(mandatory = $true, Position = 0)]
        [string]
        $TypeName,

        [parameter(mandatory = $false)]
        [Alias("h")]
        [hashtable]
        $HashTable = $null,

        [parameter(mandatory = $false)]
        [Alias("m")]
        [string[]]
        $MemberName = $null
    )
    $obj = New-Object PSObject

    if ( $HashTable ) {
        $obj = New-Object PSObject -Property $HashTable
        $dp = [string[]]@()
        $HashTable.GetEnumerator() | foreach { $dp += [string]$_.key }
        $dp = [string[]]$dp
    }
    elseif ( $MemberName ) {
        $obj = New-Object PSObject
        foreach ( $name in $MemberName ) {
            $obj | Add-Member NoteProperty $name $null
        }
        $dp = $MemberName
    }

    $dpps = New-Object System.Management.Automation.PSPropertySet "DefaultDisplayPropertySet", $dp
    $psm = [System.Management.Automation.PSMemberInfo[]]@($dpps)
    $obj | Add-Member MemberSet PSStandardMembers $psm

    $obj.PSObject.TypeNames.Insert( 0, "AppCfg.$TypeName" )
    return $obj
}

## Sample:
## New-AppConfig -Path . -projectName abc -Force
