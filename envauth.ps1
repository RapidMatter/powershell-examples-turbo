
$vcenter_url = 'https://vcenter.demo.turbonomic.com/rest/com/vmware/cis/session'

$User = (Get-ChildItem Env:VCUSER).value
$PWord = ConvertTo-SecureString -String (Get-ChildItem Env:VCPASS).value -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

$vcauth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Credential.UserName+':'+$Credential.GetNetworkCredential().Password))
$head = @{
  'Authorization' = "Basic $vcauth"
}

$tokenresult = Invoke-WebRequest -Uri $vcenter_url -Method Post -Headers $head -SkipCertificateCheck
$token = (ConvertFrom-Json $tokenresult.Content).value
$session = @{'vmware-api-session-id' = $token}

Write-host $tokenresult	
Write-host $token

$session = @{'vmware-api-session-id' = $token}

$vmresults = Invoke-WebRequest -Uri https://vcenter.demo.turbonomic.com/rest/vcenter/vm -SkipCertificateCheck -Headers $session

$vmresults