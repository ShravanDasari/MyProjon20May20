echo %time% > 3.tmp
echo "Install Five9 Relax"
call sfdx force:package:install -p 04tE0000000ISOxIAO -w 10 -r -u %name%
del 3.tmp
exit