# Set your vCenter server
$vcenter = (Get-ChildItem Env:VCSERVER).value

# Define the session URL for vCenter
$vcenter_url = "https://$($vcenter)/rest/com/vmware/cis/session"

# Set your vCenter user from the VCUSER environment variable
$User = (Get-ChildItem Env:VCUSER).value

# Set your vCenter password from teh VCPASS environment variable
$PWord = ConvertTo-SecureString -String (Get-ChildItem Env:VCPASS).value -AsPlainText -Force

# Set the credential object 
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

# Create HTTP header to authenticate to vCenter
$vcauth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Credential.UserName+':'+$Credential.GetNetworkCredential().Password))
$head = @{
  'Authorization' = "Basic $vcauth"
}

# Get authentication token as JSON object from vCenter 
$tokenresult = Invoke-WebRequest -Uri $vcenter_url -Method Post -Headers $head -SkipCertificateCheck

# Get the value from the token JSON result
$token = (ConvertFrom-Json $tokenresult.Content).value

# Set the session header value using the new token
$session = @{'vmware-api-session-id' = $token}

# Uncomment these two Write-Host values to write the results to console
# Write-host $tokenresult	
# Write-host $token

# Set the VM URL
$vcenter_vm_url = "https://$($vcenter)/rest/vcenter/vm"

# Get list of VMs as a JSON result
$vmresults = Invoke-WebRequest -Uri $vcenter_vm_url -SkipCertificateCheck -Headers $session

# Output JSON result to console 
$vmresults
