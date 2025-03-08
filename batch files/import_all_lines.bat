@echo off
setlocal

set PGPASSWORD=P@gabriel7
set SHAPEFILE_DIR=E:\dev\geospatial-data\data\all_lines
set TARGET_SCHEMA=shape_files
set TARGET_TABLE=all_lines
set DB_NAME=census
set DB_USER=postgres
set DB_HOST=127.0.0.1

set PATH=%PATH%;"C:\Program Files\PostgreSQL\17\bin"

rem Use a counter and launch a new process for each file (or batch of files)
@REM for /f "delims=" %%f in (%SHAPEFILE_DIR%/Topological_Faces_Area_Hydrography_single.txt) do (
for /f "delims=" %%f in (%SHAPEFILE_DIR%/all_lines_all.txt) do (
    echo Importing %%f...
    rem first record import with:
    @REM shp2pgsql -I -D -s 4326 "%%f" %TARGET_SCHEMA%.%TARGET_TABLE% | psql -U %DB_USER% -d %DB_NAME% -h %DB_HOST%
    rem then import with:
    shp2pgsql -a -D -s 4326 "%%f" %TARGET_SCHEMA%.%TARGET_TABLE% | psql -U %DB_USER% -d %DB_NAME% -h %DB_HOST%
)

echo All imports started.
endlocal
pause
