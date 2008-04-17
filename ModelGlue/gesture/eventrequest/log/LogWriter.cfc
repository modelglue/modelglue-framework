<cfcomponent output="false" hint="Handles writing of log entries to an EventContext.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="write" output="false">
	<cfargument name="eventContext" />
	<cfargument name="logMessage" />
	
	<cfset arrayAppend(eventContext.log, arguments.logMessage) />
</cffunction>

</cfcomponent>