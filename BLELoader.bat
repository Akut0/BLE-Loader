@echo off
setlocal enabledelayedexpansion
set "home=%~dp0"
cd /d "%home%resource"
set "UIscooter=    "
set "ble=        "
set "inpname=%~nx1"
set "sfk=bin\sfk.exe"
set "py=bin\python\python.exe"
set mydate=%date:~-10,2%-%date:~-7,2%-%date:~-4%
if "%time:~-11,1%" == " " (
		set mytime=0%time:~1,1%-%time:~-8,2%-%time:~-5,2%
	) else (
		set mytime=%time:~-11,2%-%time:~-8,2%-%time:~-5,2%
		)
		


@echo "%1">tempdir
REM teste schreibzugriff
if exist tempdir (
		"%sfk%" replace tempdir -binary "/22//" -yes >NUL
		set /p input1=<tempdir
		del tempdir
	) else (
		color 4
		@echo Keine Schreibrechte^^!
		@echo bitte VLT Zipper als Administrator ausfuehren
		pause
		exit
		)
	)

REM Cleanup
for %%d in (info.txt params.txt FIRM.bin FIRM.bin.enc) do if exist %%d del %%d

for %%d in (bin\python\xiaotea.py bin\python\enc.py bin\python\dec.py) do if not exist %%d (
	@echo.
	@echo XiaoTea Script zum verschluesseln der Firmware nicht gefunden
	@echo bitte xiaotea.py dec.py enc.py downloaden
	@echo.
	@echo https://github.com/BotoX/xiaomi-m365-firmware-patcher/tree/master/xiaotea
	@echo.
	@echo speichern unter:
	@echo resource\bin\python\xiaotea.py
	@echo resource\bin\python\enc.py
	@echo resource\bin\python\dec.py
	pause
	exit
	)

:BLELSELSCO
set "UIscooter=    " & set "scooter="
call :BLELHEAD
@echo  Select Scooter model
@echo.
@echo  1 = Mi 1s
@echo  2 = Mi Pro2
@echo  3 = Mi 3
@echo  4 = Mi m365
@echo  5 = Mi Pro
@echo.

