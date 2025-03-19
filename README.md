# **PowerShell Automations**  

## **Installing PowerShell on Different Platforms**  
PowerShell is available for **Windows, macOS, and Linux**, with installation methods varying by platform. Windows comes with **Windows PowerShell** pre-installed, but you may need to upgrade to a newer version. On **macOS** and **Linux**, PowerShell can be installed using package managers like **Homebrew (macOS)** or **apt/yum (Linux)**.  

## **Understanding Execution Policies**  
PowerShell includes security measures that restrict script execution by default. You can check your current policy with:  
```powershell
Get-ExecutionPolicy
```  
The possible execution policies include:  

- **Restricted** – Blocks all script execution (default setting).  
- **AllSigned** – Only allows scripts signed by a trusted developer.  
- **RemoteSigned** – Permits local scripts and signed remote scripts.  
- **Unrestricted** – Allows all scripts to run.  

To change the execution policy, use:  
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```  
PowerShell will prompt for confirmation, ensuring you understand the security implications.  

## **Installing and Managing PowerShell Modules**  
Modules extend PowerShell’s functionality by adding **cmdlets, functions, and scripts** for various platforms and tools. Commonly used modules include:  

- **Active Directory**  
- **Microsoft Exchange Server**  
- **Office 365 (Microsoft 365)**  
- **SQL Server**  
- **SharePoint Server**  
- **Internet Information Services (IIS)**  

To view all available modules on your system, run:  
```powershell
Get-Module -ListAvailable
```  
Modules can be installed from the **PowerShell Gallery** using:  
```powershell
Install-Module -Name ModuleName -Scope CurrentUser -Force
```  
Once installed, you can use the module’s cmdlets just like built-in PowerShell commands.

Basic Syntax and Commands
PowerShell commands typically follow this structure:

Verb-Noun -Parameter1 Value1 -Parameter2 Value2

If you haven’t worked with PowerShell before, here are some essential commands to get started:

Get-Help — Provides information about cmdlets
Get-Command — Lists available commands
Get-Member — Shows the properties and methods of objects
