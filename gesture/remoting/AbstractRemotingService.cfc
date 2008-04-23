<cfcomponent output="false" hint="Exposes Model-Glue application to remote clients.">

<cfset variables.locator = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator") />

<cffunction name="getModelGlue" output="false">
	<cfset var mg = "" />
	
	<!--- Bootstrap MG by invoking the main template but blocking event execution. --->
	<cfset request._modelglue.bootstrap.blockEvent = 1 />
	
	<cfmodule template="#template#" />
	
	<cfset mg = variables.locator.findInScope(application, request._modelglue.bootstrap.appKey) />
	
	<cfif not arrayLen(mg)>
		<cfthrow message="Can't locate Model-Glue instance named #request._modelglue.bootstrap.appKey# in application scope!" />
	</cfif>
	
	<cfreturn mg[1] />
</cffunction>

<cffunction name="executeEvent" output="false" access="remote">
	<cfargument name="eventName" type="string" required="true" />
	<cfargument name="values" type="struct" required="true" default="#structNew()#" >
	
	<cfreturn getModelGlue().executeEvent(argumentCollection=arguments) />
</cffunction>

<cffunction name="getEventValue" output="false" access="remote">
	<cfargument name="eventName" type="string" required="true" />
	<cfargument name="desiredValue" type="string" required="true" />
	<cfargument name="values" type="struct" required="true" default="#structNew()#" >
	
	<cfset var ec = getModelGlue().executeEvent(argumentCollection=arguments) />
	
	<cfreturn ec.getValue(arguments.desiredValue) />
</cffunction>

</cfcomponent>