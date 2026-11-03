@echo off
title PC Audit

set "report=%~dp0pc_report.txt"
set "temp_apps=%temp%\apps_list.txt"

if exist "%temp_apps%" del "%temp_apps%"
if exist "%report%" del "%report%"

echo ==========================================
echo   PC AUDIT REPORT
echo   Date: %date% %time%
echo ==========================================
echo.
echo ========================================== >> "%report%"
echo   PC AUDIT REPORT >> "%report%"
echo   Date: %date% %time% >> "%report%"
echo ========================================== >> "%report%"
echo. >> "%report%"

echo [Operating System]
echo [Operating System] >> "%report%"
powershell -command "(Get-CimInstance Win32_OperatingSystem).Caption"
powershell -command "(Get-CimInstance Win32_OperatingSystem).Caption" >> "%report%"
powershell -command "(Get-CimInstance Win32_OperatingSystem).Version"
powershell -command "(Get-CimInstance Win32_OperatingSystem).Version" >> "%report%"
echo.
echo. >> "%report%"

echo [Processor]
echo [Processor] >> "%report%"
powershell -command "(Get-CimInstance Win32_Processor | Select-Object -First 1).Name"
powershell -command "(Get-CimInstance Win32_Processor | Select-Object -First 1).Name" >> "%report%"
echo.
echo. >> "%report%"

echo [RAM]
echo [RAM] >> "%report%"
powershell -command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)"
powershell -command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)" >> "%report%"
powershell -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)"
powershell -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)" >> "%report%"
echo.
echo. >> "%report%"

echo [Disk C]
echo [Disk C] >> "%report%"
powershell -command "[math]::Round((Get-Volume C).Size / 1GB, 2)"
powershell -command "[math]::Round((Get-Volume C).Size / 1GB, 2)" >> "%report%"
powershell -command "[math]::Round((Get-Volume C).SizeRemaining / 1GB, 2)"
powershell -command "[math]::Round((Get-Volume C).SizeRemaining / 1GB, 2)" >> "%report%"
echo.
echo. >> "%report%"

echo [Collecting installed programs... Please wait]
echo [Collecting installed programs... Please wait] >> "%report%"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY" > "%temp_apps%"
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY" >> "%temp_apps%"

echo ==========================================
echo   BASIC SOFTWARE CHECK
echo ==========================================
echo ========================================== >> "%report%"
echo   BASIC SOFTWARE CHECK >> "%report%"
echo ========================================== >> "%report%"

set "found_office=0"
findstr /I /C:"Office" /C:"LibreOffice" /C:"OpenOffice" "%temp_apps%" >nul && set "found_office=1"
if %found_office%==0 (echo [!] Office suite not found. Recommended: MS Office or LibreOffice. & echo [!] Office suite not found. Recommended: MS Office or LibreOffice. >> "%report%") else (echo [OK] Office suite installed. & echo [OK] Office suite installed. >> "%report%")

set "found_browser=0"
findstr /I /C:"Chrome" /C:"Firefox" /C:"Yandex" /C:"Edge" "%temp_apps%" >nul && set "found_browser=1"
if %found_browser%==0 (echo [!] Browser not found. & echo [!] Browser not found. >> "%report%") else (echo [OK] Browser installed. & echo [OK] Browser installed. >> "%report%")

set "found_archiver=0"
findstr /I /C:"7-Zip" /C:"WinRAR" /C:"WinZip" "%temp_apps%" >nul && set "found_archiver=1"
if %found_archiver%==0 (echo [!] Archiver not found. Recommended: 7-Zip or WinRAR. & echo [!] Archiver not found. >> "%report%") else (echo [OK] Archiver installed. & echo [OK] Archiver installed. >> "%report%")

set "found_pdf=0"
findstr /I /C:"Adobe Acrobat" /C:"Foxit" /C:"SumatraPDF" "%temp_apps%" >nul && set "found_pdf=1"
if %found_pdf%==0 (echo [!] PDF reader not found. & echo [!] PDF reader not found. >> "%report%") else (echo [OK] PDF reader installed. & echo [OK] PDF reader installed. >> "%report%")

set "found_antivirus=0"
findstr /I /C:"Kaspersky" /C:"ESET" /C:"Dr.Web" /C:"Defender" "%temp_apps%" >nul && set "found_antivirus=1"
if %found_antivirus%==0 (echo [!] Antivirus not found. & echo [!] Antivirus not found. >> "%report%") else (echo [OK] Antivirus installed. & echo [OK] Antivirus installed. >> "%report%")
echo.
echo. >> "%report%"

echo ==========================================
echo   SOFTWARE REQUIRING REVIEW
echo ==========================================
echo ========================================== >> "%report%"
echo   SOFTWARE REQUIRING REVIEW >> "%report%"
echo ========================================== >> "%report%"

echo Games and gaming platforms:
echo Games and gaming platforms: >> "%report%"
findstr /I /C:"Steam" /C:"Epic Games" /C:"Origin" /C:"Game" "%temp_apps%" >> "%report%"
findstr /I /C:"Steam" /C:"Epic Games" /C:"Origin" /C:"Game" "%temp_apps%"
findstr /I /C:"Steam" /C:"Epic Games" /C:"Origin" /C:"Game" "%temp_apps%" >nul
if errorlevel 1 echo   - Not found (good!) & if errorlevel 1 echo   - Not found (good!) >> "%report%"

echo Torrent clients:
echo Torrent clients: >> "%report%"
findstr /I /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" "%temp_apps%" >> "%report%"
findstr /I /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" "%temp_apps%"
findstr /I /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" "%temp_apps%" >nul
if errorlevel 1 echo   - Not found (good!) & if errorlevel 1 echo   - Not found (good!) >> "%report%"

echo Messengers:
echo Messengers: >> "%report%"
findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%temp_apps%" >> "%report%"
findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%temp_apps%"
findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%temp_apps%" >nul
if errorlevel 1 echo   - Not found (good!) & if errorlevel 1 echo   - Not found (good!) >> "%report%"
echo.
echo. >> "%report%"
echo Note: presence of these programs requires administrator review.
echo Note: presence of these programs requires administrator review. >> "%report%"

if exist "%temp_apps%" del "%temp_apps%"

echo.
echo ==========================================
echo   AUDIT COMPLETED
echo   Report saved: %report%
echo ==========================================
echo.
echo ========================================== >> "%report%"
echo   AUDIT COMPLETED >> "%report%"
echo   Report saved: %report% >> "%report%"
echo ========================================== >> "%report%"

pause