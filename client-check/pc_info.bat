@echo off
chcp 65001 >nul

REM Тема: Диагностика клиентского компьютера
REM Фамилия: Ermatova
REM Дата: 01.11.2026

set "report=%~dp0pc_report.txt"
if exist "%report%" del "%report%"

echo Диагностика компьютера
echo.
echo Диагностика компьютера >> "%report%"
echo. >> "%report%"

REM Операционная система
echo Операционная система
echo Операционная система >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /format:list ^| findstr Caption') do (
    echo Название: %%a
    echo Название: %%a >> "%report%"
)
for /f "tokens=2 delims==" %%a in ('wmic os get Version /format:list ^| findstr Version') do (
    echo Версия: %%a
    echo Версия: %%a >> "%report%"
)

REM Процессор
echo.
echo Процессор
echo Процессор >> "%report%"
for /f "skip=1 delims=" %%a in ('wmic cpu get name') do if not "%%a"=="" (
    echo %%a
    echo %%a >> "%report%"
    goto :cpu_done
)
:cpu_done

REM Оперативная память
echo.
echo Оперативная память
echo Оперативная память >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /format:list ^| findstr TotalVisibleMemorySize') do set "ram_total=%%a"
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /format:list ^| findstr FreePhysicalMemory') do set "ram_free=%%a"
set /a ram_total_gb=%ram_total% / 1048576
set /a ram_free_gb=%ram_free% / 1048576
echo Всего памяти: %ram_total_gb% ГБ
echo Свободно памяти: %ram_free_gb% ГБ
echo Всего памяти: %ram_total_gb% ГБ >> "%report%"
echo Свободно памяти: %ram_free_gb% ГБ >> "%report%"

REM Диск C
echo.
echo Диск C
echo Диск C >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get Size /format:list ^| findstr Size') do set "disk_size=%%a"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get FreeSpace /format:list ^| findstr FreeSpace') do set "disk_free=%%a"
set /a disk_size_gb=%disk_size% / 1073741824
set /a disk_free_gb=%disk_free% / 1073741824
echo Общий размер: %disk_size_gb% ГБ
echo Свободно: %disk_free_gb% ГБ
echo Общий размер: %disk_size_gb% ГБ >> "%report%"
echo Свободно: %disk_free_gb% ГБ >> "%report%"

REM Установленные программы
echo.
echo Установленные программы
echo Установленные программы >> "%report%"
echo Идёт поиск программ...
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY" >> "%report%"
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY"
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s | findstr "DisplayName" | findstr /V "HKEY" >> "%report%"

echo.
echo Отчёт сохранён в pc_report.txt
echo Отчёт сохранён. >> "%report%"

pause
