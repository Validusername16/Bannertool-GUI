@echo off
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
color 0f
SET bannertoolexe=notfound
SET banner=notfound
SET cgfx=notfound
SET icon=notfound
SET audio=notfound
SET bannersfiles=notfound
IF EXIST assets\banner.png SET banner=found
IF EXIST assets\banner.cgfx SET cgfx=found
IF EXIST assets\icon.png SET icon=found
IF EXIST assets\audio.wav SET audio=found

IF EXIST result\banner.bin SET result1=found
IF EXIST result\cgfx_banner.bin SET result2=found
IF EXIST result\icon.bin SET result3=found
IF EXIST result\info.smdh SET result4=found

IF [%banner%]==[found] SET bannersfiles=found
IF [%cgfx%]==[found] SET bannersfiles=found

echo Bannertool made by : Steveice10
echo Bannertool GUI v2.0.0 made by : Daniel
IF EXIST program\bannertool.exe SET bannertoolexe=found
IF [%bannertoolexe%]==[notfound] goto :bannertoolnotfound
echo.
:STARTOFEVERYTHING
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
call :ColorText 0e "Modes"
echo C : Clear Mode
echo B : Bannertool Mode
echo.
echo E : Exit
echo.
SET /p "MODE=Type your choice : "
echo.
IF [%MODE%]==[C] goto :ClearMode
IF [%MODE%]==[c] goto :ClearMode
IF [%MODE%]==[B] goto :BuildMode
IF [%MODE%]==[b] goto :BuildMode
IF [%MODE%]==[E] goto :ExitMode
IF [%MODE%]==[e] goto :ExitMode
call :ColorText 0c "Error"
echo Invalid option, Select an valid option.
echo.
goto :STARTOFEVERYTHING

:ExitMode
exit

:BuildMode
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
call :ColorText 0e "Found files"
echo.
IF [%banner%]==[found] call :ColorText 0a "banner.png - Found"
IF [%banner%]==[notfound] call :ColorText 0c "banner.png - Not Found"
IF [%cgfx%]==[found] call :ColorText 0a "banner.cgfx - Found"
IF [%cgfx%]==[notfound] call :ColorText 0c "banner.cgfx - Not Found"
IF [%icon%]==[found] call :ColorText 0a "icon.png - Found"
IF [%icon%]==[notfound] call :ColorText 0c "icon.png - Not Found"
IF [%audio%]==[found] call :ColorText 0a "audio.wav - Found"
IF [%audio%]==[notfound] call :ColorText 0c "audio.wav - Not Found"
echo.
IF [%bannersfiles%]==[notfound] goto :end
IF [%audio%]==[notfound] goto :end
IF [%icon%]==[notfound] goto :end
IF [%bannersfiles%]==[found] IF [%icon%]==[found] IF [%audio%]==[found] echo All needed files were found. Press enter to start building the files.
pause>output_log.txt
del output_log.txt
goto :next

:end
call :ColorText 0c "Error"
echo Missing files needed for build all the files. Make sure to have icon.png, audio.wav and banner.png or banner.cgfx on the folder assets. Press enter for exit
echo.
pause>output_log.txt
del output_log.txt
exit

:next
echo.
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
call :ColorText 0e "Specify the following info for icon.bin and info.smdh"
:chooseciainfo
echo.
SET /p "CIA_NAME=Name of the .cia : "
IF "%CIA_NAME%" == "" goto :wrongselect
SET /p "CIA_DESCRIPTION=Description of the .cia : "
IF "%CIA_DESCRIPTION%" == "" goto :wrongselect
SET /p "CIA_AUTHOR=Creator(s) of the .cia : "
IF "%CIA_AUTHOR%" == "" goto :wrongselect

echo.
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
echo CIA Name : %CIA_NAME%
echo CIA Description : %CIA_DESCRIPTION%
echo CIA Creator(s) : %CIA_AUTHOR%
echo.
:select
SET /p "CHOICE=Is this info correct? (y : yes, n : no) "
IF [%CHOICE%]==[y] goto :secondnext
IF [%CHOICE%]==[n] SET CIA_NAME=
IF [%CHOICE%]==[n] SET CIA_DESCRIPTION=
IF [%CHOICE%]==[n] SET CIA_AUTHOR=
IF [%CHOICE%]==[n] goto :next
echo.
call :ColorText 0c "Error"
echo Invalid option, Select an valid option.
echo.
goto :select

:secondnext
echo.
IF [%result1%]==[found] goto :askdelete
IF [%result2%]==[found] goto :askdelete
IF [%result3%]==[found] goto :askdelete
IF [%result4%]==[found] goto :askdelete

goto :continue

:askdelete
call :ColorText 0c "WARNING"
echo Previus generated files (like banner.bin, icon.bin and info.smdh) were found on the folder "result". Generate new files will overwrite those already generated files.
echo.
:selectoverwrite
SET /p "select=Overwrite and continue? (y : yes, n : no) "
IF [%select%]==[y] goto :secondthird
IF [%select%]==[n] goto :finish
echo.
call :ColorText 0c "Error"
echo Invalid option, Select an valid option.
echo.
goto :selectoverwrite

