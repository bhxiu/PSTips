param(
  [parameter(mandatory=$true)]
  [string]
  $Path,
  
  [parameter(mandatory=$true)]
  [string]
  $Name
)

$exe = Join-Path $Path "MyService.exe"
if( -not (Test-Path -Path $exe) ){
  Write-Error "MyService instance not available in $Path"
  return
}

$params = "-install -name:$Name -path:$Path -silent"

if( (get-service "Sample Service $Name*") -eq $null ){
  $proc = [System.Diagnostics.Process]::Start( $exe, $params )
  $proc.WaitForExit()
  if( $proc.ExitCode -ne 0 ){
    Write-Warning "MyService instance registration returned an error: $($proc.ExitCode)"
    return
  }
} else {
  Write-Warning "RM instance named $Name is already installed"
}