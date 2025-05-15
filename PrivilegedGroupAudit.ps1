# Define target privileged groups
$privGroups = @(
   "Domain Admins",
   "Enterprise Admins",
   "Administrators",
   "Schema Admins",
   "Account Operators",
   "Server Operators",
   "Backup Operators",
   "Print Operators"
   # "Group Policy Creator Owners"  # Optional: include if it exists in your AD
)
# Initialize the results array properly
$results = @()
# Recursive function to walk group membership
function Expand-Group {
   param (
       [string]$GroupName,
       [string]$PathSoFar
   )
   try {
       $members = Get-ADGroupMember -Identity $GroupName -ErrorAction Stop
   } catch {
       Write-Warning ("Failed to query {0}: {1}" -f $GroupName, $_)
       return
   }
   foreach ($member in $members) {
       $newPath = "$PathSoFar -> $($member.SamAccountName)"
       if ($member.objectClass -eq 'user') {
           $user = Get-ADUser -Identity $member.SamAccountName -Properties Enabled, LastLogonDate
           # Append to the pre-initialized array
           $script:results += [PSCustomObject]@{
               UserName                = $user.Name
               SamAccountName          = $user.SamAccountName
               Enabled                 = $user.Enabled
               LastLogonDate           = $user.LastLogonDate
               SourceGroup             = $GroupName
               MembershipPath          = $newPath
               IsDisabledAndPrivileged = ($user.Enabled -eq $false)
           }
       }
       elseif ($member.objectClass -eq 'group') {
           Expand-Group -GroupName $member.SamAccountName -PathSoFar $newPath
       }
   }
}
# Begin processing each privileged group
foreach ($privGroup in $privGroups) {
   Write-Host "Processing: $privGroup" -ForegroundColor Cyan
   Expand-Group -GroupName $privGroup -PathSoFar $privGroup
   Write-Host ""
}
# Output results to console
$results | Sort-Object SamAccountName | Format-Table -AutoSize
# Export to CSV on Desktop
$csvPath = "$env:USERPROFILE\Desktop\PrivilegedGroupAudit.csv"
$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
Write-Host "`nAudit complete. Results exported to $csvPath" -ForegroundColor Green
# Highlight disabled privileged accounts
$disabledAccounts = $results | Where-Object { $_.IsDisabledAndPrivileged -eq $true }
if ($disabledAccounts.Count -gt 0) {
   Write-Warning "WARNING: Disabled accounts found in privileged groups!"
   $disabledAccounts | Format-Table UserName, SamAccountName, LastLogonDate, SourceGroup, MembershipPath -AutoSize
} else {
   Write-Host "No disabled accounts found in privileged groups." -ForegroundColor Green
}