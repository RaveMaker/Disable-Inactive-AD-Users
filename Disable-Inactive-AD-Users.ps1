# Disable Active Directory users in a domain or an OU that have not logged on within X days.
# Save the list of disabled users to a Log file
#
# by RaveMaker - http://ravemaker.net

# Log file
$LogFolder = "C:\Disable-Inactive-AD-Users\"
$LogFile = $LogFolder + "Disable-Inactive-AD-Users"

# Search base - Domain or Organizational Unit to search - use Distinguished Name (DN)
$OU = "OU=MyUsers,DC=domain,DC=com"

# Number of Days a user has not logged on.   
# Also make sure the user has not been created within this time.
$UnusedDays = 365

# Get current date in a sortable format
$CurrentDate = Get-Date -format yyyy_MM_dd

# Get the Current Date minus UnusedDays
$DateLastActive = (Get-Date) - (new-timespan -days $UnusedDays)
echo $DateLastActive

# Convert Current Date to Time Stamp
$DateLastActiveTimeStamp = (Get-Date $DateLastActive).ToFileTime()
echo $DateLastActiveTimeStamp

# Add current date to log file name
$LogFile = $LogFile + "-" + $CurrentDate + ".csv"

# Never used date
$NeverUsed = (01/01/1601)

# Get Users and output to log file
Get-ADUser -Filter { (((lastLogonTimestamp -lt $DateLastActiveTimeStamp) -or (-not (lastLogonTimestamp -like "*"))) -and (whenCreated -lt $DateLastActive)) } -SearchBase "$OU" -Prop DistinguishedName,whenCreated,lastLogonTimestamp,lastLogonTimestamp | Select DistinguishedName,whenCreated,lastLogonTimestamp,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}} | Out-File $LogFile

# Disable users after creating the list
Get-ADUser -Filter { (((lastLogonTimestamp -lt $DateLastActiveTimeStamp) -or (-not (lastLogonTimestamp -like "*"))) -and (whenCreated -lt $DateLastActive)) } -SearchBase "$OU" -Prop lastLogonTimestamp,whenCreated | Disable-ADAccount
