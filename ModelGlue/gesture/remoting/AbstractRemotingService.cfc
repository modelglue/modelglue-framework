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

<cffunction name="executeEvent" output="false" access="remote" returntype="struct">
	<cfargument name="eventName" type="string" required="true" />
	<cfargument name="values" type="struct" required="true" default="#structNew()#" >
	<cfargument name="returnValues" type="string" required="false" default="" />
		
	<cfset var i = "" />
	<cfset var event = getModelGlue().executeEvent(argumentCollection=arguments) />
	<cfset var result = structNew() />
	
	<cfloop list="#arguments.returnValues#" index="i">
		<cfset result[i] = event.getValue(i) />
	</cfloop>
	
	<cfreturn result />
</cffunction>

</cfcomponent>