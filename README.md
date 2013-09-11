Disable-Inactive-AD-Users
=========================

Disable all Active Directory users in a domain or a specified OU that have not logged on within X days and save the list to a csv file

### Installation

1. Clone this script from github or copy the files manually to your prefered directory.

2. Edit the ps1 file and replace the following values:

##### Log folder
- $LogFolder = "c:\scripts\"

##### Search base - Domain or Organizational Unit to search - use Distinguished Name (DN)
- $OU = "OU=MyUsers,DC=domain,DC=com"

by [RaveMaker][RaveMaker].
[RaveMaker]: http://ravemaker.net
