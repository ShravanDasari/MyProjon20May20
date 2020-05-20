set /p name="Enter name for Scratch Org: "
cd ..
cd ..
call sfdx force:auth:web:login -a DevHubPROD
echo "Generating Scratch Org"
call sfdx force:org:create -v DevHubPROD -f config/project-scratch-def.json -a %name% -w 10 -s
call sfdx force:org:list
echo "Scratch org successfully created, begininning deployment. This can take some time. Please do not turn off your computer."
echo "Install Five9 List Sync Plus"
start call sfdx force:package:install -p 04t0a0000000ZcsAAE -w 10 -r -k s3qB$^\'}zmj+Nbu]:j -u %name%
echo "Install Nudebt"
start call sfdx force:package:install -p 04t1K0000033KwLQAU -w 10 -r -u %name%
echo "Install Five9 CTI"
start call sfdx force:package:install -p 04t2K000000KSrfQAG -w 10 -r -u %name%
echo "Install Five9 Relax"
start call sfdx force:package:install -p 04tE0000000ISOxIAO -w 10 -r -u %name%
echo "Install DocuSign eSignature for Salesforce"
start call sfdx force:package:install -p 04tA00000003HLnIAM -w 10 -r -u %name%
echo "Install Integrator Distributed Adaptor"
start call sfdx force:package:install -p 04t1N0000007o5rQAA -w 10 -r -u %name%
echo "Install A5 Fax"
start call sfdx force:package:install -p 04t1Y000000cYwMQAU -w 10 -r -u %name%
echo "Install Nintex DocGen"
start call sfdx force:package:install -p 04t2E000001IwzyQAC -w 10 -r -u %name%
echo "Deploy source folder force-app"
call sfdx force:source:deploy -w 200 -p force-app -u %name%
echo "Setup has finished, press any key to open your new scratch org. Please ensure that you save your username and set a memorable password!"
pause>nul
call sfdx:force:org:open