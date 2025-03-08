@echo off
setlocal

set SHAPEFILE_DIR=E:\dev\geospatial-data\data\Topological_Faces_Area_Hydrography

set OUTPUT_FILE=E:\dev\geospatial-data\data\Topological_Faces_Area_Hydrography\Topological_Faces_Area_Hydrography_all.txt

rem Create a temporary file list of all shapefiles
dir /s /b "%SHAPEFILE_DIR%\*.dbf" > "%OUTPUT_FILE%"