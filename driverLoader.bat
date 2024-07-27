@echo off
reg add HKLM\SYSTEM\CurrentControlSet\Control\CI\Config /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x000000 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f
bcdedit /set hypervisorlaunchtype off
powershell.exe -ExecutionPolicy Bypass -Command "Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All"
sc stop vgk
RD /S /Q %LOCALAPPDATA%\DigitalEntitlements
RD /S /Q %APPDATA%\CitizenFX
RD /S /Q %LOCALAPPDATA%\FiveM\FiveM.app\citizen
RD /S /Q %LOCALAPPDATA%\FiveM\FiveM.app\logs
RD /S /Q %LOCALAPPDATA%\FiveM\FiveM.app\data\cache
REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography /v MachineGUID /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f
bcdedit /set hypervisorlaunchtype off
powershell.exe -ExecutionPolicy Bypass -Command "Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All"
reg add HKLM\SYSTEM\CurrentControlSet\Control\CI\Config /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x000000 /f
pause
@echo off
:folderclean
call :getDiscordVersion
cls
goto :xboxclean
:getDiscordVersion
for /d %%a in ("%appdata%\Discord\*") do (
   set "varLoc=%%a"
   goto :d1
)
:d1
for /f "delims=\ tokens=7" %%z in ('echo %varLoc%') do (
   set "discordVersion=%%z"
)
goto :EOF
:xboxclean
cls
powershell -Command "& {Get-AppxPackage -AllUsers xbox | Remove-AppxPackage}"
sc stop XblAuthManager
sc stop XblGameSave
sc stop XboxNetApiSvc
sc stop XboxGipSvc
sc delete XblAuthManager
sc delete XblGameSave
sc delete XboxNetApiSvc
sc delete XboxGipSvc
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /f
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTaskLogon" /disableL
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
cls
set hostspath=%windir%\System32\drivers\etc\hosts
echo 127.0.0.1 xboxlive.com >> %hostspath%
echo 127.0.0.1 user.auth.xboxlive.com >> %hostspath%
echo 127.0.0.1 presence-heartbeat.xboxlive.com >> %hostspath%
rd %userprofile%\AppData\Local\DigitalEntitlements /q /s
exit
goto :eof