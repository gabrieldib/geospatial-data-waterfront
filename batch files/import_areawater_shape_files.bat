@echo off
setlocal

set PGPASSWORD=P@gabriel7
set SHAPEFILE_DIR=E:\dev\geospatial-data\data\feature_names
set TARGET_SCHEMA=shape_files
set TARGET_TABLE=feature_names
set DB_NAME=census
set DB_USER=postgres
set DB_HOST=127.0.0.1

set PATH=%PATH%;"C:\Program Files\PostgreSQL\17\bin"

rem Create a temporary file list of all shapefiles
dir /s /b "%SHAPEFILE_DIR%\*.shp" > filelist.txt

rem Use a counter and launch a new process for each file (or batch of files)
for /f "delims=" %%f in (filelist.txt) do (
    echo Importing %%f...
    rem first record import with:
    shp2pgsql -I -D -s 4326 "%%f" %TARGET_SCHEMA%.%TARGET_TABLE% | psql -U %DB_USER% -d %DB_NAME% -h %DB_HOST%
    rem then import with:
    @REM shp2pgsql -a -D -s 4326 "%%f" %TARGET_SCHEMA%.%TARGET_TABLE% | psql -U %DB_USER% -d %DB_NAME% -h %DB_HOST%
)

echo All imports started.
endlocal
pause