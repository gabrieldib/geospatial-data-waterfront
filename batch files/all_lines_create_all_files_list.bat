@echo off
setlocal

set SHAPEFILE_DIR=E:\dev\geospatial-data\data\all_lines

set OUTPUT_FILE=E:\dev\geospatial-data\data\all_lines\all_lines_all.txt

rem Create a temporary file list of all shapefiles
dir /s /b "%SHAPEFILE_DIR%\*.shp" > "%OUTPUT_FILE%"