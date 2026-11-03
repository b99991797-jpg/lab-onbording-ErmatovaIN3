@echo off
chcp 65001 >nul
title Аудит компьютера

REM Тема: Аудит клиентского компьютера
REM Фамилия: Ermatova
REM Дата: %date%

set "report=%~dp0pc_report.txt"
set "temp_apps=%temp%\apps_list.txt"

if exist "%temp_apps%" del "%temp_apps%"
if exist "%report%" del "%report%"

REM Подпрограмма для вывода (и на экран, и в файл)
:log
echo(%~1
echo(%~1>> "%report%"
exit /b

REM Начало отчета с датой и временем
call :log "=========================================="
call :log "  АУДИТ КОМПЬЮТЕРА"
call :log "  Дата: %date% %time%"
call :log "=========================================="
call :log ""

REM Операционная система
call :log "[Операционная система]"
set "os_name="
set "os_ver="
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance Win32_OperatingSystem).Caption"') do set "os_name=%%a"
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance Win32_OperatingSystem).Version"') do set "os_ver=%%a"
if defined os_name (call :log "Название: %os_name%") else (call :log "Название: Не удалось определить")
if defined os_ver (call :log "Версия: %os_ver%") else (call :log "Версия: Не удалось определить")
call :log ""

REM Процессор
call :log "[Процессор]"
set "cpu_name="
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance Win32_Processor | Select-Object -First 1).Name"') do set "cpu_name=%%a"
if defined cpu_name (call :log "%cpu_name%") else (call :log "Не удалось определить")
call :log ""

REM Оперативная память
call :log "[Оперативная память]"
set "ram_total="
set "ram_free="
for /f "tokens=*" %%a in ('powershell -command "[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)"') do set "ram_total=%%a"
for /f "tokens=*" %%a in ('powershell -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)"') do set "ram_free=%%a"
if defined ram_total (call :log "Всего: %ram_total% ГБ") else (call :log "Всего: Не удалось определить")
if defined ram_free (call :log "Свободно: %ram_free% ГБ") else (call :log "Свободно: Не удалось определить")
call :log ""

REM Диск C
call :log "[Диск C]"
set "disk_size="
set "disk_free="
for /f "tokens=*" %%a in ('powershell -command "[math]::Round((Get-Volume C).Size / 1GB, 2)"') do set "disk_size=%%a"
for /f "tokens=*" %%a in ('powershell -command "[math]::Round((Get-Volume C).SizeRemaining / 1GB, 2)"') do set "disk_free=%%a"
if defined disk_size (call :log "Общий размер: %disk_size% ГБ") else (call :log "Общий размер: Не удалось определить")
if defined disk_free (call :log "Свободно: %disk_free% ГБ") else (call :log "Свободно: Не удалось определить")
call :log ""

REM Сбор списка программ
call :log "[Сбор списка программ... Подождите]"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY" > "%temp_apps%"
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY" >> "%temp_apps%"

REM Проверка базового ПО
call :log "=========================================="
call :log "  ПРОВЕРКА БАЗОВОГО ПО"
call :log "=========================================="

set "found_office=0"
findstr /I /C:"Office" /C:"LibreOffice" /C:"OpenOffice" /C:"МойОфис" "%temp_apps%" >nul && set "found_office=1"
if %found_office%==0 (call :log "[!] Офисный пакет не найден. Рекомендуется установить MS Office или LibreOffice.") else (call :log "[OK] Офисный пакет установлен.")

set "found_browser=0"
findstr /I /C:"Chrome" /C:"Firefox" /C:"Yandex" /C:"Edge" "%temp_apps%" >nul && set "found_browser=1"
if %found_browser%==0 (call :log "[!] Браузер не найден. Рекомендуется установить Chrome или Яндекс.Браузер.") else (call :log "[OK] Браузер установлен.")

set "found_archiver=0"
findstr /I /C:"7-Zip" /C:"WinRAR" /C:"WinZip" "%temp_apps%" >nul && set "found_archiver=1"
if %found_archiver%==0 (call :log "[!] Архиватор не найден. Рекомендуется установить 7-Zip или WinRAR.") else (call :log "[OK] Архиватор установлен.")

set "found_pdf=0"
findstr /I /C:"Adobe Acrobat" /C:"Foxit" /C:"SumatraPDF" "%temp_apps%" >nul && set "found_pdf=1"
if %found_pdf%==0 (call :log "[!] PDF-ридер не найден. Рекомендуется установить Adobe Acrobat Reader или Foxit Reader.") else (call :log "[OK] PDF-ридер установлен.")

set "found_antivirus=0"
findstr /I /C:"Kaspersky" /C:"ESET" /C:"Dr.Web" /C:"Defender" "%temp_apps%" >nul && set "found_antivirus=1"
if %found_antivirus%==0 (call :log "[!] Антивирус не найден. Рекомендуется проверить защиту.") else (call :log "[OK] Антивирус установлен.")
call :log ""

REM Проверка излишнего ПО
call :log "=========================================="
call :log "  ПРОГРАММЫ, ТРЕБУЮЩИЕ ПРОВЕРКИ"
call :log "  (не относятся к базовым офисным задачам)"
call :log "=========================================="

call :log "Игры и игровые платформы:"
findstr /I /C:"Steam" /C:"Epic Games" /C:"Origin" /C:"Game" "%temp_apps%" >> "%report%"
findstr /I /C:"Steam" /C:"Epic Games" /C:"Origin" /C:"Game" "%temp_apps%"
findstr /I /C:"Steam" /C:"Epic Games" /C:"Origin" /C:"Game" "%temp_apps%" >nul
if errorlevel 1 call :log "  - Не обнаружено (отлично!)"

call :log "Торрент-клиенты:"
findstr /I /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" "%temp_apps%" >> "%report%"
findstr /I /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" "%temp_apps%"
findstr /I /C:"uTorrent" /C:"BitTorrent" /C:"qBittorrent" "%temp_apps%" >nul
if errorlevel 1 call :log "  - Не обнаружено (отлично!)"

call :log "Мессенджеры:"
findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%temp_apps%" >> "%report%"
findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%temp_apps%"
findstr /I /C:"Discord" /C:"Telegram" /C:"WhatsApp" /C:"Viber" /C:"Skype" "%temp_apps%" >nul
if errorlevel 1 call :log "  - Не обнаружено (отлично!)"
call :log ""
call :log "Примечание: наличие этих программ требует проверки администратором."

REM Удаление временного файла
if exist "%temp_apps%" del "%temp_apps%"

REM Итог
call :log ""
call :log "=========================================="
call :log "  АУДИТ ЗАВЕРШЕН"
call :log "  Отчет сохранен: %report%"
call :log "=========================================="

pause