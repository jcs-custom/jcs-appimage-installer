# JCS - Economic Faculty [Students Installer]


This is an installer application to install apps & tools that are widely used by students who are attending in Economic Faculty.  It could be useful to support daily/everyday students productivity on **latest Ubuntu / Debian / Lubuntu OS variants or equivalent**. 

## Story

This project began in response to the rising cost of new computers and laptops in 2026, combined with the hardware requirements of Windows 11, including the requirement for TPM 2.0 on supported systems.

As a result, many people are facing the difficult choice of purchasing new hardware simply to continue using a modern operating system. Many of my friends who have a kids in university experienced struggling  to buy new pc/laptop just to be able use Windows OS. Nowadays those paradigm isn't accurate. Modern Linux OS can do much better.

I suggested **Lubuntu** as an alternative because it is lightweight, runs well on older hardware, provides a familiar desktop experience for Windows users, and supports productivity applications such as **ONLYOFFICE** and **WPS Office**, which can open and edit Microsoft Office-compatible documents (i.e *.docx, *.doc, *.xlsx, *.xls, *.pptm, *.ppsx and *.potx).

The goal of this project is simple:

- **No need to buy a new laptop or PC**
- **No need to replace working hardware simply because it is too old for Windows 11**
- **No need to manually install dozens of applications one by one**
- **Use lightweight Linux software to extend the useful life of existing hardware**

---

## JCS - Economic Faculty [Students Installer]

### It will install all of these apps at once:

1. ONLYOFFICE  (Word processing, spreadsheets, presentations and document creation)
2. WPS Office  (Word processing, spreadsheets, presentations and document creation)
3. TextSnatcher  (OCR — extracting text from images, photographs and screenshots)
4. GIMP  (Image editing, scientific illustrations and graphics)
5. Krita  (Digital painting, illustration and scientific artwork)
6. Obsidian  (Powerful knowledge base that works on top of a local folder of plain text Markdown files)
7. Discord  (All in one messaging, voice, and video client)
8. DigiKam  (Digital photo management application)
9. OBS Studio  (Screen recording, live streaming and project demonstration)
10. Kdenlive  (Non-linear video editing and science-project video production)
11. LibreWolf  (Privacy-focused web browsing and online research)
12. Google Chrome  (General web browsing, research and web applications)
13. Opera GX  (Web browsing and digital-content activities)
14. GnuCash  (Small-business accounting and bookkeeping)
15. Inkscape  (Vector graphics, diagrams and technical illustrations)
16. Scribus  (Desktop publishing, posters and document layout)
17. Zotero  (managing references and research materials)
18. Anki  (Program which makes remembering things easy)
19. ticktick  (Powerful to-do & task management app with seamless cloud synchronization across all your devices)
20. todoist  (Simple yet powerful to do list, habit tracker & reminders)
21. Standard Notes  (simple and private notes app)
22. Zoom  (Online meetings, classes and collaboration)
23. Microsoft Teams  (Online meetings, classes and collaboration)
24. Telegram  (Messaging, communication and group collaboration)
25. ZapZap  (Whatassap Chatting and messaging)
26. ClamUI  (Graphical ClamAV malware scanning)
27. draw.io  (Diagramming tool. Create flowcharts, process diagrams)
28. CopyQ  (Clipboard manager with editing and scripting features)
29. PeaZip  (Archive manager utility)
30. Sticky Note  (To create flying notes on desktop) 
31. LogSec  (A local-first, non-linear, outliner notebook)
32. Joplin  (Open source note taking and to-do application)
33. Rnote  (Vector-based drawing app for sketching, handwritten notes and to annotate documents and pictures)
34. QGIS Desktop  (Open Source Geographic Information System (GIS)) 
35. Marble  (Virtual globe and world atlas)
36. KGeography  (Geography learning tool, which allows you to learn about the political divisions of some countries)
37. HomeBank  (Assist you to manage your personal accounting)
38. Notion  (All-in-one productivity and workspace application.)
39. jamovi  (Advanced, real-time, statisticial spreadsheet, providing a suite of common statistical methods such as descriptives, t-tests, ANOVAs, correlation matrices, proportion tests, contingency tables, and factor analysis)
40. JASP  (Cross platform statistical software program with a state-of-the-art graphical user interface)
41. eOVPN  (VPN configuration manager)
42. Odoo  (Modular Enterprise Resource Planning (ERP) and business management software)
43. Stirling-PDF  (PDF manipulation, conversion, merging, splitting and document processing)
44. RStudio  (Integrated development environment (IDE) designed specifically for statistical computing, data science, and quantitative research)
45. Figma  (Product designers, software developers, and product managers to map out websites, mobile apps, design systems, and visual interfaces)
46. Tusk  (Manage daily tasks, form habits, and schedule recurring routines)
47. Python [Pandas/NumPy]	  (open-source programming ecosystem that forms the backbone of modern data science, quantitative finance, and machine learning)


PLEASE NOTE:
Before you start, please make sure you have a  stable internet connections during the installation process. It will take  for about 15-20 minutes more & less, depending on your bandwidth, processor and memory."Un-stable internet connection" could ruin the installation process.

---

## Installation

Please install the latest Debian/Ubuntu/Lubuntu OS on your SSD or HDD on your own (search YouTube for "how to install Lubuntu OS" if you need a guide). Once your system has Lubuntu installed, you can proceed with the installation process below.

FYI, `JCS-Economic.Faculty-students-ver1.0.AppImage` will install all bundled applications, mostly via Flatpak. Because Lubuntu does not include Flatpak out of the box, you must set it up first:

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

`JCS-Economic.Faculty-students-ver1.0.AppImage`

---

## Don't Want to Install Everything Yourself?

If you prefer a ready-to-use solution, you can order our **hardware SSD with enclosure**, pre-configured with latest release of Lubuntu and all of the applications listed above. We can also provide a **customized SSD configuration** based on your requirements. For inquiries and customization, please contact us via Telegram: **@Arievandjava**

Regards,  
**Java Cyber Sovereignty**  
Jakarta, Indonesia

---

## SHA-256

```text
cb2d07588a46724ca36b47ca2e18d01ec61032bbe72cf360b6cb11a542bf3fe3
```  
