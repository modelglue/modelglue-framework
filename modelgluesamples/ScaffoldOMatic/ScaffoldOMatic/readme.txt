Ant Script To Create New Model-Glue Application
=====================================================================
If you're using CFEclipse, or you know how to use Ant 
(http://ant.apache.org), just run build.xml to create a ready-to-go 
Model-Glue application.

To run it in CFEclipse, it's Alt-Shift-X -> Q

Instructions:
---------------------------------------------------------------------
1) Open build.properties file and set your webroot path

ie: newApplicationDirectory = C:/inetpub/wwwroot/

2) If running Ant via the command line:

C:\> ant -f c:\path\to\the\build.xml 

You will be shown some available help and then prompted for a project name.




Set the "newApplicationName" property's value to the datasource name 
of your new application directory.  The script will name the application 
(via <cfapplication>) the same thing - feel free to change it later.

Set the "newApplicationDirectory" to the directory where you'd like your
new application to go.

Run the script.