choice /c 12345b /n /m "Press [1],[2],[3],[4],[5] or [b] for back"
if "%ERRORLEVEL%" == "1" set "UIscooter=1s [BLE134]  " & set "scooter=1s"
if "%ERRORLEVEL%" == "2" set "UIscooter=Pro2 [BLE134]  " & set "scooter=Pro2"
if "%ERRORLEVEL%" == "3" set "UIscooter=Mi3 [BLE152]  " & set "scooter=Mi3"
if "%ERRORLEVEL%" == "4" set "UIscooter=m365 [BLE129]  " & set "scooter=m365"
if "%ERRORLEVEL%" == "5" set "UIscooter=Pro [BLE122]  " & set "scooter=Pro"
call :BLELHEAD
			if "%scooter%" == "1s" (
				set "appURL=https://files.scooterhacking.org/firmware/1s/BLE/BLE134.bin"
				set "appref=ScooterHacking.org"
				set "appmd5=35c96f1d83d97dc4bb842afcf030d8fe"
				set ble=134
			)
			if "%scooter%" == "Pro2" (
				set "appURL=https://files.scooterhacking.org/firmware/pro2/BLE/BLE134.bin"
				set "appref=ScooterHacking.org"
				set "appmd5=b3c9023a0c7d89fbad0bf3f0dcc3cc0f"
				set "ble=134"
			)
			if "%scooter%" == "Mi3" (
				set "appURL=https://files.scooterhacking.org/firmware/mi3/BLE/BLE152.bin"
				set "appref=ScooterHacking.org"
				set "appmd5=9650da1e091b8c438aea094c25648085"
				set "ble=152"
			)
			if "%scooter%" == "m365" (
				set "appURL=https://files.scooterhacking.org/firmware/m365/BLE/BLE129.bin"
				set "appref=ScooterHacking.org"
				set "appmd5=f5aade9096ac0a2c99dae79a4849aa98"
				set "ble=129"
			)
			if "%scooter%" == "Pro" (
				set "appURL=https://files.scooterhacking.org/firmware/pro/BLE/BLE122.bin"
				set "appref=ScooterHacking.org"
				set "appmd5=e8880676338e0a94cb8fb5f65b629d61"
				set "ble=122"
			)
			if not exist "files\BLE\%scooter%\App.bin" (
				
				@echo No BLE firmware file found
				@echo Downloading BLE firmware from^:
				@echo.
				@echo !appURL!
				@echo to^:
				@echo "files\BLE\%scooter%\App.bin"
				@echo.
				pause
				mkdir "files\BLE\%scooter%\"
				call :BLELDOWN "!appURL!" "files\BLE\%scooter%\App.bin"
				if not exist "files\BLE\%scooter%\App.bin" (
					@echo.
					%sfk% tell [red]Error^^![def] could not download file
					@echo.
					pause
					goto :BLELSELSCO
				)
				@echo verifying md5sum
				for /f %%m in ('%sfk% md5 files\BLE\%scooter%\App.bin') do if not ["%%m"] == ["!appmd5!"] (
					@echo.
					%sfk% tell [red]Error^^![def] download does not match expected md5sum
					@echo.
					if exist "files\BLE\%scooter%\App.bin" del "files\BLE\%scooter%\App.bin"
					pause
					goto :BLELSELSCO
				)
				@echo md5sum verified
				@echo.
				@echo Download successful
				@echo Thank^'s to !appref! ^<3
				@echo.
				
			REM end if not exist App	
			)
			
		if "%scooter%" == "1s" (
			set "OCDiofle=files\BLE\%scooter%\App.bin"
		)
		REM ------------------
		if "%scooter%" == "Pro2" (
			set "OCDiofle=files\BLE\%scooter%\App.bin"
		)
		REM ------------------
		if "%scooter%" == "Mi3" (
			set "OCDiofle=files\BLE\%scooter%\App.bin"
		)
		REM ------------------
		if "%scooter%" == "m365" (
			set "OCDiofle=files\BLE\%scooter%\App.bin"
		)
		REM ------------------
		if "%scooter%" == "Pro" (
			set "OCDiofle=files\BLE\%scooter%\App.bin"
		)
	
	if "%scooter%" == "Mi3" (
		set "spoofto=55
	) else (
		set "spoofto=57
	)
	@echo spoof new BLE to 1!spoofto! ^? ^(recommended^)
	choice /c yn /n /m "Press [y] to spoof and [n] to leave BLE untouched"
	if "!ERRORLEVEL!" == "1" (
		if exist "files\BLE\%scooter%\AppSpoofed.bin" del "files\BLE\%scooter%\AppSpoofed.bin" >NUL & set "ble=1!spoofto!"
		@echo dev: pro2;>info.txt
		@echo nam: BLE%ble% SPOOFED;>>info.txt
		@echo enc: B;>>info.txt
		@echo typ: BLE;>>info.txt
		@echo - Version: BLE1!spoofto!;>params.txt
		@echo.
		call :BLELHEAD
		call :BLELSPOOF
	) else (
		call :BLELHEAD
		@echo dev: pro2;>info.txt
		@echo nam: BLE%ble% SPOOFED;>>info.txt
		@echo enc: B;>>info.txt
		@echo typ: BLE;>>info.txt
		@echo - Version: BLE%ble%;>params.txt
		@echo.
	)

	goto :ENC

:BLELSPOOF
call :BLELMYDT
@echo %0 %mydate%_%mytime% >>BLELoader.log

@echo searching for version
@echo.
for /f %%f in ('%sfk% xhexfind "files\BLE\%scooter%\App.bin" -firsthit "/[1 byte]\x21\x01\x71\x01/" +filt -+0x "-line=1" -replace "_files\BLE\%scooter%\App.bin : hit at offset __" -replace "_ len 5__"') do @set veroffset=%%f
if "%veroffset%" == "" (
	for /f %%f in ('%sfk% xhexfind "files\BLE\%scooter%\App.bin" -firsthit "/[1 byte]\x21\x01\x71\x00/" +filt -+0x "-line=1" -replace "_files\BLE\%scooter%\App.bin : hit at offset __" -replace "_ len 5__"') do @set veroffset=%%f	
)
if "%veroffset%" == "" (
	%sfk% tell [red]Error^^![def] can not find version to spoof
	@echo %0 %mydate%_%mytime% ERROR^^! can not find version to spoof in "files\BLE\%scooter%\App.bin" >>BLELoader.log
	set "spoofed=false"
) else (
copy "files\BLE\%scooter%\App.bin" "files\BLE\%scooter%\AppSpoofed.bin" >NUL
%sfk% setbytes "files\BLE\%scooter%\AppSpoofed.bin" %veroffset% 0x%spoofto%21017101 -yes >NUL
set "spoofed=true"
%sfk% tell [green]Done[def] spoofed successfully to 1%spoofto%
@echo %0 %mydate%_%mytime% done, spoofed successfully "files\BLE\%scooter%\AppSpoofed.bin" to 1%spoofto% at offset=%veroffset% >>BLELoader.log
)

