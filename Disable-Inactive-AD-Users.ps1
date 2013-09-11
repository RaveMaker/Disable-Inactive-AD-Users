# Disable Active Directory users in a domain or an OU that have not logged on within X days.
# Save the list of disabled users to a Log file
#
# by RaveMaker - http://ravemaker.net

# Log file
$LogFolder = "c:\scripts\"
$LogFile = $LogFolder + "DisableInactiveADUsers"

# Search base - Domain or Organizational Unit to search - use Distinguished Name (DN)
$OU = "OU=MyUsers,DC=domain,DC=com"

# Number of Days a user has not logged on.   
$UnusedDays = 365

# Get current date in a sortable format
$CurrentDate = Get-Date -format yyyy_mm_dd

# Get the Current Date minus UnusedDays
$DateLastActive = (Get-Date) - (new-timespan -days $UnusedDays)

# Convert Current Date to Time Stamp
$DateLastActive = (Get-Date $DateLastActive).ToFileTime()

# Add current date to log file name
$LogFile = $LogFile + "-" + $CurrentDate + ".csv"

# Get Users and output to log file
Get-ADUser -Filter { lastLogonTimestamp -lt $DateLastActive } -SearchBase "$OU" -Prop DistinguishedName,lastLogonTimestamp | Select DistinguishedName,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}} | Out-File $LogFile

# Disable users after creating the list
Get-ADUser -Filter { lastLogonTimestamp -lt $DateLastActive } -SearchBase "$OU" | Disable-ADAccount
