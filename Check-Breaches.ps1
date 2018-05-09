[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 function Check-HaveIBeenPwned ($email) {
    $uri = "https://haveibeenpwned.com/api/v2/breachedaccount/$email"
    try{
        Write-Output $email
        $breaches = ConvertFrom-Json -InputObject (Invoke-WebRequest -Uri $uri)
        foreach($breach in $breaches){
            Write-Output ("$($email+','+$breach.Title+','+$breach.Domain+','+$breach.BreachDate)") >> ./BreachedAccounts.csv
        }
    }catch{
        Write-Output $_.Exception
    }
}

Write-Output "Email,BreachTitle,Domain,Date" >> ./BreachedAccounts.csv
Get-Mailbox |  % { $email = $_.PrimarySMTPAddress.ToString(); Check-HaveIBeenPwned($email); Start-Sleep -Seconds 2 }
