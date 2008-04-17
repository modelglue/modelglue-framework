<cfcomponent output="false" hint="Handles writing of log entries to an EventContext while also printing simplified entries to the console.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="write" output="false">
	<cfargument name="eventContext" />
	<cfargument name="logMessage" />
	
	<cfset arrayAppend(eventContext.log, arguments.logMessage) />
	
	<cflog text="[#logMessage.type#][#getTickCount() - eventContext.created#ms] - #logMessage.message#" />
</cffunction>

</cfcomponent>