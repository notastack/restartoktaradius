       $timetillrestart = -5
	$numberoflines=Get-Content "C:\Scripts\restartradiuslog\log.txt"
$numberoflines.Count
if ( $numberoflines.Count -gt 500 )
{
    (Get-Content "C:\Scripts\restartradiuslog\log.txt" | Select-Object -Skip 1)  | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt
}
    $date = (Get-Date).AddMinutes($timetillrestart)
    $Writetime = Get-ItemProperty "C:\Program Files (x86)\Okta\Okta RADIUS Agent\current\logs\okta_radius.log" | select lastwritetime | get-date
            switch ($_ -in $date , $Writetime)
                {
                    ($Writetime -le $date)
                        {
                            $dateandtimestamp = Get-Date -DisplayHint DateTime
                            "$dateandtimestamp Normal" | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt -Append
                        }
                    ($Writetime -gt $date)
                        {
                            Restart-Service -Name okta-radius
                            $dateandtimestamp = Get-Date -DisplayHint DateTime
                            "$dateandtimestamp Restart" | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt -Append
                        }
                    default
                        {
                            $dateandtimestamp = Get-Date -DisplayHint DateTime
                            "$dateandtimestamp ERROR" | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt -Append
                        }
                }
