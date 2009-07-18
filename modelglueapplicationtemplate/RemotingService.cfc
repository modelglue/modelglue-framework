<cfcomponent output="false" extends="ModelGlue.gesture.remoting.AbstractRemotingService" hint="Exposes your Model-Glue application to remote clients.">
	<cfsetting showdebugoutput="false">
<!---
If you use a file other than index.cfm as your application's template, change this line.
--->
<cfset template = "/modelglueapplicationtemplate/index.cfm" />

	<!---
	Create a method in this CFC with the same footprint as that of the base class method.
	This is to work around an apparant bug ColdFusion 8 which doesn't allow access to the base class from cfajaxproxy.
	--->
	<cffunction name="executeEvent" output="false" access="remote" returntype="struct">
		<cfargument name="eventName" type="string" required="true" />
		<cfargument name="values" type="struct" required="true" default="#structNew()#" >
		<cfargument name="returnValues" type="string" required="false" default="" />
	
		<cfreturn super.executeEvent(arguments.eventName, arguments.values, arguments.returnValues) />
	</cffunction>

</cfcomponent>