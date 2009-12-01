<cfscript>
	writeOutput("Hello World!");
	ormReload();
	MainObject = EntityLoad("MainObject");
	writeDump(MainObject);
</cfscript>
