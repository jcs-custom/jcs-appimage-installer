# JCS AppImage Installer

The **JCS AppImage Installer** is a platform for developing and distributing in **AppImage format**.

The platform is designed to provide specialized application installers for
different user groups occupancy, i.e educational faculties, and productivity requirements.

### Installer Projects

```text
JCS AppImage Installer
        │
        ├── Office Staff
        │     └── JCS-Office-Staff-Installer-v4-x86_64.AppImage
        │
        ├── Law Faculty
        │     └── JCS-Law-Faculty-Student-V1-final.AppImage
        │
        ├── Education Science Faculty
        │     └── JCS-Education-Science-Faculty-Student-V1.AppImage
        │
        ├── Economic Faculty
        │     └── JCS-Economic.Faculty-students-ver1.0.AppImage
        │
        ├── Psychology Faculty
        │     └── JCS-Psychology-Faculty-students-installerVer01.AppImage
        │
        └── High School Humanities Social (IPS)
        │     └── JCS-High-School-HUMANITIES-SOCIAL-SCIENCE-students-installer.AppImage
        │
        └── High School STEM / Science (IPA)
              └── Future 
```

All will released through the JCS AppImage Installer platform. It's designed to ease user to install all applications needed base on user group occupancy (office, law faculty student, Education faculty student, etc) on Ubuntu / Debian / Lubuntu varian or equivalent Linux distributions. Fast, free, reliable and hardware freedom - perfect combo.       

## Story

This project began in response to the rising cost of new computers and laptops in 2026, combined with the hardware requirements of Windows 11, including the requirement for TPM 2.0 on supported systems.

As a result, many people are facing the difficult choice of purchasing new hardware simply to continue using a modern operating system. Many of my friends have experienced this situation. However, they afraid not be able to use Microsoft Office. They are not aware that OnlyOffice an WPS office which can be implemented in lubuntu are also be able to edit, open and create Microsoft office document format like *.docx or *.xls.

I suggested **Lubuntu** as an OS because it is lightweight, runs well on older hardware, provides a familiar desktop experience for Windows users, and supports many productivity applications.

The goal of this project is simple:

- **No need to buy a new laptop or PC**
- **No need to replace working hardware simply because it is too old for Windows 11**
- **No need to manually install dozens of applications one by one**
- **Use lightweight Linux software to extend the useful life of existing hardware**

---

## Installation

Please install the latest Debian/Ubuntu/Lubuntu OS on your SSD or HDD on your own (search YouTube for "how to install Lubuntu OS" if you need a guide). Once your system has Lubuntu installed, you can proceed with the installation process below.

FYI, Our installer will install all bundled applications, mostly via Flatpak. Because Lubuntu does not include Flatpak out of the box, you must set it up first:

1. Open your terminal (press Ctrl + Alt + T).
2. Update the package list:
```text
sudo apt update
```
Wait until the process finishes.

3. Install Flatpak:
```text
sudo apt install flatpak -y
```
Wait until the process finishes.

4. Add the Flathub repository:
```text
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
Wait until the process finishes.

5. Restart your computer so your desktop environment recognizes Flatpak integration.
6. Open Firefox browser to download your choice of installer from our release page and save it to your Downloads folder.
7. Right-click the downloaded AppImage file, go to Properties/Permissions, and check the box to make it executable (or run `chmod +x` on the file).
8. Double-click the AppImage to start the installer.
9. The installer will automatically check the system and install the applications and it's dependency necessary.

Applications that are already installed on your OS will be detected and skipped.
There is no need to manually install each application individually.

---

## Don't Want to Install Everything Yourself?

If you prefer a ready-to-use solution, you can order our **hardware SSD with enclosure**, pre-configured with the latest release of Lubuntu and all of the applications listed above.

We can also provide a **customized SSD configuration** based on your requirements. For inquiries and customization, please contact us via Telegram: **@Arievandjava**

---

Regards,

**Java Cyber Sovereignty**  
Jakarta, Indonesia
