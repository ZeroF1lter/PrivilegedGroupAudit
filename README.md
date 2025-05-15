![PrivilegedGroupAudit](./PrivilegedGroupAudit-Banner.png)

This lightweight PowerShell script maps out membership in built-in privileged AD groups, including all the nested stuff and flags any disabled or inactive accounts still holding elevated access. It pulls last logon timestamps and kicks out a clean .csv for easy auditing.

Built to be fast, clear, and easy to customize. Perfect for regular privilege audits or tightening things up. It works with delegated read access, so no need to be a Domain Admin to run it.