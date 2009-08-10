<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="setUp" output="false" access="public" returntype="void" hint="I set up the scaffolding">
		<cfargument name="event" />
			<!--- get rid of any existing configuration --->
			<!--- <cfset getModelGlue().getScaffoldManager().nukeConfigFile() /> --->
</cffunction>

<!--- <cffunction name="generateScaffolds" output="false" hint="If specified by the config setting, I generate the scaffolds in the modelglue.xml files">
	<cfargument name="event" />
	
	<cfset var eventName = arguments.event.getValue(arguments.event.getValue("eventValue")) />
	
	<cfif not getModelGlue().hasEventHandler(eventName) and getModelGlue().getConfigSetting("generationEnabled")>
		<cfset event.addTraceStatement("Event Generation", "Generating ""#eventName#""") />
		
		<cfset beans.modelglueEventGenerator.generateEvent(arguments.event) />
		
		<cfset arguments.event.addResult("configurationInvalidated") />
	</cfif>
</cffunction> --->

</cfcomponent>