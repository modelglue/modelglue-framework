<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadInitialXMLModule" output="false" hint="I get the bootstrapper from the request scope and loads the initial module.">
	
	<cfset var mg = request._modelglue.bootstrapper.framework />
	<cfset var boot = request._modelglue.bootstrapper.bootstrapper />

	<cfset var loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, boot.initialModulePath) />
</cffunction>

</cfcomponent>