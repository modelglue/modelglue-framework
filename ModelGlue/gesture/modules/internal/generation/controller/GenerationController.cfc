<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="modelglue.eventGenerator">

<cffunction name="generateEvent" output="false" hint="If the requested event doesn't exist, I generate its XML as well as code stubs for a listener and a view.">
	<cfargument name="event" />
	
	<cfset var eventName = arguments.event.getValue(arguments.event.getValue("eventValue")) />
	
	<cfif getModelGlue().getConfigSetting("generationEnabled") and not getModelGlue().hasEventHandler(eventName)>
		<cfset event.addTraceStatement("Event Generation", "Generating ""#eventName#""") />
		
		<cfset beans.modelglueEventGenerator.generateEvent(arguments.event) />
		
		<cfset arguments.event.addResult("configurationInvalidated") />
	</cfif>
</cffunction>

</cfcomponent>