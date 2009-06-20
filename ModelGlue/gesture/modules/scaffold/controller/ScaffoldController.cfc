<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="modelglue.eventGenerator">

<cffunction name="generateScaffolds" output="false" hint="If specified by the config setting, I generate the scaffolds in the modelglue.xml files">
	<cfargument name="event" />
	
	<cfset var eventName = arguments.event.getValue(arguments.event.getValue("eventValue")) />
	
	<cfif not getModelGlue().hasEventHandler(eventName) and getModelGlue().getConfigSetting("generationEnabled")>
		<cfset event.addTraceStatement("Event Generation", "Generating ""#eventName#""") />
		
		<cfset beans.modelglueEventGenerator.generateEvent(arguments.event) />
		
		<cfset arguments.event.addResult("configurationInvalidated") />
	</cfif>
</cffunction>

</cfcomponent>