#!/usr/bin/env python3

import sys
import os
import subprocess

from PyQt6.QtWidgets import (
    QApplication,
    QWidget,
    QLabel,
    QPushButton,
    QVBoxLayout,
    QProgressBar,
    QStackedWidget,
)

from PyQt6.QtGui import QPixmap, QFont
from PyQt6.QtCore import Qt, QThread, pyqtSignal


# ============================================================
# JCS OFFICE STAFF INSTALLER
# ============================================================


def get_runtime_base():
    """
    Return the correct base directory depending on how
    the application is being executed.

    Development:
        project/source/ui/jcs_office_gui.py

    PyInstaller:
        dist/JCS-Office-GUI/JCS-Office-GUI

    AppImage:
        AppDir/usr/bin/jcs-office-installer
    """

    # --------------------------------------------------------
    # PyInstaller
    # --------------------------------------------------------

    if getattr(sys, "frozen", False):

        # PyInstaller extracts bundled resources here.
        if hasattr(sys, "_MEIPASS"):
            return sys._MEIPASS

        # Fallback to executable location.
        return os.path.dirname(
            os.path.abspath(sys.executable)
        )

    # --------------------------------------------------------
    # Normal Python execution
    # --------------------------------------------------------

    return os.path.dirname(
        os.path.abspath(__file__)
    )


def get_resource_path(relative_path):
    """
    Locate resources such as the JCS logo.

    Development:
        source/ui/../resources/

    PyInstaller:
        _MEIPASS/source/resources/

    AppImage:
        resources bundled inside the executable.
    """

    base = get_runtime_base()

    return os.path.join(
        base,
        relative_path
    )


def find_backend_installer():
    """
    Locate office-auto-install.sh.

    Development layout:

        project/
        ├── source/
        │   └── ui/
        │       └── jcs_office_gui.py
        │
        └── appimage-builder/
            └── AppDir/
                └── usr/
                    └── bin/
                        └── office-auto-install.sh


    AppImage layout:

        AppDir/
        └── usr/
            └── bin/
                ├── jcs-office-installer
                └── office-auto-install.sh
    """

    # ========================================================
    # DEVELOPMENT MODE
    # ========================================================

    if not getattr(sys, "frozen", False):

        script_dir = os.path.dirname(
            os.path.abspath(__file__)
        )

        development_appdir = os.path.abspath(
            os.path.join(
                script_dir,
                "../../appimage-builder/AppDir"
            )
        )

        development_script = os.path.join(
            development_appdir,
            "usr",
            "bin",
            "office-auto-install.sh"
        )

        if os.path.isfile(development_script):
            return development_script

    # ========================================================
    # PYINSTALLER / APPIMAGE MODE
    # ========================================================

    executable_dir = os.path.dirname(
        os.path.abspath(sys.executable)
    )

    # When the GUI executable is located at:

    # AppDir/usr/bin/jcs-office-installer

    # AppDir is two levels above usr/bin.

    packaged_appdir = os.path.abspath(
        os.path.join(
            executable_dir,
            "../.."
        )
    )

    packaged_script = os.path.join(
        packaged_appdir,
        "usr",
        "bin",
        "office-auto-install.sh"
    )

    if os.path.isfile(packaged_script):
        return packaged_script

    # ========================================================
    # FINAL FALLBACK
    # ========================================================

    possible_locations = [

        os.path.join(
            executable_dir,
            "office-auto-install.sh"
        ),

        os.path.join(
            executable_dir,
            "../office-auto-install.sh"
        ),

        os.path.join(
            executable_dir,
            "../../office-auto-install.sh"
        ),
    ]

    for path in possible_locations:

        path = os.path.abspath(path)

        if os.path.isfile(path):
            return path

    return None


# ============================================================
# INSTALLATION THREAD
# ============================================================


