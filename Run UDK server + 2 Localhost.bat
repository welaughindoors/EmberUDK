%CD%\Binaries\UDKLift.exe server Level1.udk?game=EmberProject.EmberGameInfo?dedicated=true

TIMEOUT /T 2
"%CD%\Binaries\UDKLift.exe" 127.0.0.1 -PosX=0 -PosY=0 -ResX=800 -ResY=600 -WINDOWED -log

TIMEOUT /T 1
"%CD%\Binaries\UDKLift.exe" 127.0.0.1 -PosX=800 -PosY=0 -ResX=800 -ResY=600 -WINDOWED -log