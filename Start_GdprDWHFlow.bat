@echo on

REM Il bat permette di avviare l'esecuzione dei flussi selezionati nell'interfaccia html.
REM La comunicazione tra i processi attivati è garantita dallo scambio informativo
REM attraverso il file di interfaccia CeckDWHFlow.txt creato nella home del progetto.

REM variabili per la definizione del timestamp
set year=%date:~6,4%
set month=%date:~3,2%
set day=%date:~0,2%
set hour=%time:~0,2%
if "%time:~0,1%" == " " (set dtstamp=0%time:~1,1%) ELSE set dtstamp=%time:~0,2%
set minute=%time:~3,2%
set seconds=%time:~6,2%
set timestamp=%year%%month%%day%%dtstamp%%minute%%seconds%
REM Cancella il file di interfaccia
IF EXIST .\CeckDWHFlow.txt DEL /F .\CeckDWHFlow.txt
REM Scrive il timestamp nel file di interfaccia
echo START_FLOW=%timestamp% > .\CeckDWHFlow.txt


call robot -d Output --suite Start_DWHFlow  --test Start_GdprDWHFlowTestSession  Start_DWHFlow.robot
REM robot -T -d .\Output --suite Start_DWHFlow  --test Start_GdprDWHFlowTestSession  Start_DWHFlow.robot