class InstallerThread(QThread):

    output = pyqtSignal(str)

    finished = pyqtSignal(int)

    def run(self):

        installer = find_backend_installer()

        # ----------------------------------------------------
        # Backend not found
        # ----------------------------------------------------

        if not installer:

            self.output.emit(
                "ERROR: Office installer backend not found."
            )

            self.finished.emit(1)

            return

        # ----------------------------------------------------
        # Make sure backend is executable
        # ----------------------------------------------------

        if not os.access(installer, os.X_OK):

            self.output.emit(
                "ERROR: Office installer is not executable."
            )

            self.finished.emit(1)

            return

        self.output.emit(
            "Starting JCS Office installation..."
        )

        # ----------------------------------------------------
        # Run backend
        #
        # stdout/stderr are captured so the user does not
        # receive a terminal window.
        # ----------------------------------------------------

        try:

            process = subprocess.Popen(
                [installer],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1,
                universal_newlines=True
            )

        except Exception as error:

            self.output.emit(
                "ERROR: Unable to start installer."
            )

            self.output.emit(
                str(error)
            )

            self.finished.emit(1)

            return

        # ----------------------------------------------------
        # Read backend output
        # ----------------------------------------------------

        if process.stdout:

            for line in process.stdout:

                line = line.strip()

                if line:

                    self.output.emit(
                        line
                    )

        process.wait()

        self.finished.emit(
            process.returncode
        )


# ============================================================
# MAIN GUI
# ============================================================


