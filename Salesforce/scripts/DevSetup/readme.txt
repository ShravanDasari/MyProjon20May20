PRE-REQUISITES:
- Ensure that you have VS Code installed
- Ensure that you have access to the Salesforce GitHub
- Ensure that you have the "BF Dev VSCode Pack" by "Vladislav Polovtsev" extension pack installed for VSCode
- Ensure that you have NodeJS installed on your machine (Type "node" in CMD to check, if NodeJS opens you are in buisiness)
- Ensure that you have SFDX installed on your machine (Type "sfdx" in CMD to check. If Salesforce CLI help is shown you are in buisiness)
	- If you do not have SFDX installed, run the following command: "npm install sfdx"
	- When the operation completes, run "sfdx" from CMD to ensure that salesforce CLI tools were installed correctly.
	
BEGIN WORK ON A NEW FEATURE:
1) Create a new branch from MASTER for your feature, following agreed naming conventions
	-Navigate to the Beyond Finance org on GitHub, and open the Salesforce repository.
	-Open the dropdown menu that reads "Branch: master" and enter what you would like to name your new branch
	-Select "Create branch X from "MASTER""
2) Clone your new branch to your local machine, and open the resulting folder in VSCode.
3) Open the Scripts\DevSetup folder and run the "setup.bat" script contained within.
4) Follow the instructions of the Batch Script. When prompted with a Salesforce login page, ensure that you log in with your PROD credentials.
5) Wait for the script to finish installing pre-requisites, and updating your scratch org.
6) Upon script completion, press any key to open your scratch org, and ensure that you note the email of the default user and set a password.
7) Begin working on your new feature!