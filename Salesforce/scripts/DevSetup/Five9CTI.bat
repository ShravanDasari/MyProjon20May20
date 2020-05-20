echo %time% > 5.tmp
echo "Install Five9 CTI"
call sfdx force:package:install -p 04t2K000000KSrfQAG -w 10 -r -u %name%
del 5.tmp
exit