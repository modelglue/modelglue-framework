<cfcomponent output="false">

<!--- Application settings --->
<cfset this.name = "buster" />
<cfset this.sessionManagement = true>
<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>

<cffunction name="onSessionStart"  output="false">
	<!--- Not sure anyone'll ever need this...
	<cfset invokeSessionEvent("modelglue.onSessionStartPreRequest", session, application) />
	--->
	<!--- Set flag letting MG know it needs to broadcast onSessionStart before onRequestStart --->
	<cfset request._modelglue.bootstrap.sessionStart = true />
</cffunction>

<cffunction name="onSessionEnd" output="false">
	<cfargument name="sessionScope" type="struct" required="true">
	<cfargument name="appScope" 	type="struct" required="false">

	<cfset invokeSessionEvent("modelglue.onSessionEnd", arguments.sessionScope, appScope) />
</cffunction>

<cffunction name="invokeSessionEvent" output="false" access="private">
	<cfargument name="eventName" />
	<cfargument name="sessionScope" />
	<cfargument name="appScope" />

	<cfset var mgInstances = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator").findInScope(appScope) />
	<cfset var values = structNew() />
	<cfset var i = "" />

	<cfset values.sessionScope = arguments.sessionScope />

	<cfloop from="1" to="#arrayLen(mgInstances)#" index="i">
		<cfset mgInstances[i].executeEvent(arguments.eventName, values) />
	</cfloop>
</cffunction>


</cfcomponent>