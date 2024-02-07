@echo off
echo Deletando Pasta CACHE...
echo -
rd /s /q "cache"
artifacts\FXServer.exe +set onesync on +set onesync_enableInfinity 1 +set onesync_enableBeyond 1 +set onesync_population 1 +set onesync_forceMigration 1 +set onesync_distanceCullVehicles  +set sv_lan 1 +set svgui_disable true +exec server.cfg