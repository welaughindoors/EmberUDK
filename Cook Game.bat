call Binaries\Win32\UDK.com make -full -unattended -stripsource -nullrhi
if errorlevel 1 goto error

call Binaries\Win32\UDK.com CookPackages -full -platform=PC -nullrhi
if errorlevel 1 goto error

call Binaries\UnSetup.exe -GameCreateManifest
if errorlevel 1 goto error

call Binaries\UnSetup.exe -BuildGameInstaller
if errorlevel 1 goto error

:end

echo Build successful.
exit \b

:error

echo Build error!
exit \b 1