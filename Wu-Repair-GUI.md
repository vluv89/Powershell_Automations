# 🛠️ Windows Update Repair Tool (PowerShell GUI)

A simple, powerful **PowerShell-based GUI tool** to reset and repair Windows Update components with one click.

Designed for IT Support, sysadmins, and advanced users to quickly resolve common Windows Update issues.

---

## 🚀 Features

✅ One-click Windows Update repair  
✅ Resets Windows Update services (wuauserv, BITS, cryptsvc)  
✅ Clears SoftwareDistribution cache  
✅ Resets Catroot2 folder  
✅ Runs DISM health repair  
✅ Runs SFC system scan  
✅ Real-time status output (GUI)  
✅ Auto-detects if reboot is required  
✅ Optional one-click reboot prompt  

---

## 🖥️ Preview

- Clean GUI interface  
- Live execution log  
- Simple "Run Repair" button  

---

## ⚙️ Requirements

- Windows 10 / Windows 11  
- PowerShell 5.1 or later  
- Administrator privileges  

---

## ▶️ How to Use It

➡️[Download the script](./Scripts/wu-repair-gui.ps1)

Open PowerShell as Administrator
Allow script execution (temporary) & Run the script

``` powershell
Set-ExecutionPolicy RemoteSigned -Scope Process

Set-ExecutionPolicy RemoteSigned -Scope Process
.\WU-Repair-GUI.ps1

```

Click "Run Repair" in the application


---

## 🧑‍💻 Use Cases

- Windows Update stuck downloading/installing
- Error codes during update
- Corrupted update cache
- Post-patch system instability
- General Windows servicing issues


---

