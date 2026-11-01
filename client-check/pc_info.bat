@echo off
chcp 65001 >nul

REM Topic: Client PC diagnostics
REM Student: Ermatova
REM Date: 01.11.2026

set "report=%~dp0pc_report.txt"
if exist "%report%" del "%report%"

echo Diagnostics report
echo ------------------
echo Diagnostics report >> "%report%"
echo ------------------ >> "%report%"
echo. >> "%report%"

REM OS info
echo.
echo Operating System
echo Operating System >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value') do (
    echo Name: %%a
    echo Name: %%a >> "%report%"
)
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value') do (
    echo Version: %%a
    echo Version: %%a >> "%report%"
)

REM CPU info
echo.
echo Processor
echo Processor >> "%report%"
for /f "skip=1 delims=" %%a in ('wmic cpu get name') do if not "%%a"=="" (
    echo %%a
    echo %%a >> "%report%"
    goto :cpu_done
)
:cpu_done

REM RAM info
echo.
echo RAM
echo RAM >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value') do set "ram_total=%%a"
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /value') do set "ram_free=%%a"

set /a ram_total_gb=%ram_total% / 1048576
set /a ram_free_gb=%ram_free% / 1048576

echo Total RAM: %ram_total_gb% GB
echo Free RAM: %ram_free_gb% GB
echo Total RAM: %ram_total_gb% GB >> "%report%"
echo Free RAM: %ram_free_gb% GB >> "%report%"

REM Disk C info
echo.
echo Disk C
echo Disk C >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get Size /value') do set "disk_size=%%a"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get FreeSpace /value') do set "disk_free=%%a"

set /a disk_size_gb=%disk_size% / 1073741824
set /a disk_free_gb=%disk_free% / 1073741824

echo Total size: %disk_size_gb% GB
echo Free space: %disk_free_gb% GB
echo Total size: %disk_size_gb% GB >> "%report%"
echo Free space: %disk_free_gb% GB >> "%report%"

REM Installed programs
echo.
echo Installed programs
echo Installed programs >> "%report%"
echo Searching for programs, this may take a few minutes...
wmic product get name,version >> "%report%"
wmic product get name,version

REM Final
echo.
echo Report saved to pc_report.txt
echo Report saved. >> "%report%"

pause
