@echo off
setlocal
	cd cli
	set generator=%1.lua
	if exist "%generator%" (
		lua "%generator%" %2 %3 %4
	) else (
		echo Generator not found
	)
	cd ..
endlocal
