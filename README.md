# Windows Server 2025 Installation & Configuration (Desktop & Core)

## 1. Title & Outcome

Successfully deployed **Windows Server 2025 (Desktop Experience)** and **Server Core** virtual machines in VirtualBox 7.0.20, created administrative and local user accounts, installed VirtualBox Guest Additions, and validated functionality through GUI (Server Manager) and CLI (Core).

---

## 2. Problem / Objectives

To gain practical experience installing and configuring modern Windows Server operating systems in a virtualized environment, understanding both graphical (Desktop Experience) and command-line (Server Core) management workflows.

---

## 3. Environment & Prerequisites

| Component | Version / Details |
|------------|-------------------|
| Host OS | Windows 11 Pro 22H2 |
| Virtualization Platform | Oracle VM VirtualBox 7.0.20 + Extension Pack |
| Guest OS | Windows Server 2025 (Standard Evaluation – 180-day trial ISO) |
| Memory / CPU | 4 GB RAM (Desktop) / 2 GB RAM (Core), 2 vCPUs |
| Disk | 80 GB VDI (dynamically allocated, NTFS) |
| Credentials | Administrator / !QAZ1qaz!QAZ1qaz · User (jsmith) / #EDC3edc#EDC3edc |

---

## 4. Steps Summary

1. Downloaded **VirtualBox 7.0.20** and **Extension Pack**.
2. Created VM `Server 2025 Desktop` (4 GB RAM, 80 GB disk).
3. Attached Windows Server 2025 ISO and installed **Standard Evaluation (Desktop Experience)**.
4. Created Administrator account (`administrator / !QAZ1qaz!QAZ1qaz`).
5. Verified boot into Server Manager GUI.
6. Added local user account (`jsmith / #EDC3edc#EDC3edc`).
7. Installed VirtualBox Guest Additions (Desktop).
8. Created VM `Server 2025 Core` (2 GB RAM, 80 GB disk).
9. Installed Windows Server Core Edition.
10. Installed Guest Additions via CLI and validated with `sconfig`.
11. Took VM snapshots and backed up VM folders.

---

## 5. Evidence (Text-Only Proof)

### Evidence 01 — VM Creation (Desktop Edition)

* **What would be visible:** VirtualBox Manager showing "Server 2025 Desktop", Base Memory 4096 MB, Storage 80 GB VDI.

* **Text excerpt:**

  ```text
  Name: Server 2025 Desktop
  Base Memory: 4096 MB
  Processors: 2
  Storage: 80.00 GB (Virtual Disk Image)
  ```

* **Why this matters:** Confirms VM was provisioned with the required hardware specifications.

---

### Evidence 02 — Successful GUI Boot

* **What would be visible:** Windows Server Desktop environment with Server Manager Dashboard open.

* **Text excerpt:**

  ```text
  Server Manager – Local Server
  Computer Name: SERVER2025DESKTOP
  Windows Server Standard Evaluation
  OS Build: 26100.xxxx
  ```

* **Why this matters:** Demonstrates installation completion and graphical interface availability.

---

### Evidence 03 — Local User Creation

* **What would be visible:** User Accounts Control Panel listing Administrator and jsmith.

* **Text excerpt:**

  ```text
  Administrator
  jsmith (Local Account)
  ```

* **Why this matters:** Verifies account management functionality and custom user creation.

---

### Evidence 04 — Guest Additions Installer (Desktop)

* **What would be visible:** Installer prompt "Oracle VM VirtualBox Guest Additions 7.0.20 Setup".

* **Text excerpt:**

  ```text
  Welcome to the Oracle VM VirtualBox Guest Additions 7.0.20 Setup Wizard
  ```

* **Why this matters:** Confirms drivers and enhancements are being added for performance and shared clipboard support.

---

### Evidence 05 — Server Core Command Prompt

* **What would be visible:** Black CLI window displaying `C:\Windows\System32>` prompt after first boot.

* **Text excerpt:**

  ```text
  Microsoft Windows [Version 10.0.26100.1]
  (c) Microsoft Corporation. All rights reserved.
  C:\Windows\System32>
  ```

* **Why this matters:** Confirms successful installation of Server Core edition.

---

### Evidence 06 — Guest Additions Installer (Core)

* **What would be visible:** Command prompt with `VBoxWindowsAdditions.exe` execution output.

* **Text excerpt:**

  ```text
  Running VirtualBox Guest Additions installer...
  Installation successful. Please reboot your system now.
  ```

* **Why this matters:** Validates integration tools installation without GUI.

---

### Evidence 07 — `sconfig` User Creation

* **What would be visible:** sconfig menu and confirmation of user addition.

* **Text excerpt:**

  ```text
  Enter user name: jsmith
  The command completed successfully.
  ```

* **Why this matters:** Shows hands-on command-line administration and account management in Server Core.

---

## 6. Results & Validation

Both VMs booted successfully post-installation; network discovery enabled and Guest Additions functional. User accounts operated under expected permissions. Snapshots captured as "Initial Install with Tools" and VMs backed up to external storage.

---

## 7. Timeline / Activity Dates

* **2024-08-27 — Windows Server 2025 Desktop installation completed**
* **2024-08-27 — Administrator and local user accounts created**
* **2024-08-27 — VirtualBox Guest Additions installed (Desktop & Core)**
* **2024-08-27 — Snapshots and backups taken**

---

## 8. What I Learned

* Configured VirtualBox VMs with optimized resources and dynamic storage.
* Performed clean Windows Server installations for Desktop and Core variants.
* Used GUI and CLI tools (Server Manager and `sconfig`) for system setup.
* Practiced user and permission management in isolated environments.
* Applied snapshot and backup strategies for reliable VM recovery.

---

## 9. Troubleshooting Notes

* **Guest Additions installer did not auto-launch:** manually opened `D:\VBoxWindowsAdditions.exe`.
* **Execution policy warnings:** resolved by running PowerShell as Administrator.
* **Network adapter not detected post-install:** fixed via re-enabling "Bridged Adapter" in VM settings.
* **Slow installation on Core edition:** resolved by reducing other VM resource usage.

---

## 10. Author / Ownership

This project was performed hands-on by **Jaden Maciel-Shapiro** on **2024-08-27**, focusing on the installation and initial configuration of Windows Server 2025 in both Desktop and Core editions using VirtualBox. The repository serves as a technical portfolio artifact demonstrating system deployment and virtualization skills.
