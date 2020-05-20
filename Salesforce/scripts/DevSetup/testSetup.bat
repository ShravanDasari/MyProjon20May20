echo %time% 
set /p name="Enter name for Scratch Org: "
cd ..
cd ..
call sfdx force:auth:web:login -a DevHubPROD
echo "Generating Scratch Org"
call sfdx force:org:create -v DevHubPROD -f config/project-scratch-def.json -a %name% -w 10 -s
call sfdx force:org:list
echo "Scratch org successfully created, begininning deployment. This can take some time. Please do not turn off your computer."
cd scripts
cd DevSetup
start "nudebt" nudebt.bat
start "integrator" integrator.bat
start "Five9Relax" Five9Relax.bat
start "Five9LSP" Five9LSP.bat
start "Five9CTI" Five9CTI.bat
start "docusign" docusign.bat
start "docgen" docgen.bat
start "a5fax" a5fax.bat
:loop
@echo Installing
if not exist *.tmp goto :next
    @ping -n 5 127.0.0.1 > nul
goto loop
:next
cd ..
cd ..
@echo Done Installing.
echo "Deploy source folder force-app"
call sfdx force:source:deploy -w 200 -p force-app -u %name%
echo "Setup has finished, press any key to open your new scratch org. Please ensure that you save your username and set a memorable password!"
echo %time% 
pause>nul
call sfdx:force:org:open