class JCSOfficeGUI(QWidget):

    def __init__(self):

        super().__init__()

        self.thread = None

        # ----------------------------------------------------
        # Window
        # ----------------------------------------------------

        self.setWindowTitle(
            "JCS Office Staff Installer"
        )

        self.setFixedSize(
            430,
            390
        )

        # ----------------------------------------------------
        # Main stacked interface
        # ----------------------------------------------------

        self.pages = QStackedWidget()

        main_layout = QVBoxLayout()

        main_layout.setContentsMargins(
            20,
            20,
            20,
            20
        )

        main_layout.addWidget(
            self.pages
        )

        self.setLayout(
            main_layout
        )

        # ----------------------------------------------------
        # Build pages
        # ----------------------------------------------------

        self.build_welcome_page()

        self.build_installation_page()

        self.build_finished_page()

        self.pages.setCurrentIndex(
            0
        )

    # ========================================================
    # LOGO
    # ========================================================

    def create_logo(self):

        logo = QLabel()

        # ----------------------------------------------------
        # Correct logo path
        # ----------------------------------------------------

        logo_path = get_resource_path(
            "source/resources/logo-jcs-final.png"
        )

        pixmap = QPixmap(
            logo_path
        )

        # ----------------------------------------------------
        # Logo successfully loaded
        # ----------------------------------------------------

        if not pixmap.isNull():

            logo.setPixmap(
                pixmap.scaled(
                    115,
                    115,
                    Qt.AspectRatioMode.KeepAspectRatio,
                    Qt.TransformationMode.SmoothTransformation
                )
            )

        else:

            # ------------------------------------------------
            # If logo cannot be loaded, don't crash GUI.
            # ------------------------------------------------

            logo.setText(
                "JAVA CYBER\nSOVEREIGNTY"
            )

            logo.setAlignment(
                Qt.AlignmentFlag.AlignCenter
            )

        logo.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        return logo

    # ========================================================
    # WELCOME PAGE
    # ========================================================

    def build_welcome_page(self):

        page = QWidget()

        layout = QVBoxLayout()

        layout.setContentsMargins(
            5,
            5,
            5,
            5
        )

        layout.setSpacing(
            10
        )

        # ----------------------------------------------------
        # Logo
        # ----------------------------------------------------

        logo = self.create_logo()

        # ----------------------------------------------------
        # Title
        # ----------------------------------------------------

        title = QLabel(
            "JCS Office Staff Installer"
        )

        title.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        font = QFont()

        font.setPointSize(
            15
        )

        font.setBold(
            True
        )

        title.setFont(
            font
        )

        # ----------------------------------------------------
        # Description
        # ----------------------------------------------------

        description = QLabel(
            "Install essential office applications\n"
            "for your productivity"
        )

        description.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        # ----------------------------------------------------
        # Install button
        # ----------------------------------------------------

        self.install_button = QPushButton(
            "Install Now"
        )

        self.install_button.setMinimumHeight(
            45
        )

        button_font = QFont()

        button_font.setPointSize(
            11
        )

        button_font.setBold(
            True
        )

        self.install_button.setFont(
            button_font
        )

        self.install_button.clicked.connect(
            self.start_installation
        )

        # ----------------------------------------------------
        # Footer
        # ----------------------------------------------------

        footer = QLabel(
            "JAVA CYBER SOVEREIGNTY"
        )

        footer.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        # ----------------------------------------------------
        # Layout
        # ----------------------------------------------------

        layout.addWidget(
            logo
        )

        layout.addWidget(
            title
        )

        layout.addWidget(
            description
        )

        layout.addStretch()

        layout.addWidget(
            self.install_button
        )

        layout.addStretch()

        layout.addWidget(
            footer
        )

        page.setLayout(
            layout
        )

        self.pages.addWidget(
            page
        )

    # ========================================================
    # INSTALLATION PAGE
    # ========================================================

    def build_installation_page(self):

        page = QWidget()

        layout = QVBoxLayout()

        layout.setContentsMargins(
            5,
            20,
            5,
            20
        )

        layout.setSpacing(
            15
        )

        title = QLabel(
            "Installing Applications..."
        )

        title.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        font = QFont()

        font.setPointSize(
            14
        )

        font.setBold(
            True
        )

        title.setFont(
            font
        )

        self.status = QLabel(
            "Preparing installation..."
        )

        self.status.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        self.status.setWordWrap(
            True
        )

        self.progress = QProgressBar()

        # Indeterminate progress bar
        self.progress.setRange(
            0,
            0
        )

        wait_button = QPushButton(
            "Please wait..."
        )

        wait_button.setEnabled(
            False
        )

        layout.addStretch()

        layout.addWidget(
            title
        )

        layout.addWidget(
            self.status
        )

        layout.addWidget(
            self.progress
        )

        layout.addStretch()

        layout.addWidget(
            wait_button
        )

        page.setLayout(
            layout
        )

        self.pages.addWidget(
            page
        )

    # ========================================================
    # FINISHED PAGE
    # ========================================================

    def build_finished_page(self):

        page = QWidget()

        layout = QVBoxLayout()

        layout.setContentsMargins(
            5,
            20,
            5,
            20
        )

        layout.setSpacing(
            15
        )

        title = QLabel()

        title.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        font = QFont()

        font.setPointSize(
            15
        )

        font.setBold(
            True
        )

        title.setFont(
            font
        )

        self.finished_title = title

        message = QLabel()

        message.setAlignment(
            Qt.AlignmentFlag.AlignCenter
        )

        message.setWordWrap(
            True
        )

        self.finished_message = message

        close_button = QPushButton(
            "Close"
        )

        close_button.setMinimumHeight(
            42
        )

        close_button.clicked.connect(
            self.close
        )

        layout.addStretch()

        layout.addWidget(
            title
        )

        layout.addWidget(
            message
        )

        layout.addStretch()

        layout.addWidget(
            close_button
        )

        page.setLayout(
            layout
        )

        self.pages.addWidget(
            page
        )

    # ========================================================
    # START INSTALLATION
    # ========================================================

    def start_installation(self):

        self.install_button.setEnabled(
            False
        )

        self.pages.setCurrentIndex(
            1
        )

        self.status.setText(
            "Preparing installation..."
        )

        self.thread = InstallerThread()

        self.thread.output.connect(
            self.process_output
        )

        self.thread.finished.connect(
            self.installation_finished
        )

        self.thread.start()

    # ========================================================
    # BACKEND OUTPUT
    # ========================================================

    def process_output(self, text):

        if text.startswith(
            "Checking:"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "Already installed"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "Skipping:"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "Installing"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "Downloading"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "SUCCESS"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "FAILED"
        ):

            self.status.setText(
                text
            )

        elif text.startswith(
            "ERROR"
        ):

            self.status.setText(
                text
            )

    # ========================================================
    # INSTALLATION FINISHED
    # ========================================================

    def installation_finished(
        self,
        return_code
    ):

        if return_code == 0:

            self.finished_title.setText(
                "Installation Completed!"
            )

            self.finished_message.setText(
                "Your JCS Office Environment\n"
                "is ready to use."
            )

        else:

            self.finished_title.setText(
                "Installation Finished"
            )

            self.finished_message.setText(
                "Some applications could not be installed.\n"
                "Please check the system and try again."
            )

        self.pages.setCurrentIndex(
            2
        )


# ============================================================
# MAIN
# ============================================================


if __name__ == "__main__":

    app = QApplication(
        sys.argv
    )

    window = JCSOfficeGUI()

    window.show()

    sys.exit(
        app.exec()
    )
        
