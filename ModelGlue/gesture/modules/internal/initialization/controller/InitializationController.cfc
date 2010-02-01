<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadFrameworkIntoScope" output="false" hint="I get the bootstrapper from the request scope and save the instance of Model-Glue into the application scope.">
	<cfargument name="event" />

	<cfset var mg = "" />
	<cfset var boot = "" />

	<cfif request._modelglue.bootstrap.initializationRequest>
		<cfset mg = request._modelglue.bootstrap.framework />
		<cfset boot = request._modelglue.bootstrap.bootstrapper />
		
		<cfset application[boot.applicationKey] = mg />
	</cfif>

</cffunction>

<cffunction name="loadHelpers" output="false" hint="I load helpers.">
	<cfset var inj = beans.modelglueHelperInjector />
	<cfset var mg = getModelGlue() />
	<cfset var mappings = mg.getConfigSetting("helperMappings") />
	<cfset var mapping = "" />
	<cfloop list="#mappings#" index="mapping">
		<cfset inj.injectPath(mg.helpers, mapping) />
	</cfloop>
</cffunction>

</cfcomponent>