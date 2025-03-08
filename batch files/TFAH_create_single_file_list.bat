@echo off
setlocal

set SHAPEFILE_DIR=E:\dev\geospatial-data\data\Topological_Faces_Area_Hydrography
set OUTPUT_FILE=E:\dev\geospatial-data\data\Topological_Faces_Area_Hydrography\Topological_Faces_Area_Hydrography_single.txt

rem Find the first .shp file and save to the specified output file
for /f "delims=" %%F in ('dir /b /s "%SHAPEFILE_DIR%\*.dbf" 2^>nul') do (
    echo %%F > "%OUTPUT_FILE%"
    goto :found
)

:found
echo First shapefile has been written to %OUTPUT_FILE%
endlocal