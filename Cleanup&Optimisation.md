This PowerShell script includes several operations to clean up and optimize your Computer. 

Windows Temporary Files - Cleans up temp folders and prefetch data
Recycle Bin - Empties the recycle bin
Browser Caches - Clears caches for Chrome, Edge, and Firefox
Windows Update Cache - Removes downloaded update files
Thumbnail Cache - Clears explorer thumbnail cache
Disk Cleanup - Runs the built-in Windows disk cleanup utility
Service Optimization - Disables unnecessary services like Superfetch
System File Repair - Runs DISM and SFC to repair system files
Event Log Clearing - Clears Windows event logs

The script also:

Creates a detailed log file on your desktop
Requires administrative privileges
Provides colored output for better readability
Shows disk space information after cleanup

To use this script: (https://github.com/vluv89/Powershell_Automations/blob/9d6dd4148a6c805dd5ee29da8fbf53859c3cb0bc/Cleanup.ps1)

Download it as a .ps1 file (e.g., Cleanup.ps1)
Right-click and select "Run with PowerShell as administrator"
Allow it to complete all operations
Consider restarting your computer afterward for best results

Note that some operations may take time to complete, especially the DISM and SFC scans. The script is designed to be safe, but as with any system maintenance script, it's always good practice to have backups of important data before running it.
