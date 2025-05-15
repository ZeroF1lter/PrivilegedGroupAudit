![PriGroupAuditScriptLogo20](https://github.com/user-attachments/assets/bc11ba54-a4fd-4c14-a43b-9aac6b4a775a)

The purpose of the PrivilegedGroupAudit script is to give you clear, fast visibility into who has privileged access in Active Directory, even when that access is buried inside nested groups or assigned to disabled/stale accounts.

The idea is to:
Enumerate Built-in Privileged Groups Like:

Domain Admins

Enterprise Admins

Administrators

Backup Operators

Account Operators

**And any others you want to add

-Recursively Follow Nested Memberships
It doesn’t just check who's directly in those groups.
It walks through group nesting (e.g., GroupA → GroupB → user) so no hidden access goes unnoticed.

-Find Dormant or Disabled Accounts
Flags disabled users who still sit in privileged groups (a real risk).
Grabs last logon date so you can spot accounts that haven't been used in months.

-Export a Clean, Sortable Report
Outputs everything to a .csv you can review or drop into Excel.

Includes: UserName, SamAccountName, Enabled, LastLogonDate, SourceGroup, MembershipPath, IsDisabledAndPrivileged

Example Output:
![Screenshot 2025-05-15 152554](https://github.com/user-attachments/assets/a6975cd8-278e-4230-acd4-932caa8d5c5b)

See that first line?
An old disabled service account (svc_legacy) is still nested inside a chain of groups that rolls all the way up to Domain Admins.

Nobody's logged into it in quote some time, but if an attacker compromised that account, they’d have full control of the domain.

This is the kind of stuff that hides in plain sight, and what this script is built to help uncover.








