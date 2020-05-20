echo %time% > 2.tmp
echo "Install Integrator Distributed Adaptor"
call sfdx force:package:install -p 04t1N0000007o5rQAA -w 10 -r -u %name%
pause
del 2.tmp
exit