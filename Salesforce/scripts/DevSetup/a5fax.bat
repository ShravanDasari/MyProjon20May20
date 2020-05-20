echo %time% > 8.tmp
echo "Install A5 Fax"
call sfdx force:package:install -p 04t1Y000000cYwMQAU -w 10 -r -u %name%
del 8.tmp
exit