<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadInitialXMLModule" output="false" hint="I get the bootstrapper from the request scope and loads the initial module.">
	<cfargument name="event" />
	
	<cfset var mg = "" />
	<cfset var cfg = "" />
	<cfset var loader = "" />

	<cfif arguments.event.getValue("modelglueReloaded")>	
		<cfset arguments.event.trace("Configuration", "Loading Initial XML Module") />
		<cfset mg = getModelGlue() />
		<cfset cfg = mg.getBean("modelglue.ModelGlueConfiguration") />
		<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
		
		<cfset loader.load(mg, cfg.getPrimaryModule()) />
	</cfif>
</cffunction>

</cfcomponent>