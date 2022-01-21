function New-CfgObject
{
  [CmdletBinding(DefaultParameterSetName="hash")]
  param(
    [parameter(mandatory=$true, Position=0)]
    [string]
    $TypeName,

    [parameter(mandatory=$false)]
    [Alias("h")]
    [hashtable]
    $HashTable = $null,

    [parameter(mandatory=$false)]
    [Alias("m")]
    [string[]]
    $MemberName = $null
    )
  $obj = New-Object PSObject

  if( $HashTable ){
    $obj = New-Object PSObject -Property $HashTable
    $dp = [string[]]@()
    $HashTable.GetEnumerator() | foreach { $dp += [string]$_.key }
    $dp = [string[]]$dp
  } elseif( $MemberName ){
    $obj = New-Object PSObject
    foreach( $name in $MemberName ){
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

function Get-LDAPServer
{
  param(
    [parameter(mandatory=$true)]
    [string]
    $Path
  )

  $url = Get-CfgItemProperty $Path "handler-settings/user-ldap-provider" "server"

  if( $null -eq $url ){
      Write-Verbose "Server property is not set in user provider settings"
      return $null
  }

  $port = ""

  $protocol = $url.Substring(0,$url.IndexOf("://"))
  $server = $url.Substring($url.IndexOf("://") + 3)
  $cIndex = $server.IndexOf(":")
  if($cIndex -ne -1){
    $server = $server.Substring(0, $cIndex)
    $port = $url.Substring($url.IndexOf("://") + $cIndex + 4)
  }

  $obj = New-AppCfgObject LDAPServerObj -h @{
    Protocol = $protocol;
    Server = $server;
    Port = $port;
    Url = $url;
  }

  return $obj
}