:secondthird
echo.
echo You selected continue and overwrite old files.
:delete
echo.
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
call :ColorText 0c "Deleting Files. . ."
IF [%result1%]==[found] del result\banner.bin
IF [%result1%]==[found] echo Deleted 1 file. "(result\banner.bin)"
IF [%result2%]==[found] del result\cgfx_banner.bin
IF [%result2%]==[found] echo Deleted 1 file. "(result\cgfx_banner.bin)"
IF [%result3%]==[found] del result\icon.bin
IF [%result3%]==[found] echo Deleted 1 file. "(result\icon.bin)"
IF [%result4%]==[found] del result\info.smdh
IF [%result4%]==[found] echo Deleted 1 file. "(result\info.smdh)"

IF EXIST "result" rd "result"

call :ColorText 0a "Successfully deleted files! Now the proccess of generate files will be started."
:continue
echo.
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
echo Generating files...
md temp
md result
IF [%banner%]==[found] "program\bannertool.exe" makebanner -i "assets\banner.png" -a "assets\audio.wav" -o "temp\banner.bnr"
IF [%cgfx%]==[found] "program\bannertool.exe" makebanner -ci "assets\banner.cgfx" -a "assets\audio.wav" -o "temp\cgfx_banner.bnr"
"program\bannertool.exe" makesmdh -i "assets\icon.png" -s "%CIA_NAME%" -l "%CIA_DESCRIPTION%" -p "%CIA_AUTHOR%" -o "temp\icon.icn"
IF [%banner%]==[found] copy temp\banner.bnr result
IF [%banner%]==[found] move /y "result\banner.bnr" "result\banner.bin"
IF [%cgfx%]==[found] copy temp\cgfx_banner.bnr result
IF [%cgfx%]==[found] move /y "result\cgfx_banner.bnr" "result\cgfx_banner.bin"
copy temp\icon.icn result
move /y "result\icon.icn" "result\icon.bin"
copy temp\icon.icn result
move /y "result\icon.icn" "result\info.smdh"
IF [%banner%]==[found] del temp\banner.bnr
IF [%cgfx%]==[found] del temp\cgfx_banner.bnr
del temp\icon.icn
rd temp
echo.
echo.
echo.
echo.
call :ColorText 0a "Successfully generated the files. The files can be found on the folder result. Press enter to exit"
pause>output_log.txt
del output_log.txt
exit

:finish
echo.
echo.
echo.
echo.
call :ColorText 0c "Canceled proccess of create files. Press enter to exit."
pause>output_log.txt
del output_log.txt
exit

:wrongselect
SET CIA_NAME=
SET CIA_DESCRIPTION=
SET CIA_AUTHOR=
echo.
call :ColorText 0c "Error"
echo You need to type something!
goto :chooseciainfo

:ClearMode
call :ColorText 0e "------------------=[BannerTool GUI]=------------------"
echo.
call :ColorText 0c "WARNING"
echo this will delete banner.bin, cgfx_banner.bin, icon.bin and info.smdh on the folder "result"
echo.
:clearmodeoptions
SET /p "clearmodechoice=Delete files? (y : yes, n : no) "
IF [%clearmodechoice%]==[y] goto :ClearModeWorking
IF [%clearmodechoice%]==[n] goto :GoBackToMainMenu
echo.
call :ColorText 0c "Error"
echo Invalid option, Select an valid option.
echo.
goto :clearmodeoptions

:ClearModeWorking
echo.
call :ColorText 0c "Deleting Files. . ."
IF [%result1%]==[found] del result\banner.bin
IF [%result1%]==[found] echo Deleted 1 file. "(result\banner.bin)"
IF [%result2%]==[found] del result\cgfx_banner.bin
IF [%result2%]==[found] echo Deleted 1 file. "(result\cgfx_banner.bin)"
IF [%result3%]==[found] del result\icon.bin
IF [%result3%]==[found] echo Deleted 1 file. "(result\icon.bin)"
IF [%result4%]==[found] del result\info.smdh
IF [%result4%]==[found] echo Deleted 1 file. "(result\info.smdh)"

IF EXIST "result" rd "result"

echo.
echo.
echo.
echo.
call :ColorText 0a "Successfully deleted files. Press enter to exit"
pause>output_log.txt
del output_log.txt
exit

:GoBackToMainMenu
echo You selected to not delete the files. Going back to Mode select
echo.
goto :STARTOFEVERYTHING

:bannertoolnotfound
echo.
call :ColorText 0c "Error"
echo "bannertool.exe" could not be found on the folder program. Make sure to download lastest version from https://github.com/Steveice10/bannertool/releases and to place it on the folder program and that the file is named "bannertool.exe". Press enter to exit.
pause>output_log.txt
del output_log.txt
exit

:ColorText
echo off
echo %DEL% > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof