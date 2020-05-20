import subprocess
import csv
import shutil
import os
import sys
from lxml import etree
from io import StringIO

PIPE = subprocess.PIPE
print(str(sys.argv))
process = subprocess.Popen(['git diff --name-status master..'+sys.argv[1]], stdout=PIPE, stderr=PIPE, shell=True)
msg,err = process.communicate()
output = msg.decode("utf-8")

filesModified = []
sfFilesModified = []
filesDeleted = []
sfFilesDeleted = []
res = StringIO(output)
reader = csv.reader(res, delimiter='\t')
for row in reader:
    if (row[0] == "A" or row[0] == "M"):
        filesModified.append(row[1])
    if (row[0] == "D"):
        filesDeleted.append(row[1])

print("modified:")
for x in filesModified:
    print(x)
    pathArr = x.split('/')
    if pathArr[0] == 'force-app':
        sfFilesModified.append(pathArr)
print("\nDeleted:")
for x in filesDeleted:
    print(x)
    pathArr = x.split('/')
    if pathArr[0] == 'force-app':
        sfFilesDeleted.append(pathArr)
    
origPath = os.getcwd()
modPath = origPath+'/additiveChanges'
delPath = origPath+'/destructiveChanges'
if os.path.exists(delPath):
    shutil.rmtree(delPath)
if os.path.exists(modPath):
    shutil.rmtree(modPath)
os.mkdir(modPath)
os.mkdir(delPath)

if not sfFilesDeleted:
    print("no files deleted, moving to modified")
else:
    print("Generating destructive changes")
    #Create Empty Package.xml for deleted files
    ApexPresent = False
    componentPresent = False
    os.chdir(delPath)
    root = etree.Element("Package")
    root.set("xmlns","http://soap.sforce.com/2006/04/metadata")
    child1 = etree.SubElement(root,"version")
    child1.text="48.0"
    my_tree = etree.ElementTree(root)
    my_tree.write(delPath + '/package.xml', xml_declaration=True, encoding='UTF-8', pretty_print=True)

    #Create destructiveChanges.xml
    root = etree.Element("Package")
    root.set("xmlns","http://soap.sforce.com/2006/04/metadata")
    child1 = etree.SubElement(root, "version")
    child1.text="48.0"
    for x in sfFilesDeleted:
        if(x[len(x)-2]=="classes"):
            types = etree.SubElement(root, "types")
            child = etree.SubElement(types, "members")
            child.text = x[len(x)-1][0:-4]
            ApexPresent = True
        if(x[len(x)-2]=="components"):
            types2 = etree.SubElement(root, "types")
            child = etree.SubElement(types2, "members")
            child.text = x[len(x)-1][0:-10]
            componentPresent = True
    if ApexPresent:
        apex = etree.SubElement(types,"name")
        apex.text = "ApexClass"
    if componentPresent:
        component = etree.SubElement(types2, "name")
        component.text = "ApexComponent"
    destructive_tree = etree.ElementTree(root)
    destructive_tree.write(delPath + '/destructiveChanges.xml', xml_declaration=True, encoding='UTF-8', pretty_print=True)

if not sfFilesModified:
    print("no files modified")
else:
    print("Generating package for non-destructive changes")
    #Create Package.xml for modified files
    ApexPresent=False
    os.chdir(modPath)
    root = etree.Element("Package")
    root.set("xmlns","http://soap.sforce.com/2006/04/metadata")
    child1 = etree.SubElement(root, "version")
    child1.text="48.0"
    for x in sfFilesModified:
        if(x[len(x)-2]=="classes"):
            types = etree.SubElement(root, "types")
            child = etree.SubElement(types, "members")
            child.text = x[len(x)-1][0:-4]
            ApexPresent = True
        if(x[len(x)-2]=="components"):
            types2 = etree.SubElement(root, "types")
            child = etree.SubElement(types2, "members")
            child.text = x[len(x)-1][0:-10]
            componentPresent = True
    if ApexPresent:
        apex = etree.SubElement(types,"name")
        apex.text = "ApexClass"
    if componentPresent:
        component = etree.SubElement(types2,"name")
        component.text = "ApexComponent"
    my_tree = etree.ElementTree(root)
    my_tree.write(modPath + "/package.xml", xml_declaration=True, encoding='UTF-8', pretty_print=True)
#with open (delPath + '/package.xml', 'wb') as f:
#    f.write(etree.tostring(my_tree))


#process = subprocess.Popen(['sfdx force:project:create -n Changes'], stdout=PIPE, stderr=PIPE, shell=True)
#process.wait()
#print ("new project created")
#print (repr(output))
#os.chdir(newPath)