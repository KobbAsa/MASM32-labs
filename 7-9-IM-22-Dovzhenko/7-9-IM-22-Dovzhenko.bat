@echo off

ml /c /coff "7-9-IM-22-Dovzhenko-PublicExtern.asm"

ml /c /coff "7-9-IM-22-Dovzhenko.asm"

link /subsystem:windows "7-9-IM-22-Dovzhenko.obj" "7-9-IM-22-Dovzhenko-PublicExtern.obj"

7-9-IM-22-Dovzhenko.exe