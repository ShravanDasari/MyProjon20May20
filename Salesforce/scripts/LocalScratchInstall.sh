#!/bin/bash

date +"%Y-%m-%d %T"
sfdx force:org:create --definitionfile=config/project-scratch-def.json --setalias=scratch-0517-v2 --setdefaultusername
date +"%Y-%m-%d %T"
sfdx force:user:password:generate -u scratch-0517-v2

date +"%Y-%m-%d %T"
echo "Install Nudebt"
sfdx force:package:install -p 04t1K0000033KwLQAU -w 10 -r
date +"%Y-%m-%d %T"
echo "Install Five9 CTI"
sfdx force:package:install -p 04t2K000000KSrfQAG -w 10 -r
date +"%Y-%m-%d %T"
echo "Install Five9 Relax"
sfdx force:package:install -p 04tE0000000ISOxIAO -w 10 -r
date +"%Y-%m-%d %T"
echo "Install Five9 List Sync Plus"
sfdx force:package:install -p 04t0a0000000ZcsAAE -w 10 -r -k s3qB\'}zmj+Nbu]:j
date +"%Y-%m-%d %T"
echo "Install DocuSign eSignature for Salesforce"
sfdx force:package:install -p 04tA00000003HLnIAM -w 10 -r
date +"%Y-%m-%d %T"
echo "Install Integrator Distributed Adaptor"
sfdx force:package:install -p 04t1N0000007o5rQAA -w 10 -r
date +"%Y-%m-%d %T"
echo "Install A5 Fax"
sfdx force:package:install -p 04t1Y000000cYwMQAU -w 10 -r
date +"%Y-%m-%d %T"
echo "Install Nintex DocGen"
sfdx force:package:install -p 04t2E000001IwzyQAC -w 10 -r
date +"%Y-%m-%d %T"
echo "Push source"
sfdx force:source:push -w 200
date +"%Y-%m-%d %T"
echo "Deploy folder force-app"
#sfdx force:source:deploy -w 200 -p force-app
date +"%Y-%m-%d %T"
echo "FINISH"
