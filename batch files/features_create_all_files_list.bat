@echo off
setlocal

set SHAPEFILE_DIR=E:\dev\geospatial-data\data\feature_names

set OUTPUT_FILE=E:\dev\geospatial-data\data\feature_names\feature_names_all.txt

rem Create a temporary file list of all shapefiles
dir /s /b "%SHAPEFILE_DIR%\*.dbf" > "%OUTPUT_FILE%"