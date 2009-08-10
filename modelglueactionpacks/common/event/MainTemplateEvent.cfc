<cfcomponent extends="ModelGlue.gesture.eventhandler.EventHandler">

<cffunction name="afterConfiguration" access="public" returntype="void" output="false" hint="Called after configuring the event handler.  Subclasses can use this to add messages, results, or views after they're added by something like a ModelGlue XML file.">
	<cfset var result = createObject("component", "ModelGlue.gesture.eventhandler.Result") />
	
	<cfset result.event = "template.main" />

	<cfset addResult(result) />
</cffunction>

</cfcomponent>