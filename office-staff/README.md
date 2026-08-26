# JCS Office Staff Application [Staff Installer]

JCS Office Staff Application Installer is an installer in **AppImage format** designed to install applications that support everyday office productivity on **latest Ubuntu / Debian / Lubuntu OS variants or equivalent**.

## Story

This project began in response to the rising cost of new computers and laptops in 2026, combined with the hardware requirements of Windows 11, including the requirement for TPM 2.0 on supported systems.

As a result, many of working class people are struggling to purchasing new hardware simply to continue using  WIndows OS. Nowadays those paradigm isn't accurate. Modern Linux OS can do much better.

I suggested **Lubuntu** as an alternative because it is lightweight, runs well on older hardware, provides a familiar desktop experience for Windows users, and supports productivity applications such as **ONLYOFFICE** and **WPS Office**, which can open and edit Microsoft Office-compatible documents (i.e *.docx, *.doc, *.xlsx, *.xls, *.pptm, *.ppsx and *.potx ).

The goal of this project is simple:

- **No need to buy a new laptop or PC**
- **No need to replace working hardware simply because it is too old for Windows 11**
- **No need to manually install dozens of applications one by one**
- **Use lightweight Linux software to extend the useful life of existing hardware**

---

## JCS Office Staff Application Installer

### It will install all of these apps at once:

1. **ONLYOFFICE** — Office productivity suite for documents, spreadsheets, and presentations
2. **WPS Office** — Office productivity suite for documents, spreadsheets, presentations, and PDF files
3. **TextSnatcher** — Extracts and copies text from images and screen content using OCR
4. **GIMP** — Image editing and graphic manipulation
5. **Krita** — Digital painting and image creation
6. **OBS Studio** — Screen recording and video streaming
7. **Kdenlive** — Video editing
8. **LibreWolf** — Privacy-focused internet browser
9. **Google Chrome** — Internet browser
10. **Opera GX** — Internet browser with additional resource and media controls
11. **GnuCash** — Personal and small-business accounting
12. **Inkscape** — Vector graphics and illustration
13. **Scribus** — Desktop publishing and document layout
14. **Zoom** — Video conferencing and online meetings
15. **Microsoft Teams** — Communication, meetings, and collaboration
16. **Telegram** — Messaging and communication
17. **eOVPN** — VPN connection management
18. **ZapZap** — WhatsApp desktop client
19. **ClamUI** — Graphical interface for ClamAV antivirus
20. **draw.io** — Diagram and flowchart creation
21. **CopyQ** — Advanced clipboard manager
22. **PeaZip** — File archiving and compression utility
23. **Sticky Notes** — Desktop notes and reminders
24. **Logseq** — Knowledge management and note-taking
25. **Super Productivity** — Task management and productivity
26. **Osmo** — Personal organizer and productivity application
27. **Stirling-PDF** — PDF document management and processing
28. **Wireguird GUI** — Graphical interface for WireGuard VPN configuration

PLEASE NOTE:
Before you start:  please make sure you have a  stable internet connections during the installation process. It will take  for about 15-20 minutes more & less, depending on your bandwidth, processor and memory."Un-stable internet connection" could ruin the installation process.

## Installation

Please install the latest Debian/Ubuntu/Lubuntu OS on your SSD or HDD on your own (search YouTube for "how to install Lubuntu OS" if you need a guide). Once your system has Lubuntu installed, you can proceed with the installation process below.

FYI, `JCS-Office-Staff-Installer-v4-x86_64.AppImage` will install all bundled applications, mostly via Flatpak. Because Lubuntu does not include Flatpak out of the box, you must set it up first:

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
6. Open Firefox browser to download our installer from our release page and save it to your Downloads folder.
7. Right-click the downloaded AppImage file, go to Properties/Permissions, and check the box to make it executable (or run `chmod +x` on the file).
8. Double-click the AppImage to start the installer.
9. The installer will automatically check the system and install the applications and it's dependency necessary.

Applications that are already installed on your OS will be detected and skipped.
There is no need to manually install each application individually.

---

## Tested Hardware

This installer has been tested on:

- **Architecture:** x86_64
- **CPU:** Intel Core i3 (2nd Generation)
- **RAM:** 8 GB
- **OS:** Lubuntu 26.04 LTS
- **OTHERS:** i  don't have time yet to test it on Debian/Ubuntu or any other equivalent varian. Since Lubuntu based on Ubuntu, installing it to Debian/Ubuntu should be ok.

---

## Installer Format

**AppImage**

File:

`JCS-Office-Staff-Installer-v4-x86_64.AppImage`

---

## Don't Want to Install Everything Yourself?

If you prefer a ready-to-use solution, you can order our **hardware SSD with enclosure**, pre-configured with latest release of Lubuntu and all of the applications listed above. We can also provide a **customized SSD configuration** based on your requirements. For inquiries and customization, please contact us via Telegram: **@Arievandjava**

Regards,  
**Java Cyber Sovereignty**  
Jakarta, Indonesia

---

## SHA-256

```text
605d1e0eeafa589c564fdaa5923c782b226859f53cf986b870e9289bba4e493e
```

**Java Cyber Sovereignty**  
Jakarta, Indonesia
