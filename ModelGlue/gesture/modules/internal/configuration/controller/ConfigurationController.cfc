<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadInitialXMLModule" output="false" hint="I get the bootstrapper from the request scope and loads the initial module.">
	<cfargument name="event" />
	
	<cfset var mg = "" />
	<cfset var cfg = "" />
	<cfset var loader = "" />
	<cfset var loadedModules = structNew() />
	
	<!--- If we have a case of someone loading MG w/o their own XML file, consider empty string as an already-loaded module. --->
	<cfset loadedModules[""] = true >
	
	<cfset arguments.event.addTraceStatement("Configuration", "Loading Initial XML Module") />
	<cfset mg = getModelGlue() />
	<cfset cfg = mg.getInternalBean("modelglue.ModelGlueConfiguration") />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, cfg.getPrimaryModule(), loadedModules) />
	<cfset this.loaded = true />
</cffunction>

</cfcomponent>