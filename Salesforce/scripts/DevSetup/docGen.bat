echo %time% > 7.tmp
echo "Install Nintex DocGen"
call sfdx force:package:install -p 04t2E000001IwzyQAC -w 10 -r -u %name%
del 7.tmp
exit