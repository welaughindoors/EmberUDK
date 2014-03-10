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