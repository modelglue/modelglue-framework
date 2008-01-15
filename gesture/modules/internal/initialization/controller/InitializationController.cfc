<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadFrameworkIntoScope" output="false" hint="I get the bootstrapper from the request scope and save the instance of Model-Glue into the application scope.">
	<cfargument name="event" />

	<cfset var mg = "" />
	<cfset var boot = "" />

	<cfset arguments.event.setValue("modelglueReloaded", request._modelglue.bootstrap.initializationRequest) />
	
	<cfif request._modelglue.bootstrap.initializationRequest>
		<cfset mg = request._modelglue.bootstrap.framework />
		<cfset boot = request._modelglue.bootstrap.bootstrapper />
		
		<cfset application[boot.applicationKey] = mg />
	</cfif>

</cffunction>

</cfcomponent>