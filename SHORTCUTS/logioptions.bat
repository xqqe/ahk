start "" "C:\Program Files\LogiOptionsPlus\LogiOptionsPlus.exe"

taskkill /F /IM LogiOptionsPlus.exe

taskkill /F /IM logioptionsplus_agent.exe

taskkill /F /IM logioptionsplus_appbroker.exe

taskkill /F /IM logioptionsplus_updater.exe

sc stop "OptionsPlusUpdaterService"

start "" "C:\Program Files\LogiOptionsPlus\LogiOptionsPlus.exe"

pause