REM ------------------------BLELoader---------------------------

:BLELMYDT
set mydate=%date:~-10,2%-%date:~-7,2%-%date:~-4%
if "%time:~-11,1%" == " " (
		set mytime=0%time:~1,1%-%time:~-8,2%-%time:~-5,2%
	) else (
		set mytime=%time:~-11,2%-%time:~-8,2%-%time:~-5,2%
		)
	)
goto :eof
pause
exit

REM ------------------------BLELoader---------------------------

:BLELDOWN
call :BLELMYDT
@echo %0 %mydate%_%mytime% %1 %2 >>BLELoader.log
bin\curl.exe -s -L %1 -o %2
call :BLELHEAD
goto :eof
pause
exit

REM ------------------------BLELoader---------------------------

:ENC
copy "%home%resource\%OCDiofle%" FIRM.bin >NUL
%py% bin\python\enc.py FIRM.bin FIRM.bin.enc
for /f %%i in ("FIRM.bin.enc") do set "oupsz=%%~zi"
@echo.

REM Check File
if not exist FIRM.bin.enc (
		@echo Kritischer Fehler
		@echo Konnte Firmware nicht verschluesseln
		pause
		goto :BLELSELSCO
		)

if %oupsz% GTR 45912 (
		@echo %inpname% erfolgreich mit XiaoTea encrypted
	) else (
		@echo Kritischer Fehler
		@echo Verschluesselte FIRM.bin.enc ist kleiner als 45912 Bytes
		pause
		goto :BLELSELSCO
		)
	)

:MD5
for /f %%m in ('%sfk% md5 FIRM.bin') do @echo md5: %%m;>>info.txt
@echo.
@echo FIRM.bin Md5 erstellt
for /f %%m in ('%sfk% md5 FIRM.bin.enc') do @echo md5e: %%m;>>info.txt
@echo.
@echo FIRM.bin.enc Md5 erstellt
@echo.
@echo info.txt erfolgreich erstellt

:ZIP
%sfk% zip -yes "%home%BLE%ble%_%scooter%_%mydate%_%mytime%.zip" info.txt params.txt FIRM.bin FIRM.bin.enc >NUL
@echo.
@echo %home%BLE%ble%_%scooter%_%mydate%_%mytime%.zip erfolgreich erstellt
for %%d in (info.txt params.txt FIRM.bin FIRM.bin.enc) do del %%d
pause


:BLELHEAD
cls
@echo  ____     __       ____              __                           __     v1.0.0             
@echo /\  _\`\  /\ \     /\  _\`\           /\ \                         /\ \                 
@echo \ \ \L\ \\ \ \    \ \ \L\_\         \ \ \        ___      __     \_\ \     __   _ __  
@echo  \ \  _ '\ \ \  __\ \  _\L   _______\ \ \  __  / __\`\  /'__\`\   /'_\` \  /'__\`\/\\`
@echo   \ \ \L\ \\ \ \L\ \\ \ \L\ \/\______\\ \ \L\ \/\ \L\ \/\ \L\.\_/\ \L\ \/\  __/\ \ \/ 
@echo    \ \____/ \ \____/ \ \____/\/______/ \ \____/\ \____/\ \__/.\_\ \___,_\ \____\\ \_\ 
@echo     \/___/   \/___/   \/___/            \/___/  \/___/  \/__/\/_/\/__,_ /\/____/ \/_/                                                                                   
@echo Copy, pasted ^& edited code by Akuto ^| Based on the work of VooDooShamane
@echo  -------------------------------------------------------------------------
@echo  			^| Scooter=%UIscooter% ^| BLE=%ble% ^|
@echo  -------------------------------------------------------------------------
@echo.
goto :eof
pause
exit

REM ------------------------BLELoader---------------------------


pause