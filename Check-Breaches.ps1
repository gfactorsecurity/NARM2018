[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 function Check-HaveIBeenPwned ($email) {
    $uri = "https://haveibeenpwned.com/api/v2/breachedaccount/$email"
    $breaches = ConvertFrom-Json -InputObject (Invoke-WebRequest -Uri $uri) 
    foreach($breach in $breaches){
        Write-Output ("$($email+','+$breach.Title+','+$breach.BreachDate+','+$breach.Domain)")
    }
    Start-Sleep -Seconds 2 
}

Get-Mailbox |  % { $email = $_.PrimarySMTPAddress.ToString(); Check-HaveIBeenPwned($email) }
