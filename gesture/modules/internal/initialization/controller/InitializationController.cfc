<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadFrameworkIntoScope" output="false" hint="I get the bootstrapper from the request scope and save the instance of Model-Glue into the application scope.">
	<cfargument name="event" />
	
	<cfset var mg = request._modelglue.bootstrapper.framework />
	<cfset var boot = request._modelglue.bootstrapper.bootstrapper />
	
	<cfset application[boot.applicationKey] = mg />
</cffunction>

</cfcomponent>