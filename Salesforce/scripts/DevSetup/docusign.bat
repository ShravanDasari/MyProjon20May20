echo %time% > 6.tmp
echo "Install DocuSign eSignature for Salesforce"
call sfdx force:package:install -p 04tA00000003HLnIAM -w 10 -r -u %name%
del 6.tmp
exit