@echo off
chcp 65001 >nul

REM Тема: Диагностика клиентского компьютера
REM Фамилия: Ermatova
REM Дата: 01.11.2026

set "report=%~dp0pc_report.txt"
if exist "%report%" del "%report%"

echo Диагностика компьютера
echo 
echo Диагностика компьютера >> "%report%"
echo --------------------- >> "%report%"
echo. >> "%report%"

REM Сведения об операционной системе
echo.
echo Операционная система
echo Операционная система >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value') do (
    echo Название: %%a
    echo Название: %%a >> "%report%"
)
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value') do (
    echo Версия: %%a
    echo Версия: %%a >> "%report%"
)

REM Сведения о процессоре
echo.
echo Процессор
echo Процессор >> "%report%"
for /f "skip=1 delims=" %%a in ('wmic cpu get name') do if not "%%a"=="" (
    echo %%a
    echo %%a >> "%report%"
    goto :cpu_done
)
:cpu_done

REM Сведения об оперативной памяти
echo.
echo Оперативная память
echo Оперативная память >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /value') do set "ram_total=%%a"
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /value') do set "ram_free=%%a"

set /a ram_total_gb=%ram_total% / 1048576
set /a ram_free_gb=%ram_free% / 1048576

echo Всего памяти: %ram_total_gb% ГБ
echo Свободно памяти: %ram_free_gb% ГБ
echo Всего памяти: %ram_total_gb% ГБ >> "%report%"
echo Свободно памяти: %ram_free_gb% ГБ >> "%report%"

REM Свободное место на диске C
echo.
echo Диск C
echo Диск C >> "%report%"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get Size /value') do set "disk_size=%%a"
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get FreeSpace /value') do set "disk_free=%%a"

set /a disk_size_gb=%disk_size% / 1073741824
set /a disk_free_gb=%disk_free% / 1073741824

echo Общий размер: %disk_size_gb% ГБ
echo Свободно: %disk_free_gb% ГБ
echo Общий размер: %disk_size_gb% ГБ >> "%report%"
echo Свободно: %disk_free_gb% ГБ >> "%report%"

REM Список установленных программ
echo.
echo Установленные программы
echo Установленные программы >> "%report%"
echo Идёт поиск программ, это может занять несколько минут
wmic product get name,version >> "%report%"
wmic product get name,version

REM Финал
echo.
echo Отчёт сохранён в файл pc_report.txt
echo Отчёт сохранён. >> "%report%"

pause
