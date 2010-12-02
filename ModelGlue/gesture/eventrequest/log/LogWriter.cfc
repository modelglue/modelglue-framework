<cfcomponent output="false" hint="Handles writing of log entries to an EventContext.">

<cffunction name="init" output="false">
	<cfargument name="debugMode" type="string" required="true"/>
	<cfset variables.debugMode = arguments.debugMode />
	<cfreturn this />
</cffunction>

<cffunction name="write" output="false">
	<cfargument name="eventContext" />
	<cfargument name="logMessage" />
	
	<!---
		We want to log complex values when debug is set to verbose so convert it to a simple value with dump.
	 --->
	<cfif variables.debugMode IS "verbose" AND isSimpleValue(arguments.logMessage.message) IS false >
		<cfsavecontent variable="arguments.logMessage.message"><cfdump var="#arguments.logMessage.message#" /></cfsavecontent>
	</cfif>
	
	<!--- 
		Log simple values when debug isn't disabled'
	 --->
	<cfif variables.debugMode IS NOT "none" AND isSimpleValue(arguments.logMessage.message) IS true >	
		<cfset arrayAppend(eventContext.log, arguments.logMessage) />	
	</cfif>
	
</cffunction>


</cfcomponent>