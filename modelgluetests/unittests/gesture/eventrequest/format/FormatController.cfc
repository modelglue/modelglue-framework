<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="addNamedResult" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.addResult("target") />
</cffunction>

<cffunction name="addFormatNamedResult" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.addResult("formatTarget") />
</cffunction>

<cffunction name="message" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var messageFormats = arguments.event.getValue("messageFormats") />
	
	<cfset messageFormats = listAppend(messageFormats, "none") />
	
	<cfset arguments.event.setValue("messageFormats", messageFormats) />
</cffunction>

<cffunction name="formatMessage" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var messageFormats = arguments.event.getValue("messageFormats") />
	
	<cfset messageFormats = listAppend(messageFormats, "format") />
	
	<cfset arguments.event.setValue("messageFormats", messageFormats) />
</cffunction>

</cfcomponent>