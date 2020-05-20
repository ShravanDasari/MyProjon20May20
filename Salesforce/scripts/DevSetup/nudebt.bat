echo %time% > 1.tmp
echo "Install Nudebt"
call sfdx force:package:install -p 04t1K0000033KwLQAU -w 10 -r -u %name%
del 1.tmp
exit 