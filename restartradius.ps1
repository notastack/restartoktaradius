 #the time between responses after which the script will restart the radius
 $timetillrestart = -5
 #make sure the script's own log is not over 501 lines.
 #If runned every 5 minutes during work days between 0800 and 1700, it means a log of 4 and a half day
	$numberoflines=Get-Content "C:\Scripts\restartradiuslog\log.txt"
$numberoflines.Count
if ( $numberoflines.Count -gt 500 )
{
    (Get-Content "C:\Scripts\restartradiuslog\log.txt" | Select-Object -Skip 1)  | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt
    #please do not use any other function than out-file in the line above or expect some weird glitchs
}
    $date = (Get-Date).AddMinutes($timetillrestart)
    #read last reponse in the radius log to check if it is still responding
    $Writetime = Get-ItemProperty "C:\Program Files (x86)\Okta\Okta RADIUS Agent\current\logs\okta_radius.log" | select lastwritetime | get-date
            switch ($_ -in $date , $Writetime)
                {
                    ($Writetime -le $date)
                        {
			#radius is reponding normally
                            $dateandtimestamp = Get-Date -DisplayHint DateTime
                            "$dateandtimestamp Normal" | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt -Append
                        }
                    ($Writetime -gt $date)
                        {
			#radius is not responding
                            Restart-Service -Name okta-radius
                            $dateandtimestamp = Get-Date -DisplayHint DateTime
                            "$dateandtimestamp Restart" | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt -Append
                        }
                    default
                        {
			#how did you even got here?
                            $dateandtimestamp = Get-Date -DisplayHint DateTime
                            "$dateandtimestamp ERROR" | Out-File -FilePath C:\Scripts\restartradiuslog\log.txt -Append
                        }
                }
