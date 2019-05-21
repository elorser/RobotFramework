@echo on

REM Il bat permette di archiviare i log di esecuzione dei flussi selezionati nell'interfaccia html
REM utilizzando il timestamp (END_FLOW) generato al termine del flusso e memorizzato nel file di interfaccia .\CeckDWHFlow.txt

REM variabili per la definizione del timestamp
set year=%date:~6,4%
set month=%date:~3,2%
set day=%date:~0,2%
set hour=%time:~0,2%
if "%time:~0,1%" == " " (set dtstamp=0%time:~1,1%) ELSE set dtstamp=%time:~0,2%
set minute=%time:~3,2%
set seconds=%time:~6,2%
set timestamp=%year%%month%%day%%dtstamp%%minute%%seconds%
REM Scrive il timestamp nel file di interfaccia
echo END_FLOW=%timestamp% >> .\CeckDWHFlow.txt

mkdir .\Output\%timestamp%
copy log.html Output\%timestamp%
copy report.html Output\%timestamp%
copy output.xml Output\%timestamp%
